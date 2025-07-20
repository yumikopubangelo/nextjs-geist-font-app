%% Railgun Optimizer
% Alat optimasi parameter railgun untuk mencapai target performa
% Author: Railgun Research Team

function railgun_optimizer()
    clear all; close all; clc;
    
    fprintf('=== Railgun Parameter Optimizer ===\n\n');
    
    %% Target Performa
    target_velocity = 15000;    % m/s (15 km/s)
    target_efficiency = 60;     % % (target efisiensi)
    max_length = 100;          % m (batasan panjang maksimum)
    max_current = 1000000;     % A (batasan arus maksimum)
    
    %% Parameter Range untuk Optimasi
    current_range = linspace(100000, max_current, 20);
    mass_range = linspace(0.05, 0.5, 15);
    length_range = linspace(30, max_length, 15);
    resistance_range = linspace(0.0001, 0.01, 10);
    
    %% Konstanta Fisik
    L_prime = 2.0e-06;  % H/m
    
    %% Inisialisasi Hasil
    best_velocity = 0;
    best_efficiency = 0;
    best_params = [];
    optimization_data = [];
    
    fprintf('Memulai optimasi parameter...\n');
    fprintf('Total kombinasi: %d\n', length(current_range) * length(mass_range) * ...
            length(length_range) * length(resistance_range));
    
    %% Loop Optimasi
    counter = 0;
    total_combinations = length(current_range) * length(mass_range) * ...
                        length(length_range) * length(resistance_range);
    
    for I = current_range
        for m = mass_range
            for L = length_range
                for R = resistance_range
                    counter = counter + 1;
                    
                    % Progress indicator
                    if mod(counter, 1000) == 0
                        fprintf('Progress: %.1f%%\n', counter/total_combinations*100);
                    end
                    
                    % Simulasi cepat
                    [velocity, efficiency] = quick_railgun_sim(I, m, L, R, L_prime);
                    
                    % Simpan data
                    optimization_data = [optimization_data; I, m, L, R, velocity, efficiency];
                    
                    % Cek apakah ini hasil terbaik
                    score = calculate_score(velocity, efficiency, target_velocity, target_efficiency);
                    best_score = calculate_score(best_velocity, best_efficiency, target_velocity, target_efficiency);
                    
                    if score > best_score
                        best_velocity = velocity;
                        best_efficiency = efficiency;
                        best_params = [I, m, L, R];
                    end
                end
            end
        end
    end
    
    %% Hasil Optimasi
    fprintf('\n=== Hasil Optimasi ===\n');
    fprintf('Parameter Terbaik:\n');
    fprintf('Arus: %.0f A (%.0f kA)\n', best_params(1), best_params(1)/1000);
    fprintf('Massa: %.3f kg\n', best_params(2));
    fprintf('Panjang: %.1f m\n', best_params(3));
    fprintf('Resistansi: %.6f Ohm\n', best_params(4));
    fprintf('\nPerforma:\n');
    fprintf('Kecepatan: %.2f m/s (%.2f km/s)\n', best_velocity, best_velocity/1000);
    fprintf('Efisiensi: %.2f%%\n', best_efficiency);
    
    %% Analisis Top 10
    fprintf('\n=== Top 10 Konfigurasi ===\n');
    scores = zeros(size(optimization_data, 1), 1);
    for i = 1:size(optimization_data, 1)
        scores(i) = calculate_score(optimization_data(i,5), optimization_data(i,6), ...
                                   target_velocity, target_efficiency);
    end
    
    [sorted_scores, idx] = sort(scores, 'descend');
    top_data = optimization_data(idx(1:10), :);
    
    fprintf('Rank | Arus(kA) | Massa(kg) | Panjang(m) | R(Ohm) | Vel(km/s) | Eff(%%)\n');
    fprintf('-----|----------|-----------|------------|--------|-----------|-------\n');
    for i = 1:10
        fprintf('%4d | %8.0f | %9.3f | %10.1f | %6.4f | %9.2f | %6.1f\n', ...
                i, top_data(i,1)/1000, top_data(i,2), top_data(i,3), ...
                top_data(i,4), top_data(i,5)/1000, top_data(i,6));
    end
    
    %% Visualisasi Hasil
    create_optimization_plots(optimization_data, target_velocity, target_efficiency);
    
    %% Simpan Hasil
    save('optimization_results.mat', 'optimization_data', 'best_params', ...
         'best_velocity', 'best_efficiency', 'top_data');
    
    fprintf('\nHasil optimasi disimpan ke optimization_results.mat\n');
end

%% Fungsi Simulasi Cepat
function [velocity, efficiency] = quick_railgun_sim(current, mass, length, resistance, L_prime)
    % Simulasi railgun sederhana untuk optimasi cepat
    
    % Gaya Lorentz rata-rata
    force = 0.5 * L_prime * current^2;
    
    % Percepatan
    acceleration = force / mass;
    
    % Waktu tempuh (asumsi percepatan konstan)
    time = sqrt(2 * length / acceleration);
    
    % Kecepatan akhir
    velocity = acceleration * time;
    
    % Batasi kecepatan maksimum (realistis)
    velocity = min(velocity, 20000);  % 20 km/s maksimum
    
    % Energi kinetik
    kinetic_energy = 0.5 * mass * velocity^2;
    
    % Energi yang hilang sebagai panas
    thermal_energy = current^2 * resistance * time;
    
    % Efisiensi
    total_energy = kinetic_energy + thermal_energy;
    if total_energy > 0
        efficiency = (kinetic_energy / total_energy) * 100;
    else
        efficiency = 0;
    end
    
    % Batasi efisiensi maksimum
    efficiency = min(efficiency, 100);
end

%% Fungsi Scoring
function score = calculate_score(velocity, efficiency, target_vel, target_eff)
    % Hitung skor berdasarkan kedekatan dengan target
    
    vel_score = 100 - abs(velocity - target_vel) / target_vel * 100;
    eff_score = 100 - abs(efficiency - target_eff) / target_eff * 100;
    
    % Bobot: 60% kecepatan, 40% efisiensi
    score = 0.6 * max(0, vel_score) + 0.4 * max(0, eff_score);
end

%% Fungsi Visualisasi
function create_optimization_plots(data, target_vel, target_eff)
    figure('Position', [100, 100, 1400, 1000]);
    
    % Extract data
    current = data(:,1) / 1000;  % kA
    mass = data(:,2);
    length = data(:,3);
    resistance = data(:,4);
    velocity = data(:,5) / 1000;  % km/s
    efficiency = data(:,6);
    
    % Plot 1: Velocity vs Current
    subplot(2,3,1);
    scatter(current, velocity, 20, efficiency, 'filled');
    colorbar;
    xlabel('Arus (kA)');
    ylabel('Kecepatan (km/s)');
    title('Kecepatan vs Arus (warna = Efisiensi)');
    hold on;
    yline(target_vel/1000, 'r--', 'Target', 'LineWidth', 2);
    grid on;
    
    % Plot 2: Efficiency vs Mass
    subplot(2,3,2);
    scatter(mass, efficiency, 20, velocity, 'filled');
    colorbar;
    xlabel('Massa (kg)');
    ylabel('Efisiensi (%)');
    title('Efisiensi vs Massa (warna = Kecepatan)');
    hold on;
    yline(target_eff, 'r--', 'Target', 'LineWidth', 2);
    grid on;
    
    % Plot 3: Velocity vs Length
    subplot(2,3,3);
    scatter(length, velocity, 20, efficiency, 'filled');
    colorbar;
    xlabel('Panjang Rel (m)');
    ylabel('Kecepatan (km/s)');
    title('Kecepatan vs Panjang (warna = Efisiensi)');
    hold on;
    yline(target_vel/1000, 'r--', 'Target', 'LineWidth', 2);
    grid on;
    
    % Plot 4: Efficiency vs Resistance
    subplot(2,3,4);
    scatter(resistance, efficiency, 20, velocity, 'filled');
    colorbar;
    xlabel('Resistansi (Ohm)');
    ylabel('Efisiensi (%)');
    title('Efisiensi vs Resistansi (warna = Kecepatan)');
    hold on;
    yline(target_eff, 'r--', 'Target', 'LineWidth', 2);
    grid on;
    
    % Plot 5: Pareto Front (Velocity vs Efficiency)
    subplot(2,3,5);
    scatter(velocity, efficiency, 30, current, 'filled');
    colorbar;
    xlabel('Kecepatan (km/s)');
    ylabel('Efisiensi (%)');
    title('Pareto Front (warna = Arus)');
    hold on;
    xline(target_vel/1000, 'r--', 'Target Vel', 'LineWidth', 2);
    yline(target_eff, 'r--', 'Target Eff', 'LineWidth', 2);
    grid on;
    
    % Plot 6: 3D Surface
    subplot(2,3,6);
    % Buat grid untuk surface plot
    [C_grid, M_grid] = meshgrid(linspace(min(current), max(current), 20), ...
                                linspace(min(mass), max(mass), 20));
    V_grid = griddata(current, mass, velocity, C_grid, M_grid);
    surf(C_grid, M_grid, V_grid);
    xlabel('Arus (kA)');
    ylabel('Massa (kg)');
    zlabel('Kecepatan (km/s)');
    title('Surface Plot: Kecepatan vs Arus & Massa');
    colorbar;
    
    sgtitle('Analisis Optimasi Parameter Railgun', 'FontSize', 16);
end

% Jalankan optimizer
railgun_optimizer();

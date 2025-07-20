%% Railgun Trajectory Analyzer
% Analisis lintasan proyektil railgun dengan berbagai kondisi atmosfer
% Author: Railgun Research Team

function railgun_trajectory_analyzer()
    clear all; close all; clc;
    
    fprintf('=== Railgun Trajectory Analyzer ===\n\n');
    
    %% Parameter Input
    muzzle_velocities = [5000, 10000, 15000, 20000];  % m/s (5-20 km/s)
    launch_angles = [15, 30, 45, 60];  % derajat
    altitudes = [0, 5000, 10000, 20000];  % m (ketinggian peluncuran)
    
    %% Parameter Proyektil
    mass = 0.1;  % kg
    diameter = 0.02;  % m (2 cm)
    cross_section = pi * (diameter/2)^2;  % m^2
    drag_coeff = 0.1;  % Koefisien drag untuk proyektil hipersonik
    
    %% Konstanta
    g = 9.81;  % m/s^2
    R_earth = 6371000;  % m (radius bumi)
    
    %% Analisis untuk Setiap Kombinasi
    results = [];
    
    fprintf('Menganalisis %d kombinasi parameter...\n', ...
            length(muzzle_velocities) * length(launch_angles) * length(altitudes));
    
    for v0 = muzzle_velocities
        for angle = launch_angles
            for alt = altitudes
                % Hitung lintasan
                [range_dist, max_height, flight_time, impact_velocity] = ...
                    calculate_trajectory(v0, angle, alt, mass, cross_section, drag_coeff);
                
                % Simpan hasil
                results = [results; v0/1000, angle, alt/1000, range_dist/1000, ...
                          max_height/1000, flight_time, impact_velocity/1000];
            end
        end
    end
    
    %% Tampilkan Hasil
    fprintf('\n=== Hasil Analisis Lintasan ===\n');
    fprintf('V0(km/s) | Sudut(°) | Alt(km) | Jarak(km) | Tinggi(km) | Waktu(s) | V_impact(km/s)\n');
    fprintf('---------|----------|---------|-----------|------------|----------|---------------\n');
    
    for i = 1:size(results, 1)
        fprintf('%8.1f | %8.0f | %7.1f | %9.1f | %10.1f | %8.1f | %13.1f\n', ...
                results(i,1), results(i,2), results(i,3), results(i,4), ...
                results(i,5), results(i,6), results(i,7));
    end
    
    %% Analisis Optimal
    fprintf('\n=== Analisis Optimal ===\n');
    
    % Jarak maksimum
    [max_range, max_idx] = max(results(:,4));
    fprintf('Jarak Maksimum: %.1f km\n', max_range);
    fprintf('Parameter: V0=%.1f km/s, Sudut=%.0f°, Alt=%.1f km\n', ...
            results(max_idx,1), results(max_idx,2), results(max_idx,3));
    
    % Ketinggian maksimum
    [max_alt, alt_idx] = max(results(:,5));
    fprintf('\nKetinggian Maksimum: %.1f km\n', max_alt);
    fprintf('Parameter: V0=%.1f km/s, Sudut=%.0f°, Alt=%.1f km\n', ...
            results(alt_idx,1), results(alt_idx,2), results(alt_idx,3));
    
    %% Visualisasi
    create_trajectory_plots(results, muzzle_velocities, launch_angles, altitudes);
    
    %% Analisis Khusus: Orbit Velocity
    fprintf('\n=== Analisis Kecepatan Orbital ===\n');
    orbital_velocity = sqrt(g * R_earth);  % Kecepatan orbit rendah
    escape_velocity = sqrt(2 * g * R_earth);  % Kecepatan lepas
    
    fprintf('Kecepatan orbit rendah: %.2f km/s\n', orbital_velocity/1000);
    fprintf('Kecepatan lepas bumi: %.2f km/s\n', escape_velocity/1000);
    
    % Cek proyektil mana yang bisa mencapai orbit
    orbital_candidates = results(results(:,1) >= orbital_velocity/1000, :);
    if ~isempty(orbital_candidates)
        fprintf('\nProyektil dengan potensi orbital:\n');
        for i = 1:size(orbital_candidates, 1)
            fprintf('V0=%.1f km/s, Sudut=%.0f°, Jarak=%.1f km\n', ...
                    orbital_candidates(i,1), orbital_candidates(i,2), orbital_candidates(i,4));
        end
    else
        fprintf('\nTidak ada proyektil yang mencapai kecepatan orbital.\n');
    end
    
    %% Simpan Hasil
    save('trajectory_results.mat', 'results', 'muzzle_velocities', 'launch_angles', 'altitudes');
    fprintf('\nHasil analisis disimpan ke trajectory_results.mat\n');
end

%% Fungsi Perhitungan Lintasan
function [range_dist, max_height, flight_time, impact_velocity] = ...
         calculate_trajectory(v0, angle_deg, altitude, mass, cross_section, drag_coeff)
    
    % Konversi sudut ke radian
    angle = angle_deg * pi / 180;
    
    % Kondisi awal
    x0 = 0;
    y0 = altitude;
    vx0 = v0 * cos(angle);
    vy0 = v0 * sin(angle);
    
    % Parameter atmosfer (model sederhana)
    rho0 = 1.225;  % kg/m^3 (densitas udara di permukaan)
    scale_height = 8400;  % m (skala ketinggian atmosfer)
    
    % Fungsi densitas atmosfer
    rho_func = @(h) rho0 * exp(-max(0, h) / scale_height);
    
    % Sistem persamaan diferensial
    odefun = @(t, y) trajectory_ode(t, y, mass, cross_section, drag_coeff, rho_func);
    
    % Kondisi awal: [x, y, vx, vy]
    y0_vec = [x0; y0; vx0; vy0];
    
    % Event function untuk mendeteksi impact
    options = odeset('Events', @ground_impact, 'RelTol', 1e-8);
    
    % Integrasi numerik
    tspan = [0, 1000];  % Maksimum 1000 detik
    [t, y, te, ye, ie] = ode45(odefun, tspan, y0_vec, options);
    
    % Hasil
    if ~isempty(te)
        range_dist = ye(1);
        flight_time = te;
        impact_velocity = sqrt(ye(3)^2 + ye(4)^2);
    else
        range_dist = y(end, 1);
        flight_time = t(end);
        impact_velocity = sqrt(y(end, 3)^2 + y(end, 4)^2);
    end
    
    max_height = max(y(:, 2));
end

%% ODE untuk Lintasan
function dydt = trajectory_ode(t, y, mass, cross_section, drag_coeff, rho_func)
    % y = [x, y, vx, vy]
    x = y(1);
    height = y(2);
    vx = y(3);
    vy = y(4);
    
    % Kecepatan total
    v_total = sqrt(vx^2 + vy^2);
    
    % Densitas udara pada ketinggian ini
    rho = rho_func(height);
    
    % Gaya drag
    drag_force = 0.5 * rho * drag_coeff * cross_section * v_total^2;
    
    % Komponen drag
    if v_total > 0
        drag_x = -drag_force * (vx / v_total) / mass;
        drag_y = -drag_force * (vy / v_total) / mass;
    else
        drag_x = 0;
        drag_y = 0;
    end
    
    % Gravitasi (konstan)
    g = 9.81;
    
    % Persamaan diferensial
    dydt = [vx;                    % dx/dt = vx
            vy;                    % dy/dt = vy
            drag_x;                % dvx/dt = -drag_x
            -g + drag_y];          % dvy/dt = -g - drag_y
end

%% Event Function untuk Ground Impact
function [value, isterminal, direction] = ground_impact(t, y)
    value = y(2);      % Ketinggian
    isterminal = 1;    % Stop integration
    direction = -1;    % Hanya saat turun
end

%% Fungsi Visualisasi
function create_trajectory_plots(results, velocities, angles, altitudes)
    figure('Position', [100, 100, 1400, 1000]);
    
    % Plot 1: Range vs Launch Angle
    subplot(2,3,1);
    for i = 1:length(velocities)
        v_data = results(results(:,1) == velocities(i)/1000, :);
        if ~isempty(v_data)
            plot(v_data(:,2), v_data(:,4), 'o-', 'LineWidth', 2, ...
                 'DisplayName', sprintf('%.0f km/s', velocities(i)/1000));
            hold on;
        end
    end
    xlabel('Sudut Peluncuran (°)');
    ylabel('Jarak (km)');
    title('Jarak vs Sudut Peluncuran');
    legend('Location', 'best');
    grid on;
    
    % Plot 2: Max Height vs Velocity
    subplot(2,3,2);
    for i = 1:length(angles)
        angle_data = results(results(:,2) == angles(i), :);
        if ~isempty(angle_data)
            plot(angle_data(:,1), angle_data(:,5), 's-', 'LineWidth', 2, ...
                 'DisplayName', sprintf('%.0f°', angles(i)));
            hold on;
        end
    end
    xlabel('Kecepatan Awal (km/s)');
    ylabel('Ketinggian Maksimum (km)');
    title('Ketinggian vs Kecepatan');
    legend('Location', 'best');
    grid on;
    
    % Plot 3: Range vs Velocity
    subplot(2,3,3);
    for i = 1:length(angles)
        angle_data = results(results(:,2) == angles(i), :);
        if ~isempty(angle_data)
            plot(angle_data(:,1), angle_data(:,4), '^-', 'LineWidth', 2, ...
                 'DisplayName', sprintf('%.0f°', angles(i)));
            hold on;
        end
    end
    xlabel('Kecepatan Awal (km/s)');
    ylabel('Jarak (km)');
    title('Jarak vs Kecepatan');
    legend('Location', 'best');
    grid on;
    
    % Plot 4: Flight Time vs Parameters
    subplot(2,3,4);
    scatter3(results(:,1), results(:,2), results(:,6), 50, results(:,4), 'filled');
    xlabel('Kecepatan (km/s)');
    ylabel('Sudut (°)');
    zlabel('Waktu Penerbangan (s)');
    title('Waktu Penerbangan (warna = Jarak)');
    colorbar;
    
    % Plot 5: Impact Velocity Analysis
    subplot(2,3,5);
    velocity_retention = results(:,7) ./ results(:,1) * 100;  % Persentase kecepatan tersisa
    scatter(results(:,4), velocity_retention, 50, results(:,1), 'filled');
    xlabel('Jarak (km)');
    ylabel('Retensi Kecepatan (%)');
    title('Retensi Kecepatan vs Jarak');
    colorbar;
    
    % Plot 6: Optimal Trajectory Envelope
    subplot(2,3,6);
    % Buat envelope untuk setiap kecepatan
    colors = lines(length(velocities));
    for i = 1:length(velocities)
        v_data = results(results(:,1) == velocities(i)/1000 & results(:,3) == 0, :);
        if size(v_data, 1) > 1
            [sorted_angles, idx] = sort(v_data(:,2));
            sorted_ranges = v_data(idx, 4);
            plot(sorted_ranges, sorted_angles, 'o-', 'Color', colors(i,:), ...
                 'LineWidth', 2, 'DisplayName', sprintf('%.0f km/s', velocities(i)/1000));
            hold on;
        end
    end
    xlabel('Jarak (km)');
    ylabel('Sudut Optimal (°)');
    title('Envelope Lintasan Optimal');
    legend('Location', 'best');
    grid on;
    
    sgtitle('Analisis Komprehensif Lintasan Railgun', 'FontSize', 16);
end

% Jalankan analyzer
railgun_trajectory_analyzer();

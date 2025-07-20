%% Railgun Materials Analysis
% Analisis material dan thermal management untuk railgun
% Author: Railgun Research Team

function railgun_materials()
    clear all; close all; clc;
    
    fprintf('=== Railgun Materials & Thermal Analysis ===\n\n');
    
    %% Database Material Rel
    materials = struct();
    
    % Tembaga (Copper) - Baseline
    materials.copper.name = 'Tembaga (Cu)';
    materials.copper.resistivity = 1.68e-8;  % Ohm⋅m
    materials.copper.density = 8960;         % kg/m³
    materials.copper.thermal_conductivity = 401;  % W/(m⋅K)
    materials.copper.melting_point = 1085;   % °C
    materials.copper.temp_coeff = 0.0039;    % /°C
    materials.copper.cost_factor = 1.0;      % Relatif
    
    % Perak (Silver) - Konduktivitas terbaik
    materials.silver.name = 'Perak (Ag)';
    materials.silver.resistivity = 1.59e-8;
    materials.silver.density = 10490;
    materials.silver.thermal_conductivity = 429;
    materials.silver.melting_point = 962;
    materials.silver.temp_coeff = 0.0038;
    materials.silver.cost_factor = 50.0;
    
    % Aluminium - Ringan
    materials.aluminum.name = 'Aluminium (Al)';
    materials.aluminum.resistivity = 2.65e-8;
    materials.aluminum.density = 2700;
    materials.aluminum.thermal_conductivity = 237;
    materials.aluminum.melting_point = 660;
    materials.aluminum.temp_coeff = 0.0039;
    materials.aluminum.cost_factor = 0.3;
    
    % Superkonductor (Hipotetis pada suhu operasi)
    materials.superconductor.name = 'Superkonductor HTS';
    materials.superconductor.resistivity = 1e-12;
    materials.superconductor.density = 6000;
    materials.superconductor.thermal_conductivity = 100;
    materials.superconductor.melting_point = 1200;
    materials.superconductor.temp_coeff = 0.0001;
    materials.superconductor.cost_factor = 1000.0;
    
    % Grafit (Carbon) - Tahan panas tinggi
    materials.graphite.name = 'Grafit (C)';
    materials.graphite.resistivity = 5e-6;
    materials.graphite.density = 2200;
    materials.graphite.thermal_conductivity = 200;
    materials.graphite.melting_point = 3500;
    materials.graphite.temp_coeff = -0.0005;  % Negatif!
    materials.graphite.cost_factor = 2.0;
    
    %% Parameter Railgun untuk Analisis
    rail_length = 50;        % m
    rail_width = 0.05;       % m (5 cm)
    rail_thickness = 0.02;   % m (2 cm)
    rail_volume = rail_length * rail_width * rail_thickness * 2;  % m³ (2 rel)
    
    current_profile = [100000, 500000, 750000, 1000000];  % A
    pulse_duration = 0.01;   % s (10 ms)
    
    %% Analisis untuk Setiap Material
    material_names = fieldnames(materials);
    analysis_results = [];
    
    fprintf('Menganalisis %d material...\n\n', length(material_names));
    
    for i = 1:length(material_names)
        mat_name = material_names{i};
        mat = materials.(mat_name);
        
        fprintf('=== %s ===\n', mat.name);
        
        % Analisis untuk setiap level arus
        for j = 1:length(current_profile)
            current = current_profile(j);
            
            % Resistansi rel
            rail_resistance = mat.resistivity * rail_length / (rail_width * rail_thickness);
            
            % Power dissipation
            power_loss = current^2 * rail_resistance;  % W
            energy_loss = power_loss * pulse_duration;  % J
            
            % Thermal analysis
            rail_mass = materials.copper.density * rail_volume;  % kg (asumsi densitas sama)
            specific_heat = 385;  % J/(kg⋅K) untuk logam rata-rata
            
            % Temperature rise (sederhana, tanpa heat transfer)
            temp_rise = energy_loss / (rail_mass * specific_heat);
            
            % Efisiensi (asumsi energi kinetik 10% dari total)
            kinetic_energy = energy_loss * 0.1;  % Asumsi
            efficiency = kinetic_energy / (kinetic_energy + energy_loss) * 100;
            
            % Lifetime estimate (berdasarkan thermal cycling)
            if temp_rise < 100
                lifetime_cycles = 100000;
            elseif temp_rise < 300
                lifetime_cycles = 10000;
            elseif temp_rise < 500
                lifetime_cycles = 1000;
            else
                lifetime_cycles = 100;
            end
            
            % Cost analysis
            material_cost = mat.cost_factor * rail_volume * 1000;  % Relatif
            
            % Simpan hasil
            analysis_results = [analysis_results; i, j, current/1000, rail_resistance*1000, ...
                              power_loss/1000, temp_rise, efficiency, lifetime_cycles, material_cost];
            
            fprintf('  Arus %.0f kA: R=%.2f mΩ, P=%.1f kW, ΔT=%.1f°C, η=%.1f%%, Siklus=%d\n', ...
                    current/1000, rail_resistance*1000, power_loss/1000, temp_rise, efficiency, lifetime_cycles);
        end
        fprintf('\n');
    end
    
    %% Ranking Material
    fprintf('=== Ranking Material (berdasarkan performa keseluruhan) ===\n');
    
    % Hitung skor untuk setiap material
    material_scores = zeros(length(material_names), 1);
    
    for i = 1:length(material_names)
        mat_data = analysis_results(analysis_results(:,1) == i, :);
        
        % Skor berdasarkan: efisiensi tinggi, resistansi rendah, lifetime tinggi, cost rendah
        avg_efficiency = mean(mat_data(:,7));
        avg_resistance = mean(mat_data(:,4));
        avg_lifetime = mean(mat_data(:,8));
        avg_cost = mean(mat_data(:,9));
        
        % Normalisasi dan pembobotan
        eff_score = avg_efficiency / 100 * 30;  % 30% bobot
        res_score = (1 - avg_resistance/max(analysis_results(:,4))) * 25;  % 25% bobot
        life_score = (avg_lifetime / max(analysis_results(:,8))) * 25;  % 25% bobot
        cost_score = (1 - avg_cost/max(analysis_results(:,9))) * 20;  % 20% bobot
        
        material_scores(i) = eff_score + res_score + life_score + cost_score;
    end
    
    [sorted_scores, rank_idx] = sort(material_scores, 'descend');
    
    fprintf('Rank | Material           | Skor | Efisiensi | Resistansi | Lifetime | Cost\n');
    fprintf('-----|--------------------|----- |-----------|------------|----------|-----\n');
    
    for i = 1:length(rank_idx)
        idx = rank_idx(i);
        mat_data = analysis_results(analysis_results(:,1) == idx, :);
        
        fprintf('%4d | %-18s | %4.1f | %8.1f%% | %9.2f mΩ | %8.0f | %4.1f\n', ...
                i, materials.(material_names{idx}).name, sorted_scores(i), ...
                mean(mat_data(:,7)), mean(mat_data(:,4)), mean(mat_data(:,8)), mean(mat_data(:,9)));
    end
    
    %% Thermal Management Analysis
    fprintf('\n=== Analisis Thermal Management ===\n');
    
    % Cooling requirements
    max_power = max(analysis_results(:,5)) * 1000;  % W
    fprintf('Daya maksimum yang harus didinginkan: %.1f kW\n', max_power/1000);
    
    % Cooling methods
    cooling_methods = {
        'Air Natural', 10, 1.0;      % W/(m²⋅K), cost factor
        'Air Forced', 50, 2.0;
        'Water Cooling', 500, 5.0;
        'Liquid Nitrogen', 2000, 20.0;
        'Helium Cooling', 5000, 100.0
    };
    
    fprintf('\nMetode Pendinginan yang Diperlukan:\n');
    fprintf('Method           | Heat Transfer | Cost Factor | Area Required\n');
    fprintf('-----------------|---------------|-------------|---------------\n');
    
    for i = 1:size(cooling_methods, 1)
        method = cooling_methods{i, 1};
        h_coeff = cooling_methods{i, 2};
        cost_f = cooling_methods{i, 3};
        
        % Asumsi ΔT = 50°C untuk pendinginan
        delta_T = 50;
        required_area = max_power / (h_coeff * delta_T);
        
        fprintf('%-16s | %13.0f | %11.1f | %13.2f m²\n', ...
                method, h_coeff, cost_f, required_area);
    end
    
    %% Visualisasi
    create_materials_plots(analysis_results, materials, material_names);
    
    %% Rekomendasi Desain
    fprintf('\n=== Rekomendasi Desain ===\n');
    
    best_material = material_names{rank_idx(1)};
    fprintf('Material terbaik: %s\n', materials.(best_material).name);
    
    % Optimasi geometri
    optimal_thickness = sqrt(materials.(best_material).resistivity * rail_length / 0.001);  % Target 1 mΩ
    fprintf('Ketebalan optimal: %.1f mm\n', optimal_thickness * 1000);
    
    % Cooling recommendation
    if max_power > 100000  % > 100 kW
        fprintf('Pendinginan yang disarankan: Liquid Nitrogen atau Helium\n');
    elseif max_power > 10000  % > 10 kW
        fprintf('Pendinginan yang disarankan: Water Cooling\n');
    else
        fprintf('Pendinginan yang disarankan: Forced Air\n');
    end
    
    %% Simpan Hasil
    save('materials_analysis.mat', 'analysis_results', 'materials', 'material_scores');
    fprintf('\nHasil analisis material disimpan ke materials_analysis.mat\n');
end

%% Fungsi Visualisasi
function create_materials_plots(results, materials, material_names)
    figure('Position', [100, 100, 1400, 1000]);
    
    % Plot 1: Resistansi vs Arus
    subplot(2,3,1);
    colors = lines(length(material_names));
    for i = 1:length(material_names)
        mat_data = results(results(:,1) == i, :);
        plot(mat_data(:,3), mat_data(:,4), 'o-', 'Color', colors(i,:), ...
             'LineWidth', 2, 'DisplayName', materials.(material_names{i}).name);
        hold on;
    end
    xlabel('Arus (kA)');
    ylabel('Resistansi (mΩ)');
    title('Resistansi vs Arus');
    legend('Location', 'best');
    grid on;
    
    % Plot 2: Efisiensi vs Material
    subplot(2,3,2);
    for i = 1:length(material_names)
        mat_data = results(results(:,1) == i, :);
        bar_data = mean(mat_data(:,7));
        bar(i, bar_data, 'FaceColor', colors(i,:));
        hold on;
    end
    xlabel('Material');
    ylabel('Efisiensi Rata-rata (%)');
    title('Efisiensi per Material');
    set(gca, 'XTick', 1:length(material_names), 'XTickLabel', ...
        cellfun(@(x) materials.(x).name, material_names, 'UniformOutput', false));
    xtickangle(45);
    grid on;
    
    % Plot 3: Temperature Rise
    subplot(2,3,3);
    for i = 1:length(material_names)
        mat_data = results(results(:,1) == i, :);
        plot(mat_data(:,3), mat_data(:,6), 's-', 'Color', colors(i,:), ...
             'LineWidth', 2, 'DisplayName', materials.(material_names{i}).name);
        hold on;
    end
    xlabel('Arus (kA)');
    ylabel('Kenaikan Suhu (°C)');
    title('Thermal Performance');
    legend('Location', 'best');
    grid on;
    
    % Plot 4: Lifetime vs Cost
    subplot(2,3,4);
    for i = 1:length(material_names)
        mat_data = results(results(:,1) == i, :);
        avg_lifetime = mean(mat_data(:,8));
        avg_cost = mean(mat_data(:,9));
        scatter(avg_cost, avg_lifetime, 100, colors(i,:), 'filled', ...
                'DisplayName', materials.(material_names{i}).name);
        hold on;
    end
    xlabel('Cost Factor');
    ylabel('Lifetime (cycles)');
    title('Lifetime vs Cost Trade-off');
    legend('Location', 'best');
    grid on;
    set(gca, 'XScale', 'log', 'YScale', 'log');
    
    % Plot 5: Power Loss Comparison
    subplot(2,3,5);
    current_levels = unique(results(:,3));
    bar_data = zeros(length(material_names), length(current_levels));
    
    for i = 1:length(material_names)
        for j = 1:length(current_levels)
            mat_data = results(results(:,1) == i & results(:,3) == current_levels(j), :);
            if ~isempty(mat_data)
                bar_data(i, j) = mat_data(5);  % Power loss
            end
        end
    end
    
    bar(bar_data');
    xlabel('Current Level');
    ylabel('Power Loss (kW)');
    title('Power Loss Comparison');
    legend(cellfun(@(x) materials.(x).name, material_names, 'UniformOutput', false), ...
           'Location', 'best');
    set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f kA', x), current_levels, 'UniformOutput', false));
    grid on;
    
    % Plot 6: Material Properties Radar
    subplot(2,3,6);
    % Normalisasi properties untuk radar chart
    props = zeros(length(material_names), 5);  % 5 properties
    
    for i = 1:length(material_names)
        mat = materials.(material_names{i});
        props(i,1) = 1 / mat.resistivity * 1e8;  % Conductivity (normalized)
        props(i,2) = mat.thermal_conductivity / 500;  % Thermal (normalized)
        props(i,3) = mat.melting_point / 4000;  % Melting point (normalized)
        props(i,4) = 1 / mat.cost_factor;  % Cost (inverted, normalized)
        props(i,5) = mat.density / 12000;  % Density (normalized)
    end
    
    % Simple radar-like visualization
    prop_names = {'Conductivity', 'Thermal', 'Melting Pt', 'Cost Eff', 'Density'};
    
    for i = 1:length(material_names)
        plot(1:5, props(i,:), 'o-', 'Color', colors(i,:), 'LineWidth', 2, ...
             'DisplayName', materials.(material_names{i}).name);
        hold on;
    end
    
    xlabel('Property Index');
    ylabel('Normalized Value');
    title('Material Properties Comparison');
    set(gca, 'XTick', 1:5, 'XTickLabel', prop_names);
    xtickangle(45);
    legend('Location', 'best');
    grid on;
    
    sgtitle('Analisis Komprehensif Material Railgun', 'FontSize', 16);
end

% Jalankan analisis material
railgun_materials();

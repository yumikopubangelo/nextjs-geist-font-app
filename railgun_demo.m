%% Railgun Demonstration Script
% Script demonstrasi untuk menunjukkan kemampuan sistem simulasi railgun
% Author: Railgun Research Team

function railgun_demo()
    clear all; close all; clc;
    
    % Header demonstrasi
    fprintf('╔══════════════════════════════════════════════════════════════╗\n');
    fprintf('║                    RAILGUN DEMO SHOWCASE                    ║\n');
    fprintf('║              Demonstrasi Kemampuan Sistem                   ║\n');
    fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');
    
    % Timer untuk demo
    demo_start = tic;
    
    %% Demo 1: Quick Performance Test
    fprintf('🎯 DEMO 1: Quick Performance Test\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    % Parameter demo cepat
    demo_currents = [100000, 500000, 1000000];  % A
    demo_masses = [0.05, 0.1, 0.2];             % kg
    demo_lengths = [30, 50, 75];                % m
    
    fprintf('Testing %d parameter combinations...\n', ...
            length(demo_currents) * length(demo_masses) * length(demo_lengths));
    
    demo_results = [];
    
    for I = demo_currents
        for m = demo_masses
            for L = demo_lengths
                % Quick simulation
                [v, eff] = quick_railgun_calc(I, m, L);
                demo_results = [demo_results; I/1000, m, L, v/1000, eff];
                
                fprintf('I=%3.0fkA, m=%.2fkg, L=%2.0fm → v=%5.1fkm/s, η=%4.1f%%\n', ...
                        I/1000, m, L, v/1000, eff);
            end
        end
    end
    
    % Find best configuration
    [best_vel, best_idx] = max(demo_results(:,4));
    best_config = demo_results(best_idx, :);
    
    fprintf('\n🏆 KONFIGURASI TERBAIK:\n');
    fprintf('   Arus: %.0f kA, Massa: %.2f kg, Panjang: %.0f m\n', ...
            best_config(1), best_config(2), best_config(3));
    fprintf('   Hasil: %.1f km/s, %.1f%% efisiensi\n\n', best_config(4), best_config(5));
    
    %% Demo 2: Material Comparison
    fprintf('🔬 DEMO 2: Material Comparison\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    % Material properties (simplified)
    materials = {
        'Copper',        1.68e-8,  1.0;
        'Silver',        1.59e-8,  50.0;
        'Aluminum',      2.65e-8,  0.3;
        'Superconductor', 1e-12,   1000.0;
        'Graphite',      5e-6,     2.0
    };
    
    fprintf('Material         | Resistivity | Cost | Performance Score\n');
    fprintf('-----------------|-------------|------|------------------\n');
    
    for i = 1:size(materials, 1)
        name = materials{i, 1};
        resistivity = materials{i, 2};
        cost = materials{i, 3};
        
        % Performance score (lower resistivity = better, lower cost = better)
        perf_score = (1/resistivity) / cost * 1e6;  % Normalized
        
        fprintf('%-16s | %11.2e | %4.1f | %16.2f\n', name, resistivity, cost, perf_score);
    end
    
    fprintf('\n💡 Rekomendasi: Copper untuk cost-effective, Silver untuk performa tinggi\n\n');
    
    %% Demo 3: Trajectory Showcase
    fprintf('🎯 DEMO 3: Trajectory Analysis\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    % Test different launch scenarios
    scenarios = [
        5000,  45, 'Subsonic Artillery';
        10000, 30, 'Hypersonic Strike';
        15000, 15, 'Low-Angle Penetrator';
        20000, 60, 'High-Altitude Interceptor'
    ];
    
    fprintf('Scenario                  | Velocity | Angle | Range  | Max Height\n');
    fprintf('--------------------------|----------|-------|--------|------------\n');
    
    for i = 1:size(scenarios, 1)
        v0 = scenarios{i, 1};
        angle = scenarios{i, 2};
        name = scenarios{i, 3};
        
        [range_km, height_km] = quick_trajectory_calc(v0, angle);
        
        fprintf('%-25s | %6.0f m/s | %3.0f° | %6.1f km | %8.1f km\n', ...
                name, v0, angle, range_km, height_km);
    end
    
    fprintf('\n🚀 Orbital velocity (7.8 km/s) dapat dicapai dengan konfigurasi optimal!\n\n');
    
    %% Demo 4: Efficiency Analysis
    fprintf('⚡ DEMO 4: Efficiency Optimization\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    % Test efficiency vs different parameters
    base_resistance = [0.01, 0.001, 0.0001, 0.00001];  % Ohm
    
    fprintf('Base Resistance | Efficiency | Power Loss | Thermal Load\n');
    fprintf('----------------|------------|------------|-------------\n');
    
    for R = base_resistance
        % Calculate efficiency for standard config
        I = 500000;  % A
        m = 0.1;     % kg
        L = 50;      % m
        
        % Energy calculations
        kinetic_energy = 0.5 * m * 15000^2;  % Target 15 km/s
        thermal_energy = I^2 * R * 0.01;     % 10ms pulse
        efficiency = kinetic_energy / (kinetic_energy + thermal_energy) * 100;
        
        fprintf('%13.5f | %8.1f%% | %8.1f kW | %11.1f kJ\n', ...
                R, efficiency, I^2*R/1000, thermal_energy/1000);
    end
    
    fprintf('\n💡 Resistansi rendah kunci untuk efisiensi tinggi!\n\n');
    
    %% Demo 5: Scaling Analysis
    fprintf('📏 DEMO 5: Scaling Laws\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    % Show how performance scales with size
    scale_factors = [0.5, 1.0, 2.0, 5.0];
    base_current = 500000;  % A
    base_length = 50;       % m
    base_mass = 0.1;        % kg
    
    fprintf('Scale | Current | Length | Mass  | Velocity | Power   | Energy\n');
    fprintf('------|---------|--------|-------|----------|---------|--------\n');
    
    for scale = scale_factors
        I_scaled = base_current * scale;
        L_scaled = base_length * scale;
        m_scaled = base_mass * scale^3;  % Volume scaling
        
        % Theoretical velocity (simplified)
        v_scaled = sqrt(L_scaled * 2e-6 * I_scaled^2 / m_scaled);
        power_scaled = I_scaled^2 * 0.001;  % Simplified
        energy_scaled = 0.5 * m_scaled * v_scaled^2;
        
        fprintf('%5.1fx | %7.0f A | %6.0f m | %5.2f kg | %6.0f m/s | %7.1f MW | %6.1f MJ\n', ...
                scale, I_scaled, L_scaled, m_scaled, v_scaled, power_scaled/1e6, energy_scaled/1e6);
    end
    
    fprintf('\n📈 Scaling up meningkatkan performa secara signifikan!\n\n');
    
    %% Demo 6: Real-world Applications
    fprintf('🌍 DEMO 6: Real-world Applications\n');
    fprintf('─────────────────────────────────────────────────────────────\n');
    
    applications = {
        'Naval Defense',     '5-8 km/s',   '100-200 km', 'Anti-ship missiles';
        'Missile Defense',   '8-12 km/s',  '500+ km',    'Interceptor systems';
        'Space Launch',      '11+ km/s',   'Orbital',    'Satellite deployment';
        'Research',          '15+ km/s',   'N/A',        'Hypervelocity impact';
        'Mining',           '2-5 km/s',    '10-50 km',   'Asteroid mining'
    };
    
    fprintf('Application      | Velocity Req | Range Req | Purpose\n');
    fprintf('-----------------|--------------|-----------|------------------\n');
    
    for i = 1:size(applications, 1)
        fprintf('%-16s | %-12s | %-9s | %s\n', applications{i,:});
    end
    
    fprintf('\n🎯 Sistem railgun dapat mendukung berbagai aplikasi!\n\n');
    
    %% Demo Summary
    demo_time = toc(demo_start);
    
    fprintf('╔══════════════════════════════════════════════════════════════╗\n');
    fprintf('║                      DEMO SUMMARY                           ║\n');
    fprintf('╠══════════════════════════════════════════════════════════════╣\n');
    fprintf('║ ✅ Performance Test: %d configurations analyzed             ║\n', size(demo_results,1));
    fprintf('║ ✅ Material Analysis: %d materials compared                 ║\n', size(materials,1));
    fprintf('║ ✅ Trajectory Scenarios: %d cases demonstrated              ║\n', size(scenarios,1));
    fprintf('║ ✅ Efficiency Optimization: %d resistance levels tested     ║\n', length(base_resistance));
    fprintf('║ ✅ Scaling Laws: %d scale factors analyzed                  ║\n', length(scale_factors));
    fprintf('║ ✅ Applications: %d real-world use cases identified         ║\n', size(applications,1));
    fprintf('║                                                              ║\n');
    fprintf('║ 🏆 Best Performance: %.1f km/s at %.1f%% efficiency          ║\n', best_config(4), best_config(5));
    fprintf('║ ⏱️  Demo Duration: %.1f seconds                              ║\n', demo_time);
    fprintf('╚══════════════════════════════════════════════════════════════╝\n');
    
    %% Interactive Demo Plot
    create_demo_visualization(demo_results, scenarios);
    
    fprintf('\n🎉 Demo selesai! Jalankan railgun_main.m untuk simulasi lengkap.\n');
end

%% Quick Calculation Functions
function [velocity, efficiency] = quick_railgun_calc(current, mass, length)
    % Quick railgun performance calculation
    L_prime = 2.0e-6;  % H/m
    resistance = 0.001;  % Ohm
    
    % Force and acceleration
    force = 0.5 * L_prime * current^2;
    acceleration = force / mass;
    
    % Time and velocity (assuming constant acceleration)
    time = sqrt(2 * length / acceleration);
    velocity = acceleration * time;
    
    % Limit velocity
    velocity = min(velocity, 20000);  % 20 km/s max
    
    % Efficiency calculation
    kinetic_energy = 0.5 * mass * velocity^2;
    thermal_energy = current^2 * resistance * time;
    efficiency = kinetic_energy / (kinetic_energy + thermal_energy) * 100;
    efficiency = min(efficiency, 100);
end

function [range_km, height_km] = quick_trajectory_calc(v0, angle_deg)
    % Quick trajectory calculation
    g = 9.81;
    angle = angle_deg * pi / 180;
    
    % Without drag (simplified)
    range_m = v0^2 * sin(2*angle) / g;
    height_m = (v0 * sin(angle))^2 / (2*g);
    
    % With drag approximation (reduce by ~30% for hypersonic)
    if v0 > 5000
        drag_factor = 0.7;
    else
        drag_factor = 0.9;
    end
    
    range_km = range_m * drag_factor / 1000;
    height_km = height_m * drag_factor / 1000;
end

%% Visualization Function
function create_demo_visualization(results, scenarios)
    figure('Position', [100, 100, 1400, 800]);
    
    % Plot 1: Performance Matrix
    subplot(2,3,1);
    scatter3(results(:,1), results(:,2), results(:,4), 100, results(:,5), 'filled');
    xlabel('Current (kA)');
    ylabel('Mass (kg)');
    zlabel('Velocity (km/s)');
    title('Performance Matrix');
    colorbar;
    colormap(jet);
    
    % Plot 2: Efficiency vs Velocity
    subplot(2,3,2);
    scatter(results(:,4), results(:,5), 80, results(:,1), 'filled');
    xlabel('Velocity (km/s)');
    ylabel('Efficiency (%)');
    title('Efficiency vs Velocity');
    colorbar;
    
    % Plot 3: Scaling Effects
    subplot(2,3,3);
    scales = [0.5, 1, 2, 5];
    velocities = [8.2, 11.6, 16.4, 25.9];  % Example data
    plot(scales, velocities, 'ro-', 'LineWidth', 3, 'MarkerSize', 8);
    xlabel('Scale Factor');
    ylabel('Velocity (km/s)');
    title('Scaling Laws');
    grid on;
    
    % Plot 4: Material Comparison
    subplot(2,3,4);
    materials = {'Cu', 'Ag', 'Al', 'SC', 'Gr'};
    scores = [1.0, 0.8, 0.6, 2.5, 0.3];  % Normalized performance scores
    bar(scores, 'FaceColor', [0.2 0.6 0.8]);
    set(gca, 'XTickLabel', materials);
    ylabel('Performance Score');
    title('Material Comparison');
    
    % Plot 5: Application Ranges
    subplot(2,3,5);
    app_velocities = [6.5, 10, 11.2, 17.5, 3.5];  % km/s
    app_names = {'Naval', 'Defense', 'Space', 'Research', 'Mining'};
    barh(app_velocities, 'FaceColor', [0.8 0.4 0.2]);
    set(gca, 'YTickLabel', app_names);
    xlabel('Required Velocity (km/s)');
    title('Application Requirements');
    
    % Plot 6: Demo Summary
    subplot(2,3,6);
    axis off;
    summary_text = {
        'DEMO HIGHLIGHTS';
        '';
        sprintf('• Max Velocity: %.1f km/s', max(results(:,4)));
        sprintf('• Max Efficiency: %.1f%%', max(results(:,5)));
        sprintf('• Configurations: %d', size(results,1));
        sprintf('• Materials: 5 types');
        sprintf('• Applications: 5 domains');
        '';
        '🚀 Ready for full simulation!';
    };
    
    text(0.1, 0.9, summary_text, 'FontSize', 11, 'VerticalAlignment', 'top');
    
    sgtitle('Railgun Demo - System Capabilities Overview', 'FontSize', 16, 'FontWeight', 'bold');
end

% Run demo if called directly
if ~exist('railgun_main', 'file')
    railgun_demo();
end

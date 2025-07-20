%% Railgun Main Control System
% Sistem kontrol utama untuk simulasi railgun modular
% Author: Railgun Research Team
% Version: 1.0

function railgun_main()
    clear all; close all; clc;
    
    % ASCII Art Header
    fprintf('╔══════════════════════════════════════════════════════════════╗\n');
    fprintf('║                    RAILGUN SIMULATION SUITE                 ║\n');
    fprintf('║                     Modular Design System                    ║\n');
    fprintf('║                                                              ║\n');
    fprintf('║  Target: Hypersonic Velocity (5-15 km/s)                   ║\n');
    fprintf('║  Application: Military, Research, Space Launch              ║\n');
    fprintf('╚══════════════════════════════════════════════════════════════╝\n\n');
    
    % Menu utama
    while true
        display_main_menu();
        choice = input('Pilih opsi (1-7): ');
        
        switch choice
            case 1
                run_basic_simulation();
            case 2
                run_parameter_optimization();
            case 3
                run_trajectory_analysis();
            case 4
                run_materials_analysis();
            case 5
                run_comprehensive_study();
            case 6
                view_results_comparison();
            case 7
                fprintf('\nTerima kasih telah menggunakan Railgun Simulation Suite!\n');
                break;
            otherwise
                fprintf('\nPilihan tidak valid. Silakan coba lagi.\n\n');
        end
    end
end

%% Display Main Menu
function display_main_menu()
    fprintf('═══════════════════════════════════════════════════════════════\n');
    fprintf('                        MENU UTAMA\n');
    fprintf('═══════════════════════════════════════════════════════════════\n');
    fprintf('1. Simulasi Dasar Railgun\n');
    fprintf('2. Optimasi Parameter\n');
    fprintf('3. Analisis Lintasan Proyektil\n');
    fprintf('4. Analisis Material & Thermal\n');
    fprintf('5. Studi Komprehensif (All-in-One)\n');
    fprintf('6. Perbandingan Hasil\n');
    fprintf('7. Keluar\n');
    fprintf('═══════════════════════════════════════════════════════════════\n');
end

%% Run Basic Simulation
function run_basic_simulation()
    fprintf('\n🚀 Menjalankan Simulasi Dasar Railgun...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    
    try
        % Jalankan simulasi utama
        run('railgun_simulation.m');
        
        fprintf('\n✅ Simulasi dasar selesai!\n');
        fprintf('📊 Hasil tersimpan di: railgun_results.mat\n');
        
        % Tanya apakah ingin melihat ringkasan
        view_summary = input('\nTampilkan ringkasan hasil? (y/n): ', 's');
        if strcmpi(view_summary, 'y')
            display_simulation_summary();
        end
        
    catch ME
        fprintf('❌ Error dalam simulasi: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% Run Parameter Optimization
function run_parameter_optimization()
    fprintf('\n🔧 Menjalankan Optimasi Parameter...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    
    % Konfirmasi karena proses ini memakan waktu
    confirm = input('Optimasi memerlukan waktu ~5-10 menit. Lanjutkan? (y/n): ', 's');
    if ~strcmpi(confirm, 'y')
        fprintf('Optimasi dibatalkan.\n');
        return;
    end
    
    try
        % Jalankan optimizer
        run('railgun_optimizer.m');
        
        fprintf('\n✅ Optimasi parameter selesai!\n');
        fprintf('📊 Hasil tersimpan di: optimization_results.mat\n');
        
    catch ME
        fprintf('❌ Error dalam optimasi: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% Run Trajectory Analysis
function run_trajectory_analysis()
    fprintf('\n🎯 Menjalankan Analisis Lintasan...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    
    try
        % Jalankan analisis lintasan
        run('railgun_trajectory_analyzer.m');
        
        fprintf('\n✅ Analisis lintasan selesai!\n');
        fprintf('📊 Hasil tersimpan di: trajectory_results.mat\n');
        
    catch ME
        fprintf('❌ Error dalam analisis lintasan: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% Run Materials Analysis
function run_materials_analysis()
    fprintf('\n🔬 Menjalankan Analisis Material & Thermal...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    
    try
        % Jalankan analisis material
        run('railgun_materials.m');
        
        fprintf('\n✅ Analisis material selesai!\n');
        fprintf('📊 Hasil tersimpan di: materials_analysis.mat\n');
        
    catch ME
        fprintf('❌ Error dalam analisis material: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% Run Comprehensive Study
function run_comprehensive_study()
    fprintf('\n🎯 Menjalankan Studi Komprehensif...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    fprintf('Ini akan menjalankan semua modul secara berurutan:\n');
    fprintf('1. Simulasi Dasar\n');
    fprintf('2. Analisis Material\n');
    fprintf('3. Analisis Lintasan\n');
    fprintf('4. Optimasi Parameter (opsional)\n\n');
    
    confirm = input('Lanjutkan studi komprehensif? (y/n): ', 's');
    if ~strcmpi(confirm, 'y')
        fprintf('Studi komprehensif dibatalkan.\n');
        return;
    end
    
    % Timer untuk mengukur waktu total
    tic;
    
    try
        % 1. Simulasi Dasar
        fprintf('\n📍 Step 1/4: Simulasi Dasar...\n');
        run('railgun_simulation.m');
        fprintf('✅ Simulasi dasar selesai.\n');
        
        % 2. Analisis Material
        fprintf('\n📍 Step 2/4: Analisis Material...\n');
        run('railgun_materials.m');
        fprintf('✅ Analisis material selesai.\n');
        
        % 3. Analisis Lintasan
        fprintf('\n📍 Step 3/4: Analisis Lintasan...\n');
        run('railgun_trajectory_analyzer.m');
        fprintf('✅ Analisis lintasan selesai.\n');
        
        % 4. Optimasi (opsional)
        opt_choice = input('\n📍 Step 4/4: Jalankan optimasi? (y/n): ', 's');
        if strcmpi(opt_choice, 'y')
            fprintf('Menjalankan optimasi...\n');
            run('railgun_optimizer.m');
            fprintf('✅ Optimasi selesai.\n');
        else
            fprintf('⏭️  Optimasi dilewati.\n');
        end
        
        total_time = toc;
        
        % Generate comprehensive report
        generate_comprehensive_report(total_time);
        
    catch ME
        fprintf('❌ Error dalam studi komprehensif: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% View Results Comparison
function view_results_comparison()
    fprintf('\n📊 Perbandingan Hasil Simulasi...\n');
    fprintf('────────────────────────────────────────────────────────────────\n');
    
    % Cek file hasil yang tersedia
    files_to_check = {'railgun_results.mat', 'optimization_results.mat', ...
                      'trajectory_results.mat', 'materials_analysis.mat'};
    available_files = {};
    
    for i = 1:length(files_to_check)
        if exist(files_to_check{i}, 'file')
            available_files{end+1} = files_to_check{i};
        end
    end
    
    if isempty(available_files)
        fprintf('❌ Tidak ada hasil simulasi yang tersedia.\n');
        fprintf('   Jalankan simulasi terlebih dahulu.\n');
        pause_and_continue();
        return;
    end
    
    fprintf('File hasil yang tersedia:\n');
    for i = 1:length(available_files)
        fprintf('%d. %s\n', i, available_files{i});
    end
    
    % Load dan tampilkan ringkasan
    try
        create_comparison_dashboard(available_files);
    catch ME
        fprintf('❌ Error dalam membuat perbandingan: %s\n', ME.message);
    end
    
    pause_and_continue();
end

%% Display Simulation Summary
function display_simulation_summary()
    try
        load('railgun_results.mat', 'results');
        
        fprintf('\n📋 RINGKASAN HASIL SIMULASI\n');
        fprintf('═══════════════════════════════════════════════════════════════\n');
        fprintf('🚀 Kecepatan Akhir    : %.2f km/s\n', results.final_velocity/1000);
        fprintf('⚡ Efisiensi Energi   : %.2f%%\n', results.efficiency);
        fprintf('🎯 Jarak Tempuh       : %.1f km\n', results.range_distance/1000);
        fprintf('📏 Ketinggian Maks    : %.1f km\n', results.max_height/1000);
        fprintf('⏱️  Waktu Penerbangan : %.1f s\n', results.flight_time);
        fprintf('⚖️  Massa Proyektil   : %.1f kg\n', results.mass_projectile);
        fprintf('📐 Panjang Rel Total  : %.0f m\n', results.total_length);
        fprintf('═══════════════════════════════════════════════════════════════\n');
        
        % Evaluasi performa
        if results.final_velocity >= 15000
            fprintf('🎉 TARGET KECEPATAN TERCAPAI! (≥15 km/s)\n');
        elseif results.final_velocity >= 5000
            fprintf('✅ Kecepatan hipersonik tercapai (≥5 km/s)\n');
        else
            fprintf('⚠️  Kecepatan masih di bawah target hipersonik\n');
        end
        
        if results.efficiency >= 50
            fprintf('🎉 EFISIENSI TINGGI! (≥50%%)\n');
        elseif results.efficiency >= 20
            fprintf('✅ Efisiensi cukup baik (≥20%%)\n');
        else
            fprintf('⚠️  Efisiensi perlu ditingkatkan\n');
        end
        
    catch
        fprintf('❌ Tidak dapat memuat hasil simulasi.\n');
    end
end

%% Generate Comprehensive Report
function generate_comprehensive_report(total_time)
    fprintf('\n📄 LAPORAN KOMPREHENSIF RAILGUN\n');
    fprintf('═══════════════════════════════════════════════════════════════\n');
    fprintf('⏱️  Total waktu eksekusi: %.1f menit\n', total_time/60);
    fprintf('📅 Tanggal: %s\n', datestr(now));
    fprintf('═══════════════════════════════════════════════════════════════\n');
    
    % Ringkasan dari setiap modul
    try
        % Basic simulation results
        if exist('railgun_results.mat', 'file')
            load('railgun_results.mat', 'results');
            fprintf('\n🚀 SIMULASI DASAR:\n');
            fprintf('   Kecepatan: %.2f km/s | Efisiensi: %.1f%%\n', ...
                    results.final_velocity/1000, results.efficiency);
        end
        
        % Materials analysis
        if exist('materials_analysis.mat', 'file')
            load('materials_analysis.mat', 'material_scores');
            fprintf('\n🔬 ANALISIS MATERIAL:\n');
            fprintf('   %d material dianalisis\n', length(material_scores));
            fprintf('   Material terbaik memiliki skor: %.1f\n', max(material_scores));
        end
        
        % Trajectory analysis
        if exist('trajectory_results.mat', 'file')
            load('trajectory_results.mat', 'results');
            max_range = max(results(:,4));
            fprintf('\n🎯 ANALISIS LINTASAN:\n');
            fprintf('   Jarak maksimum: %.1f km\n', max_range);
            fprintf('   %d konfigurasi dianalisis\n', size(results,1));
        end
        
        % Optimization results
        if exist('optimization_results.mat', 'file')
            load('optimization_results.mat', 'best_velocity', 'best_efficiency');
            fprintf('\n🔧 OPTIMASI PARAMETER:\n');
            fprintf('   Kecepatan optimal: %.2f km/s\n', best_velocity/1000);
            fprintf('   Efisiensi optimal: %.1f%%\n', best_efficiency);
        end
        
    catch ME
        fprintf('⚠️  Beberapa hasil tidak dapat dimuat: %s\n', ME.message);
    end
    
    fprintf('\n📊 Semua hasil tersimpan dalam file .mat masing-masing\n');
    fprintf('═══════════════════════════════════════════════════════════════\n');
end

%% Create Comparison Dashboard
function create_comparison_dashboard(available_files)
    figure('Position', [50, 50, 1600, 1200]);
    
    subplot_count = 1;
    
    % Plot hasil simulasi dasar
    if any(contains(available_files, 'railgun_results.mat'))
        load('railgun_results.mat', 'results');
        
        subplot(2,3,subplot_count);
        categories = {'Velocity (km/s)', 'Efficiency (%)', 'Range (km)', 'Height (km)'};
        values = [results.final_velocity/1000, results.efficiency, ...
                  results.range_distance/1000, results.max_height/1000];
        bar(values, 'FaceColor', [0.2 0.6 0.8]);
        set(gca, 'XTickLabel', categories);
        title('Hasil Simulasi Dasar');
        xtickangle(45);
        grid on;
        subplot_count = subplot_count + 1;
    end
    
    % Plot hasil optimasi
    if any(contains(available_files, 'optimization_results.mat'))
        load('optimization_results.mat', 'top_data');
        
        subplot(2,3,subplot_count);
        scatter(top_data(:,5), top_data(:,6), 100, 1:size(top_data,1), 'filled');
        xlabel('Kecepatan (km/s)');
        ylabel('Efisiensi (%)');
        title('Top 10 Konfigurasi Optimal');
        colorbar;
        grid on;
        subplot_count = subplot_count + 1;
    end
    
    % Plot hasil lintasan
    if any(contains(available_files, 'trajectory_results.mat'))
        load('trajectory_results.mat', 'results');
        
        subplot(2,3,subplot_count);
        velocities = unique(results(:,1));
        max_ranges = zeros(size(velocities));
        for i = 1:length(velocities)
            vel_data = results(results(:,1) == velocities(i), :);
            max_ranges(i) = max(vel_data(:,4));
        end
        plot(velocities, max_ranges, 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
        xlabel('Kecepatan Awal (km/s)');
        ylabel('Jarak Maksimum (km)');
        title('Performa Lintasan');
        grid on;
        subplot_count = subplot_count + 1;
    end
    
    % Plot analisis material
    if any(contains(available_files, 'materials_analysis.mat'))
        load('materials_analysis.mat', 'material_scores');
        
        subplot(2,3,subplot_count);
        bar(material_scores, 'FaceColor', [0.8 0.4 0.2]);
        xlabel('Material Index');
        ylabel('Skor Performa');
        title('Ranking Material');
        grid on;
        subplot_count = subplot_count + 1;
    end
    
    % Summary text
    subplot(2,3,subplot_count);
    axis off;
    summary_text = sprintf('DASHBOARD PERBANDINGAN\n\n');
    summary_text = [summary_text sprintf('File tersedia: %d\n', length(available_files))];
    summary_text = [summary_text sprintf('Tanggal: %s\n\n', datestr(now))];
    
    if any(contains(available_files, 'railgun_results.mat'))
        summary_text = [summary_text sprintf('✅ Simulasi Dasar\n')];
    end
    if any(contains(available_files, 'optimization_results.mat'))
        summary_text = [summary_text sprintf('✅ Optimasi Parameter\n')];
    end
    if any(contains(available_files, 'trajectory_results.mat'))
        summary_text = [summary_text sprintf('✅ Analisis Lintasan\n')];
    end
    if any(contains(available_files, 'materials_analysis.mat'))
        summary_text = [summary_text sprintf('✅ Analisis Material\n')];
    end
    
    text(0.1, 0.8, summary_text, 'FontSize', 12, 'VerticalAlignment', 'top');
    
    sgtitle('Railgun Simulation - Comparison Dashboard', 'FontSize', 16, 'FontWeight', 'bold');
    
    fprintf('📊 Dashboard perbandingan ditampilkan.\n');
end

%% Utility function
function pause_and_continue()
    fprintf('\n');
    input('Tekan Enter untuk kembali ke menu utama...', 's');
    fprintf('\n');
end

% Jalankan sistem utama
railgun_main();

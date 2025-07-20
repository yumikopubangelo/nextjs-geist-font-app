%% Railgun Modular Simulation
% Simulasi Railgun Modular dengan Distribusi Energi Segmental
% Author: Railgun Research Team
% Date: 2024

clear all; close all; clc;

%% Parameter Desain Railgun
fprintf('=== Simulasi Railgun Modular ===\n\n');

% Parameter Geometri
segment_lengths = [15, 15, 20];  % m (total 50m)
total_length = sum(segment_lengths);
n_segments = length(segment_lengths);

% Distribusi Energi per Segmen
energy_distribution = [0.5, 0.8, 1.0];  % Rasio energi per segmen

% Parameter Proyektil
mass_projectile = 0.1;  % kg (dikurangi untuk percepatan tinggi)
cross_section = 0.001;  % m^2 (luas penampang proyektil)
drag_coeff = 0.1;       % Koefisien drag untuk proyektil hipersonik

% Parameter Elektromagnetik
L_prime = 2.0e-06;      % H/m (induktansi per unit panjang)
base_resistance = 0.001; % Ohm (resistansi dasar)
temp_coeff = 0.004;     % /°C (koefisien suhu resistansi)
T0 = 20;                % °C (suhu awal)

% Parameter Arus
max_currents = [25000, 500000, 750000];  % A per segmen
current_rise_time = 0.001;  % s (waktu naik arus)

% Batasan Fisik
max_velocity = 15000;   % m/s (15 km/s batas hipersonik)
max_acceleration = 10000 * 9.81;  % m/s^2 (10000 g)

%% Inisialisasi Variabel
time_step = 0.0001;     % s
max_time = 0.1;         % s
time = 0:time_step:max_time;

% Variabel State
position = zeros(size(time));
velocity = zeros(size(time));
acceleration = zeros(size(time));
current = zeros(size(time));
temperature = T0 * ones(size(time));
resistance = base_resistance * ones(size(time));
force = zeros(size(time));
energy_kinetic = zeros(size(time));
energy_thermal = zeros(size(time));

%% Simulasi Percepatan
fprintf('Memulai simulasi percepatan...\n');

% Kondisi Awal
position(1) = 0;
velocity(1) = 0;
current_segment = 1;
segment_start = 0;

for i = 2:length(time)
    % Tentukan segmen saat ini
    if position(i-1) >= segment_start + segment_lengths(current_segment)
        if current_segment < n_segments
            current_segment = current_segment + 1;
            segment_start = segment_start + segment_lengths(current_segment-1);
        end
    end
    
    % Hitung arus berdasarkan segmen
    I_base = max_currents(min(current_segment, n_segments));
    current_ratio = energy_distribution(min(current_segment, n_segments));
    I_eff = I_base * current_ratio;
    
    % Model arus naik (ramp)
    if time(i) <= current_rise_time
        current(i) = I_eff * (time(i) / current_rise_time);
    else
        current(i) = I_eff;
    end
    
    % Hitung resistansi berdasarkan suhu
    resistance(i) = base_resistance * (1 + temp_coeff * (temperature(i-1) - T0));
    
    % Hitung gaya Lorentz
    force(i) = 0.5 * L_prime * current(i)^2;
    
    % Hitung percepatan (batasi dengan maksimum)
    acceleration(i) = force(i) / mass_projectile;
    acceleration(i) = min(acceleration(i), max_acceleration);
    
    % Integrasi numerik (Euler)
    velocity(i) = velocity(i-1) + acceleration(i) * time_step;
    velocity(i) = min(velocity(i), max_velocity);  % Batasi kecepatan
    
    position(i) = position(i-1) + velocity(i) * time_step;
    
    % Hitung energi
    energy_kinetic(i) = 0.5 * mass_projectile * velocity(i)^2;
    
    % Hitung panas (I²R losses)
    power_loss = current(i)^2 * resistance(i);
    energy_thermal(i) = energy_thermal(i-1) + power_loss * time_step;
    
    % Update suhu (sederhana)
    temperature(i) = temperature(i-1) + (power_loss * time_step) / 1000;  % Asumsi kapasitas panas
    
    % Cek jika sudah mencapai akhir rel
    if position(i) >= total_length
        final_time_index = i;
        break;
    end
end

% Potong array ke ukuran yang sesuai
time = time(1:final_time_index);
position = position(1:final_time_index);
velocity = velocity(1:final_time_index);
acceleration = acceleration(1:final_time_index);
current = current(1:final_time_index);
force = force(1:final_time_index);

%% Hasil Percepatan
final_velocity = velocity(end);
final_position = position(end);
final_time = time(end);
final_energy = energy_kinetic(end);

fprintf('\n=== Hasil Percepatan ===\n');
fprintf('Kecepatan akhir: %.2f m/s (%.2f km/s)\n', final_velocity, final_velocity/1000);
fprintf('Posisi akhir: %.2f m\n', final_position);
fprintf('Waktu tempuh: %.4f s\n', final_time);
fprintf('Energi kinetik: %.2f kJ\n', final_energy/1000);

%% Efisiensi Energi
total_energy_input = trapz(time, current.^2 * base_resistance);
efficiency = (final_energy / total_energy_input) * 100;
fprintf('Efisiensi energi: %.2f%%\n', efficiency);

%% Simulasi Lintasan dengan Drag Atmosfer
fprintf('\nMemulai simulasi lintasan...\n');

% Parameter Atmosfer
rho_air = 1.225;        % kg/m^3 (densitas udara pada permukaan)
launch_angle = 45;      % derajat
g = 9.81;               % m/s^2

% Konversi ke radian
theta = launch_angle * pi / 180;

% Kondisi awal lintasan
v0 = final_velocity;
x0 = 0;
y0 = 0;

% Fungsi untuk sistem persamaan diferensial
odefun = @(t, y) [
    y(3);  % dx/dt = vx
    y(4);  % dy/dt = vy
    -0.5 * rho_air * drag_coeff * cross_section * sqrt(y(3)^2 + y(4)^2) * y(3) / mass_projectile;
    -g - 0.5 * rho_air * drag_coeff * cross_section * sqrt(y(3)^2 + y(4)^2) * y(4) / mass_projectile;
];

% Waktu integrasi
tspan = [0 100];  % s
y0 = [x0; y0; v0*cos(theta); v0*sin(theta)];

% Solusi numerik
[t_traj, y_traj] = ode45(odefun, tspan, y0);

% Temukan saat proyektil menyentuh tanah
ground_idx = find(y_traj(:,2) < 0, 1);
if ~isempty(ground_idx)
    t_traj = t_traj(1:ground_idx);
    y_traj = y_traj(1:ground_idx,:);
end

%% Hasil Lintasan
max_height = max(y_traj(:,2));
range_distance = y_traj(end,1);
flight_time = t_traj(end);

fprintf('\n=== Hasil Lintasan ===\n');
fprintf('Jarak horizontal: %.2f m\n', range_distance);
fprintf('Ketinggian maksimum: %.2f m\n', max_height);
fprintf('Waktu penerbangan: %.2f s\n', flight_time);

%% Visualisasi
figure('Position', [100, 100, 1200, 800]);

% Subplot 1: Profil Kecepatan
subplot(2,3,1);
plot(time*1000, velocity/1000, 'b-', 'LineWidth', 2);
xlabel('Waktu (ms)');
ylabel('Kecepatan (km/s)');
title('Profil Kecepatan Proyektil');
grid on;
ylim([0, ceil(max(velocity)/1000)]);

% Subplot 2: Gaya Lorentz
subplot(2,3,2);
plot(time*1000, force/1000, 'r-', 'LineWidth', 2);
xlabel('Waktu (ms)');
ylabel('Gaya (kN)');
title('Gaya Lorentz Sepanjang Rel');
grid on;

% Subplot 3: Distribusi Arus
subplot(2,3,3);
plot(time*1000, current/1000, 'g-', 'LineWidth', 2);
xlabel('Waktu (ms)');
ylabel('Arus (kA)');
title('Profil Arus Elektromagnetik');
grid on;

% Subplot 4: Lintasan Proyektil
subplot(2,3,4);
plot(y_traj(:,1), y_traj(:,2), 'm-', 'LineWidth', 2);
xlabel('Jarak Horizontal (m)');
ylabel('Ketinggian (m)');
title('Lintasan Proyektil dengan Drag');
grid on;
axis equal;

% Subplot 5: Distribusi Energi
subplot(2,3,5);
pie(energy_distribution);
title('Distribusi Energi per Segmen');
legend({'Segmen 1 (15m)', 'Segmen 2 (15m)', 'Segmen 3 (20m)'}, 'Location', 'best');

% Subplot 6: Ringkasan Performa
subplot(2,3,6);
axis off;
text(0.1, 0.9, sprintf('Ringkasan Performa'), 'FontSize', 14, 'FontWeight', 'bold');
text(0.1, 0.8, sprintf('Kecepatan Akhir: %.1f km/s', final_velocity/1000), 'FontSize', 12);
text(0.1, 0.7, sprintf('Efisiensi: %.1f%%', efficiency), 'FontSize', 12);
text(0.1, 0.6, sprintf('Jarak: %.0f m', range_distance), 'FontSize', 12);
text(0.1, 0.5, sprintf('Tinggi Maks: %.0f m', max_height), 'FontSize', 12);
text(0.1, 0.4, sprintf('Massa Proyektil: %.1f kg', mass_projectile), 'FontSize', 12);
text(0.1, 0.3, sprintf('Panjang Rel: %.0f m', total_length), 'FontSize', 12);

sgtitle('Simulasi Railgun Modular - Analisis Komprehensif', 'FontSize', 16);

%% Simpan Hasil
results = struct();
results.final_velocity = final_velocity;
results.efficiency = efficiency;
results.range_distance = range_distance;
results.max_height = max_height;
results.flight_time = flight_time;
results.mass_projectile = mass_projectile;
results.total_length = total_length;
results.energy_distribution = energy_distribution;

save('railgun_results.mat', 'results');
fprintf('\nHasil simulasi disimpan ke railgun_results.mat\n');

%% Analisis Sensitivitas Parameter
fprintf('\n=== Analisis Sensitivitas ===\n');

% Variasi parameter untuk optimasi
current_range = [500000, 750000, 1000000];
mass_range = [0.05, 0.1, 0.2];
length_range = [40, 50, 60];

% Simpan hasil optimasi
optimization_results = [];

for I = current_range
    for m = mass_range
        for L = length_range
            % Simulasi cepat untuk optimasi
            v_opt = sqrt(L * L_prime * I^2 / m);  % Pendekatan teoritis
            efficiency_opt = 0.5 * m * v_opt^2 / (I^2 * base_resistance * L/v_opt) * 100;
            
            optimization_results = [optimization_results; I, m, L, v_opt/1000, efficiency_opt];
        end
    end
end

% Tampilkan hasil optimasi
fprintf('\nParameter Optimal (berdasarkan pendekatan teoritis):\n');
[sorted_results, idx] = sortrows(optimization_results, -4);  % Sort by velocity
for i = 1:min(5, length(idx))
    fprintf('I=%.0f kA, m=%.2f kg, L=%.0f m -> v=%.1f km/s, η=%.1f%%\n', ...
            sorted_results(i,1)/1000, sorted_results(i,2), sorted_results(i,3), ...
            sorted_results(i,4), sorted_results(i,5));
end

fprintf('\n=== Simulasi Selesai ===\n');

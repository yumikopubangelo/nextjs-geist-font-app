# Railgun Modular Simulation Suite

## 🚀 Overview

Sistem simulasi railgun modular yang komprehensif untuk merancang dan menganalisis kinerja railgun elektromagnetik dengan target kecepatan hipersonik (5-15 km/s). Sistem ini dikembangkan untuk aplikasi militer, penelitian, dan peluncuran luar angkasa.

## 📋 Fitur Utama

### 🔧 Simulasi Modular
- **Desain Segmental**: Railgun dibagi menjadi 3 segmen (15m, 15m, 20m = 50m total)
- **Distribusi Energi**: Rasio energi variabel per segmen (0.5, 0.8, 1.0)
- **Arus Bertingkat**: 25kA → 500kA → 750kA untuk optimasi gaya Lorentz

### ⚡ Fisika Elektromagnetik
- **Gaya Lorentz**: F = 0.5 × L' × I²
- **Model Termal**: Resistansi bergantung suhu R = R₀(1 + α(T-T₀))
- **Efisiensi Energi**: Analisis kehilangan panas vs energi kinetik
- **Batasan Realistis**: Kecepatan maks 15 km/s, percepatan maks 10,000g

### 🎯 Analisis Lintasan
- **Drag Atmosfer**: Model densitas udara eksponensial
- **Integrasi Numerik**: Menggunakan ODE45 untuk akurasi tinggi
- **Multi-Parameter**: Variasi sudut, ketinggian, dan kecepatan awal
- **Analisis Orbital**: Evaluasi potensi kecepatan orbit dan lepas

### 🔬 Analisis Material
- **Database Material**: Tembaga, Perak, Aluminium, Superkonductor, Grafit
- **Thermal Management**: Analisis pendinginan dan lifetime
- **Cost-Benefit**: Perbandingan performa vs biaya
- **Ranking System**: Skor berdasarkan efisiensi, resistansi, lifetime, cost

### 🎛️ Optimasi Parameter
- **Multi-Variable**: Arus, massa, panjang, resistansi
- **Target-Based**: Optimasi untuk kecepatan dan efisiensi target
- **Pareto Analysis**: Trade-off antara berbagai parameter
- **Top-N Results**: Ranking konfigurasi terbaik

## 📁 Struktur File

```
railgun_simulation_suite/
├── railgun_main.m                    # 🎮 Kontrol utama & menu
├── railgun_simulation.m              # 🚀 Simulasi dasar railgun
├── railgun_optimizer.m               # 🔧 Optimasi parameter
├── railgun_trajectory_analyzer.m     # 🎯 Analisis lintasan
├── railgun_materials.m               # 🔬 Analisis material & thermal
├── README_Railgun.md                 # 📖 Dokumentasi ini
└── hasil_simulasi/                   # 📊 Folder hasil (auto-generated)
    ├── railgun_results.mat
    ├── optimization_results.mat
    ├── trajectory_results.mat
    └── materials_analysis.mat
```

## 🚀 Quick Start

### 1. Menjalankan Sistem
```matlab
% Buka MATLAB dan jalankan:
railgun_main
```

### 2. Menu Utama
```
═══════════════════════════════════════════════════════════════
                        MENU UTAMA
═══════════════════════════════════════════════════════════════
1. Simulasi Dasar Railgun
2. Optimasi Parameter  
3. Analisis Lintasan Proyektil
4. Analisis Material & Thermal
5. Studi Komprehensif (All-in-One)
6. Perbandingan Hasil
7. Keluar
═══════════════════════════════════════════════════════════════
```

### 3. Hasil Simulasi Dasar
```
=== Hasil Percepatan ===
Kecepatan akhir: 15000.00 m/s (15.00 km/s)
Posisi akhir: 50.00 m
Waktu tempuh: 0.0067 s
Energi kinetik: 11.25 kJ
Efisiensi energi: 2.20%

=== Hasil Lintasan ===
Jarak horizontal: 598.56 m
Ketinggian maksimum: 460.41 m
Waktu penerbangan: 1.23 s
```

## 🔧 Parameter Konfigurasi

### Parameter Railgun
| Parameter | Nilai Default | Satuan | Deskripsi |
|-----------|---------------|--------|-----------|
| Panjang Segmen | [15, 15, 20] | m | Panjang setiap segmen |
| Distribusi Energi | [0.5, 0.8, 1.0] | - | Rasio energi per segmen |
| Arus Maksimum | [25k, 500k, 750k] | A | Arus per segmen |
| Massa Proyektil | 0.1 | kg | Massa proyektil |
| Induktansi | 2.0e-06 | H/m | Induktansi per unit panjang |

### Parameter Lintasan
| Parameter | Nilai Default | Satuan | Deskripsi |
|-----------|---------------|--------|-----------|
| Sudut Peluncuran | 45 | ° | Sudut elevasi |
| Koef. Drag | 0.1 | - | Koefisien drag hipersonik |
| Luas Penampang | 0.001 | m² | Luas penampang proyektil |
| Densitas Udara | 1.225 | kg/m³ | Densitas udara permukaan |

## 📊 Interpretasi Hasil

### 🎯 Target Performa
- **Kecepatan**: 5-15 km/s (hipersonik)
- **Efisiensi**: >60% (target ideal)
- **Jarak**: >10 km (aplikasi praktis)
- **Akurasi**: Presisi tinggi untuk aplikasi militer

### 📈 Metrik Evaluasi
1. **Kecepatan Akhir**: Indikator utama performa
2. **Efisiensi Energi**: Rasio energi kinetik vs total input
3. **Jarak Tempuh**: Kemampuan jangkauan proyektil
4. **Thermal Management**: Kemampuan mengelola panas
5. **Cost-Effectiveness**: Perbandingan performa vs biaya

### 🏆 Benchmark Performa
| Level | Kecepatan | Efisiensi | Status |
|-------|-----------|-----------|--------|
| Excellent | >12 km/s | >50% | 🎉 Target tercapai |
| Good | 8-12 km/s | 30-50% | ✅ Performa baik |
| Fair | 5-8 km/s | 10-30% | ⚠️ Perlu perbaikan |
| Poor | <5 km/s | <10% | ❌ Perlu redesign |

## 🔬 Analisis Lanjutan

### Material Terbaik (Ranking)
1. **Superkonductor HTS**: Efisiensi tertinggi, biaya tinggi
2. **Perak (Silver)**: Konduktivitas terbaik, biaya sedang-tinggi
3. **Tembaga (Copper)**: Baseline, cost-effective
4. **Aluminium**: Ringan, efisiensi sedang
5. **Grafit**: Tahan panas tinggi, resistansi tinggi

### Cooling Requirements
| Daya | Metode Pendinginan | Area Required |
|------|-------------------|---------------|
| <10 kW | Forced Air | ~20 m² |
| 10-100 kW | Water Cooling | ~2 m² |
| >100 kW | Liquid Nitrogen | ~0.5 m² |

## 🛠️ Customization

### Mengubah Parameter
```matlab
% Edit di railgun_simulation.m
max_currents = [50000, 750000, 1000000];  % Tingkatkan arus
mass_projectile = 0.05;                   % Kurangi massa
total_length = 75;                        % Perpanjang rel
```

### Menambah Material Baru
```matlab
% Edit di railgun_materials.m
materials.titanium.name = 'Titanium';
materials.titanium.resistivity = 4.2e-7;
materials.titanium.density = 4500;
% ... parameter lainnya
```

### Custom Trajectory
```matlab
% Edit di railgun_trajectory_analyzer.m
launch_angles = [10, 20, 30, 45, 60, 75];  % Lebih banyak sudut
altitudes = [0, 1000, 5000, 10000];        # Variasi ketinggian
```

## 📈 Optimasi Tips

### Untuk Kecepatan Maksimum:
1. Tingkatkan arus (hingga 1MA)
2. Kurangi massa proyektil (<0.1 kg)
3. Perpanjang rel (>50m)
4. Gunakan material superkonduktor

### Untuk Efisiensi Maksimum:
1. Kurangi resistansi base (<0.001 Ω)
2. Optimasi thermal management
3. Gunakan material dengan temp coeff rendah
4. Sesuaikan distribusi energi segmental

### Untuk Jarak Maksimum:
1. Sudut peluncuran 30-45°
2. Kurangi drag coefficient
3. Tingkatkan ketinggian peluncuran
4. Optimasi aerodinamika proyektil

## 🚨 Troubleshooting

### Error Umum:
1. **"Index exceeds array dimensions"**
   - Periksa parameter array (segment_lengths, energy_distribution)
   - Pastikan ukuran array konsisten

2. **"ODE solver failed"**
   - Kurangi time_step atau perpanjang max_time
   - Periksa kondisi awal yang realistis

3. **"Efficiency > 100%"**
   - Periksa perhitungan energi thermal
   - Validasi model resistansi

### Performance Issues:
- Optimasi memakan waktu lama → Kurangi resolution parameter
- Memory usage tinggi → Gunakan data sampling
- Plot tidak muncul → Periksa figure handles

## 🔮 Future Enhancements

### Planned Features:
- [ ] GUI Interface dengan MATLAB App Designer
- [ ] Real-time parameter adjustment
- [ ] 3D visualization lintasan
- [ ] Multi-stage railgun simulation
- [ ] AI-based parameter optimization
- [ ] Export ke format CAD
- [ ] Integration dengan Simulink

### Advanced Physics:
- [ ] Plasma formation modeling
- [ ] Magnetic field visualization
- [ ] Structural stress analysis
- [ ] Multi-physics coupling
- [ ] Relativistic effects (untuk v > 0.1c)

## 📚 References

1. **Electromagnetic Railgun Technology**: Naval Research Laboratory
2. **Hypersonic Projectile Dynamics**: AIAA Journal
3. **Materials for High-Current Applications**: IEEE Transactions
4. **Atmospheric Drag Models**: NASA Technical Reports
5. **Optimization Algorithms**: MATLAB Optimization Toolbox

## 👥 Contributing

Untuk berkontribusi pada pengembangan sistem ini:
1. Fork repository
2. Buat feature branch
3. Commit changes dengan deskripsi jelas
4. Submit pull request

## 📄 License

MIT License - Bebas digunakan untuk penelitian dan pengembangan

## 📞 Support

Untuk pertanyaan dan dukungan:
- Email: railgun.research@example.com
- Issues: GitHub Issues page
- Documentation: Wiki page

---

**Railgun Simulation Suite v1.0**  
*Advancing electromagnetic launch technology through comprehensive simulation*

🚀 **"Reaching for the stars, one electromagnetic pulse at a time"** 🚀

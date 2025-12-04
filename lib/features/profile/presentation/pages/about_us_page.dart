import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// --- 1. Contributor Data Model ---
class Contributor {
  final String name;
  final String instagramUrl;
  final String githubUrl;
  final String profileImagePath; // Path ke file gambar profil

  const Contributor({
    required this.name,
    required this.instagramUrl,
    required this.githubUrl,
    required this.profileImagePath,
  });
}

// --- 2. Halaman Utama About Us ---
class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  // Data Kontributor
  static const List<Contributor> contributors = [
    Contributor(
      name: 'Halim',
      profileImagePath: 'assets/profile/halim.jpg',
      instagramUrl:
          'https://www.instagram.com/qolbunhalim_46?igsh=ZzR5bWJmNmhpbDVj',
      githubUrl: 'https://github.com/byeone001',
    ),
    Contributor(
      name: 'Kadhimas',
      profileImagePath: 'assets/profile/dimas.jpeg',
      instagramUrl:
          'https://www.instagram.com/muh.kadhimas?igsh=djg4Y29zaTZmYnNk',
      githubUrl: 'https://github.com/kadhimass',
    ),
    Contributor(
      name: "Yusa'",
      profileImagePath: 'assets/profile/yusa.jpeg',
      instagramUrl:
          'https://www.instagram.com/ysekstwn?igsh=MWQ0dGxtcGVzYzh3YQ==',
      githubUrl: 'https://github.com/Yusa137D',
    ),
    Contributor(
      name: 'Wendy',
      profileImagePath: 'assets/profile/wendy.jpeg',
      instagramUrl:
          'https://www.instagram.com/wendyfrp_?igsh=a2tzdXNmOTg3b2V1&utm_source=qr',
      githubUrl: 'https://github.com/wendyfrp',
    ),
    Contributor(
      name: 'Sarah',
      profileImagePath: 'assets/profile/avatar.jpg',
      instagramUrl:
          'https://www.instagram.com/sarahamaylia?igsh=MTlyZjQ2dzVnZWh2aA==',
      githubUrl: 'https://github.com/SARAHAMAYLIA',
    ),
    Contributor(
      name: 'Syifa',
      profileImagePath: 'assets/profile/avatar.jpg',
      instagramUrl:
          'https://www.instagram.com/syifaaaanur__?igsh=MWdyOWpzMGdhODFybA%3D%3D&utm_source=qr',
      githubUrl: 'https://github.com/nurasyifaaa',
    ),
    Contributor(
      name: 'Oktavia',
      profileImagePath: 'assets/profile/avatar.jpg',
      instagramUrl: 'https://www.instagram.com/_viyyaaaa?igsh=a3B0a2JiYjdzNWYy',
      githubUrl: 'https://github.com/Oktavia-Rahma',
    ),
  ];

  // Warna utama aplikasi (Orange)
  static const Color primaryOrange = Colors.orange;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Logika responsif untuk jumlah kolom GridView
    int crossAxisCount;
    if (width >= 1200) {
      crossAxisCount = 4;
    } else if (width >= 800) {
      crossAxisCount = 3;
    } else if (width >= 500) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1; // Untuk mobile portrait
    }

    // Rasio aspek untuk menyesuaikan tinggi kartu
    final double childAspectRatio = width < 500 ? 1.0 : 1.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Tim Kontributor',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kami adalah tim pengembang yang berdedikasi di balik aplikasi ini.',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Grid Kontributor yang Responsif
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contributors.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final contributor = contributors[index];
                return ContributorCard(
                  contributor: contributor,
                  primaryColor: primaryOrange,
                );
              },
            ),
            const SizedBox(height: 32),

            // Informasi Tambahan
            const Center(
              child: Text(
                'Dibuat dengan ❤️ menggunakan Flutter',
                style: TextStyle(color: Colors.black45, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 3. Widget Card Kontributor ---
class ContributorCard extends StatelessWidget {
  const ContributorCard({
    super.key,
    required this.contributor,
    required this.primaryColor,
  });

  final Contributor contributor;
  final Color primaryColor;

  // Fungsi untuk mendapatkan inisial dari nama
  String getInitials(String name) {
    final parts = name.split(RegExp(r"\s+|'-"));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  // Fungsi untuk mendapatkan warna avatar unik berdasarkan nama
  Color avatarColor(String name) {
    final chars = name.codeUnits;
    final seed = chars.fold<int>(0, (p, c) => p + c);
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.brown,
    ];
    return colors[seed % colors.length];
  }

  // Fungsi untuk meluncurkan URL (Instagram/GitHub)
  Future<void> _launchUrl(BuildContext context, String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Link tidak tersedia')));
      return;
    }
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka tautan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage = contributor.profileImagePath.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // Garis tepi/stroke hitam
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Foto Profil/Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: primaryColor,
              child: hasImage
                  ? ClipOval(
                      child: Image.asset(
                        contributor.profileImagePath,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        // Jika gambar gagal dimuat, tampilkan inisial
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            getInitials(contributor.name),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          );
                        },
                      ),
                    )
                  : Text(
                      getInitials(contributor.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // Nama Kontributor
            Text(
              contributor.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),

            // Peran
            Text(
              'Pengembang Flutter',
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),

            // Tautan Sosial
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Instagram
                IconButton(
                  tooltip: 'Instagram',
                  onPressed: () =>
                      _launchUrl(context, contributor.instagramUrl),
                  icon: Image.asset(
                    'assets/instagram.jpeg', // PATH DIPERBAIKI
                    width: 50, // UKURAN IKON DISESUAIKAN
                    height: 50,
                  ),
                  // Tidak perlu color jika menggunakan asset image
                ),
                const SizedBox(width: 2),

                // Tombol GitHub
                IconButton(
                  tooltip: 'GitHub',
                  onPressed: () => _launchUrl(context, contributor.githubUrl),
                  icon: Image.asset(
                    'assets/github.png',
                    width: 50,
                    height: 50,
                    //color: Colors.black87, // Beri warna pada ikon GitHub (jika berupa PNG satu warna)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

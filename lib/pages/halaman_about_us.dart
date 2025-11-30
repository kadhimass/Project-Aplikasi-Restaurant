import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  static const List<String> contributors = [
    'Halim',
    'Kadhimas',
    "Yusa'",
    'Wendy',
    'Sarah',
    'Syifa',
    'Oktavia',
  ];

  // Peta link Instagram dan GitHub untuk setiap kontributor
  static const Map<String, Map<String, String>> socialLinks = {
    'Halim': {
      'instagram':
          'https://www.instagram.com/qolbunhalim_46?igsh=ZzR5bWJmNmhpbDVj',
      'github': 'https://github.com/byeone001',
    },
    'Kadhimas': {
      'instagram':
          'https://www.instagram.com/muh.kadhimas?igsh=djg4Y29zaTZmYnNk',
      'github': 'https://github.com/kadhimass',
    },
    "Yusa'": {
      'instagram':
          'https://www.instagram.com/ysekstwn?igsh=MWQ0dGxtcGVzYzh3YQ==',
      'github': 'https://github.com/Yusa137D',
    },
    'Wendy': {
      'instagram':
          'https://www.instagram.com/wendyfrp_?igsh=a2tzdXNmOTg3b2V1&utm_source=qr',
      'github': 'https://github.com/wendyfrp',
    },
    'Sarah': {
      'instagram':
          'https://www.instagram.com/sarahamaylia?igsh=MTlyZjQ2dzVnZWh2aA==',
      'github': 'https://github.com/SARAHAMAYLIA',
    },
    'Syifa': {
      'instagram':
          'https://www.instagram.com/syifaaaanur__?igsh=MWdyOWpzMGdhODFybA%3D%3D&utm_source=qr',
      'github': 'https://github.com/nurasyifaaa',
    },
    'Oktavia': {
      'instagram': 'https://www.instagram.com/_viyyaaaa?igsh=a3B0a2JiYjdzNWYy',
      'github': 'https://github.com/Oktavia-Rahma',
    },
  };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final crossAxis = width < 600 ? 2 : 4;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contributors', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxis,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: contributors
                    .map(
                      (name) => ContributorCard(
                        name: name,
                        instagramUrl: socialLinks[name]?['instagram'] ?? '',
                        githubUrl: socialLinks[name]?['github'] ?? '',
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContributorCard extends StatelessWidget {
  const ContributorCard({
    super.key,
    required this.name,
    required this.instagramUrl,
    required this.githubUrl,
  });

  final String name;
  final String instagramUrl;
  final String githubUrl;

  String getInitials(String name) {
    final parts = name.split(RegExp(r"\s+|'-"));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

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

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(String url) async {
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

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: avatarColor(name),
            child: Text(
              getInitials(name),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Instagram',
                onPressed: () => _launchUrl(instagramUrl),
                icon: Image.asset(
                  'assets/instagram.jpeg',
                  width: 22,
                  height: 22,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'GitHub',
                onPressed: () => _launchUrl(githubUrl),
                icon: Image.asset('assets/github.png', width: 22, height: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

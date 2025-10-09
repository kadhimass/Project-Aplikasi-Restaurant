import 'dart:async';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:menu_makanan/halaman_login.dart';
import 'package:flutter/material.dart';

// 1. Import library yang dibutuhkan
import 'package:shared_preferences/shared_preferences.dart';
// Sesuaikan dengan nama halaman utama Anda

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    // 2. Ganti blok Timer dengan memanggil fungsi pengecekan
    _checkLoginStatus();
  }

  // 3. Tambahkan fungsi untuk mengecek status login
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Cek apakah ada data yang disimpan dengan key 'user_email'
    final String? userEmail = prefs.getString('user_email');

    // Beri jeda waktu agar animasi Anda selesai berjalan
    await Future.delayed(const Duration(seconds: 3));

    // Pengecekan 'mounted' adalah praktik terbaik sebelum navigasi
    if (!mounted) return;

    if (userEmail != null && userEmail.isNotEmpty) {
      // Jika ADA email, navigasi ke halaman utama
      Navigator.pushReplacementNamed(
        context,
        "/main",
        arguments: {"email": userEmail},
      );
    } else {
      // Jika TIDAK ADA email, navigasi ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HalamanLogin()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bagian ini tidak diubah sama sekali
    return Scaffold(
      backgroundColor: Colors.deepPurple[900],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  image: const DecorationImage(
                    image: AssetImage('assets/LOGO.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              const Text(
                'WARUNG KITA',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Text(
                'By Qolbun Halim Hidayatulloh\n24111814065',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
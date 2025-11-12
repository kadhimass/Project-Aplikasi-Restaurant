import 'package:menu_makanan/halaman_login.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:go_router/go_router.dart';

class HalamanRegistrasi extends StatefulWidget {
  const HalamanRegistrasi({super.key});

  @override
  State<HalamanRegistrasi> createState() => _HalamanRegistrasiState();
}

class _HalamanRegistrasiState extends State<HalamanRegistrasi> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String message = "";

  void _register() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => message = "Semua field wajib diisi!");
      return;
    }

    if (fakeDatabase.containsKey(email)) {
      setState(() => message = "Email sudah terdaftar!");
      return;
    }

    fakeDatabase[email] = password;
    // After successful registration, go to login (replace stack)
    context.goNamed('login');
    //setState(() => message = "Registrasi berhasil! Silakan login.");
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Buat Akun Baru",
      fields: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              hintText: "Masukkan email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Password
          TextField(
            controller: passwordController,
            obscureText: isPasswordVisible ? false : true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: "Masukkan password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          if (message.isNotEmpty) ...[
            Text(message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
          ],

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _register,
              child: const Text("REGISTER"),
            ),
          ),
        ],
      ),
      //mainButtonText: "REGISTER",
      //onMainButtonPressed: _register,
      bottomText: "Sudah punya akun?",
      bottomButtonText: "Login",
      onBottomButtonPressed: () {
        context.pushNamed('login');
      },
    );
  }
}

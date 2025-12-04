import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:menu_makanan/widgets/auth_scaffold.dart';
import 'package:menu_makanan/main.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- 1. IMPORT

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});
  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String errorMessage = "";
  bool rememberMe = true;

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (fakeDatabase.containsKey(email) && fakeDatabase[email] == password) {
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', email);
      }

      // Navigate to main screen (replace) using go_router
      context.goNamed('main', extra: {'email': email});
    } else {
      setState(() {
        errorMessage = "Email atau password salah!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Silahkan Login",
      fields: Column(
        children: [
          // TextField Email (tidak diubah)
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              hintText: "Masukkan Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // TextField Password (tidak diubah)
          TextField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: "Masukkan Password",
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

          if (errorMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
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
              onPressed: _login,
              child: const Text('LOGIN'),
            ),
          ),
          // Remember & Forgot
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (val) {
                      setState(() {
                        rememberMe = val!;
                      });
                    },
                  ),
                  const Text("Ingat Saya"),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed('forgot');
                },
                child: const Text("Lupa Password?"),
              ),
            ],
          ),
        ],
      ),
      bottomText: "Belum Punya Akun?",
      bottomButtonText: "Buat Akun",
      onBottomButtonPressed: () {
        context.pushNamed('register');
      },
    );
  }
}

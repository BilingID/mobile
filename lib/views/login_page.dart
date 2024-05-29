import 'package:flutter/material.dart';
import 'package:bilingid/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/controllers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;
  String? _errorText;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi email dan kata sandi.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final String token = await apiService.login(
        emailController.text,
        passwordController.text,
      );
      final userProfile = await apiService.getUserProfile(token);
      userProvider.setUser(userProfile);
      navigator.pushReplacementNamed('/homepage');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to login: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bgLoginRegis.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'BiLing.ID',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Alamat Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      errorText: _errorText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          hintText: 'Kata Sandi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: _isObscure,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Login', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/registerpage');
                    },
                    child: Text(
                      'Belum punya akun? Daftar Disini!',
                      style: GoogleFonts.roboto(color: Colors.purple,fontSize: 16,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PopScope(
        canPop: false,
        child: Container(height: 0),
      ),
    );
  }
}

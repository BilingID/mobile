import 'package:bilingid/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:bilingid/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  void register() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan.')),
      );
      return;
    }
    if (passwordController.text.length < 8 ||
        passwordConfirmController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi minimal 8 karakter.')),
      );
      return;
    }
    if (passwordController.text != passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak sama.')),
      );
      return;
    }
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty ||
        passwordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua kolom.')),
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
      final String token = await apiService.register(
        _agreeToTerms,
        nameController.text,
        emailController.text,
        passwordController.text,
        passwordConfirmController.text,
      );
      final userProfile = await apiService.getUserProfile(token);
      userProvider.setUser(userProfile);
      navigator.pushReplacementNamed('/homepage');
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('$e')),
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
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      hintText: 'Nama Lengkap',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                        obscureText: _isObscurePassword,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        },
                        icon: Icon(
                          _isObscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: passwordConfirmController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          hintText: 'Konfirmasi Kata Sandi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: _isObscureConfirmPassword,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _isObscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Terima syarat dan ketentuan',
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    value: _agreeToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.purple,
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Register',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/loginpage');
                    },
                    child: Text(
                      'Sudah punya akun? Masuk Disini!',
                      style: GoogleFonts.poppins(
                        color: Colors.purple,
                        fontSize: 16,
                      ),
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

import 'package:bilingid/controllers/konseling_provider.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/konseling_session.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KonselingMulaiPage extends StatefulWidget {
  const KonselingMulaiPage({super.key, required this.konselingSession});

  final KonselingSession konselingSession;

  @override
  KonselingMulaiPageState createState() => KonselingMulaiPageState();
}

class KonselingMulaiPageState extends State<KonselingMulaiPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _handleFinishKonseling() async {
    final konselingProvider =
        Provider.of<KonselingProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String status =
        await konselingProvider.finishKonseling(widget.konselingSession.id);
    if (!mounted) return;

    if (status == 'success') {
      userProvider.selectMenu('Jadwal');
      Navigator.pushNamed(context, '/profilemenu');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menyelesaikan konseling')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyelesaikan konseling')),
      );
    }
    _launchURL(widget.konselingSession.meetUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mulai Konseling',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF007BFF),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Color(0xFFF5F5F5),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Konseling dengan ${widget.konselingSession.psychologistFullName}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Berikut adalah link Google Meet yang digunakan:',
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _handleFinishKonseling,
                  child: Text(
                    widget.konselingSession.meetUrl,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bilingid/models/konseling_session.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class KonselingResultPage extends StatefulWidget {
  const KonselingResultPage({super.key, required this.konselingSession});

  final KonselingSession konselingSession;

  @override
  KonselingResultPageState createState() => KonselingResultPageState();
}

class KonselingResultPageState extends State<KonselingResultPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _downloadAttachment(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diagnosa Konseling',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF007BFF),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hasil Konseling:',
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (widget.konselingSession.attachmentPath == '')
              Text(
                'Hasil Konseling masih belum tersedia',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            else
              ElevatedButton(
                onPressed: () =>
                    _downloadAttachment(widget.konselingSession.attachmentPath),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: const Color(0xFFFFA726),
                ),
                child: Text(
                  'Download Attachment',
                  style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Hasil Konseling berupa Docs atau PDF yang dapat didownload',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bilingid/controllers/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/controllers/psikotes_provider.dart';

class Psikotes extends StatelessWidget {
  const Psikotes({super.key});

  @override
  Widget build(BuildContext context) {
    final psikotesProvider =
        Provider.of<PsikotesProvider>(context, listen: false);
    final AuthUtil authUtil = AuthUtil();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            'Tes kepribadian MBTI: Kenali dirimu lebih jauh!',
                            style: GoogleFonts.poppins(
                                fontSize: 28, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Tes MBTI ini bertujuan untuk membantu memahami keunikan kepribadian yang ada pada dirimu. Ketahuilah preferensi dan kecenderungan psikologimu sekarang!',
                            style: GoogleFonts.poppins(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Baca panduan pengisiannya dulu yuk!',
                            style: GoogleFonts.poppins(
                                fontSize: 19, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGuidelineItem(0,
                                  'Di tes ini tidak ada jawaban benar atau salah. Jadi isilah dengan jujur sesuai kepribadianmu.'),
                              _buildGuidelineItem(1,
                                  'Tes ini tidak ada batasan waktu pengerjaan.'),
                              _buildGuidelineItem(2,
                                  'Kerjakan dengan fokus, cari tempat yang kondusif dan bikin kamu nyaman.'),
                              _buildGuidelineItem(3,
                                  'Seluruh proses tes dan jawaban akan hilang kalau kamu keluar di tengah tes.'),
                              _buildGuidelineItem(
                                  4, 'Isilah semua pertanyaan dengan lengkap.'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Yakin memulai tes?',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold)),
                                      content: Text(
                                          'Apakah Anda yakin ingin memulai tes ini?',
                                          style: GoogleFonts.poppins()),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Batal',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            String code = await psikotesProvider
                                                .createPsychotest();
                                            if (context.mounted) {
                                              authUtil.cekTokenToProfile(
                                                  context, 'Psikotes',
                                                  route: '/psikotesquestion',
                                                  code: code);
                                            }
                                          },
                                          child: Text('Mulai',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.blue)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                textStyle: GoogleFonts.poppins(fontSize: 18),
                                backgroundColor: const Color(0xFF007BFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Mulai',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PopScope(
        canPop: false,
        child: Container(height: 0),
      ),
    );
  }

  Widget _buildGuidelineItem(int index, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ',
            style:
                GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

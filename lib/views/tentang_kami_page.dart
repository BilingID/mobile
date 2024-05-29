import 'package:bilingid/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TentangKami extends StatelessWidget {
  const TentangKami({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 255,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Konseling untuk kehidupan yang lebih baik dengan Psikolog terbaik',
                              style: GoogleFonts.poppins(
                                  fontSize: 26.9, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/images/landing.0746528c5e6189b2b8d6.png',
                                fit: BoxFit.contain,
                                height: 150,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Dengan bimbingan konseling online, kamu mendapatkan bantuan, menjadi lebih baik, dan kamu pantas untuk bahagia.',
                  style: GoogleFonts.poppins(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      userProvider.selectMenu('Psikotes');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Mulai Psikotes',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Text(
                  'Paling diutamakan dan terpercaya',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Platform Konseling Online di Indonesia',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatisticItem('Psikolog Aktif', '987', Icons.person),
                    _buildStatisticItem(
                        'Konseling', '1,234', Icons.video_camera_front),
                    _buildStatisticItem('Jumlah Klien', '10,987', Icons.groups,
                        lastItem: true),
                  ],
                ),
                const SizedBox(height: 40),
                _buildCounselingSection(),
                _buildHowToUseSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PopScope(
        canPop: false,
        child: Container(height: 0),
      ),
    );
  }

  Widget _buildStatisticItem(String title, String value, IconData iconData,
      {bool lastItem = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: lastItem
              ? null
              : const Border(right: BorderSide(color: Colors.grey)),
        ),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                iconData,
                color: Colors.blue,
                size: 35,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/hands.png',
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 20),
              Image.asset(
                'assets/images/smile.png',
                width: 100,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Konseling online terbaik',
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Team Psikolog kami telah berpengalaman membantu orang dalam menangani beberapa masalah.',
            style: GoogleFonts.poppins(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BulletPoint(text: 'Stress Berat'),
                    BulletPoint(text: 'Depresi'),
                    BulletPoint(text: 'Hubungan'),
                    BulletPoint(text: 'Keuangan'),
                    BulletPoint(text: 'Penyalahgunaan'),
                    BulletPoint(text: 'Kehilangan'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BulletPoint(text: 'Stress Berat'),
                    BulletPoint(text: 'Depresi'),
                    BulletPoint(text: 'Hubungan'),
                    BulletPoint(text: 'Keuangan'),
                    BulletPoint(text: 'Penyalahgunaan'),
                    BulletPoint(text: 'Kehilangan'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseSection() {
    return Container(
      margin: const EdgeInsets.only(top: 40, bottom: 0),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Mulailah jelajahi kesehatan emosional & mentalmu',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Ikuti langkah-langkah berikut untuk menggunakan platform BiLing.ID',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(1, 'Simulasikan psikotes',
                  'Lakukan simulasi psikotes terlebih dahulu, agar kamu dapat mempunyai gambaran dan perkiraan hasil tes yang sesungguhnya'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(2, 'Lakukan psikotes',
                  'Lakukan psikotes sesuai dengan hasil simulasi yang kamu dapatkan, dan dapatkan hasilnya'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(3, 'Pilih Psikolog tepat',
                  'Pilih psikolog yang sesuai dengan kebutuhan kamu, dan jadwalkan konseling'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(4, 'Jadwalkan konseling',
                  'Pilih jadwal konseling yang sesuai dengan kebutuhan kamu, dan jadwalkan konseling'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(5, 'Mulai berbicara',
                  'Mulai konseling dengan psikolog yang kamu pilih, dan mulai berbicara'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepItem(6, 'Hidup lebih baik',
                  'Dengan konseling yang kamu lakukan, kamu akan mendapatkan kehidupan yang lebih baik'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int stepNumber, String title, String description) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    '$stepNumber',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'konseling_detail_page.dart';

class Konseling extends StatelessWidget {
  const Konseling({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<void> initialization = _initializePsychologs(context);

    return Scaffold(
      body: FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildPsychologsList(context);
          }
        },
      ),
      bottomNavigationBar: PopScope(
        canPop: false,
        child: Container(height: 0),
      ),
    );
  }

  Future<void> _initializePsychologs(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.psychologs.isEmpty) {
      await userProvider.initializePsychologs();
    }
  }

  Widget _buildPsychologsList(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final psychologs = userProvider.psychologs;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              for (int i = 0;
                  i < psychologs.length;
                  i += 2)
                Row(
                  children: [
                    Expanded(
                      child: _buildPsychologCard(context, psychologs[i]),
                    ),
                    if (i + 1 < psychologs.length)
                      Expanded(
                        child: _buildPsychologCard(context, psychologs[i + 1]),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPsychologCard(BuildContext context, User psycholog) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailKonseling(id: psycholog.id)),
        );
      },
      child: SizedBox(
        height: 330,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Card(
            color: const Color(0xDDEFECF3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFF007BFF),
                    backgroundImage: psycholog.profilePhoto != null
                        ? NetworkImage(psycholog.profilePhoto!)
                        : null,
                    child: psycholog.profilePhoto == null
                        ? const Icon(Icons.person,
                            size: 70, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      '2001+ Sesi',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    psycholog.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

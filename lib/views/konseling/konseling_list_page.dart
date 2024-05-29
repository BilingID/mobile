import 'package:bilingid/api_service.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/konseling_session.dart';
import 'package:bilingid/views/konseling/konseling_hasil_page.dart';
import 'package:bilingid/views/konseling/konseling_mulai_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class KonselingListPage extends StatefulWidget {
  const KonselingListPage({super.key});

  @override
  KonselingListPageState createState() => KonselingListPageState();
}

class KonselingListPageState extends State<KonselingListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<KonselingSession>> _konselingFuture;

  @override
  void initState() {
    super.initState();
    _konselingFuture = _apiService.getKonselingSessions();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:const Color(0xFFF5F5F5),
      body: FutureBuilder<List<KonselingSession>>(
        future: _konselingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final konselingSessions = snapshot.data!;
            return ListView.builder(
              itemCount: konselingSessions.length,
              itemBuilder: (context, index) {
                final konselingSession = konselingSessions[index];
                return InkWell(
                  onTap: () {
                    if (konselingSession.status == 'finish') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KonselingResultPage(
                            konselingSession: konselingSession,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Yakin memulai konseling?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            content: Text('Apakah Anda yakin ingin memulai konseling ini?', style: GoogleFonts.poppins()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Batal', style: GoogleFonts.poppins(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KonselingMulaiPage(
                                        konselingSession: konselingSession,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Mulai', style: GoogleFonts.poppins(color: Colors.blue)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: konselingSession.status == 'finish'
                                      ? const Color(0xFF007BFF).withOpacity(0.3)
                                      : const Color(0xFFFFFF00).withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.assignment),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konseling - ${user?.role != 'psychologist' ? konselingSession.psychologistFullName : konselingSession.userFullName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black87),
                                    children: [
                                      TextSpan(
                                        text: 'Waktu: ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '${konselingSession.meetDate} - ${konselingSession.meetTime}',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black87),
                                    children: [
                                      TextSpan(
                                        text: 'Status: ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: konselingSession.status == 'finish'
                                            ? 'Telah dikerjakan'
                                            : 'Belum dikerjakan',
                                        style: GoogleFonts.poppins(
                                          color: konselingSession.status == 'finish'
                                              ? Colors.blue
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          userProvider.selectMenu('Tentang Kami');
          Navigator.pop(context);
        },
        child: Container(height: 0),
      ),
    );
  }
}

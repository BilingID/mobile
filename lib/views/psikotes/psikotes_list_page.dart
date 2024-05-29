import 'package:bilingid/api_service.dart';
import 'package:bilingid/controllers/auth_util.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/psikotes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PsikotesListPage extends StatefulWidget {
  const PsikotesListPage({super.key});

  @override
  PsikotesListPageState createState() => PsikotesListPageState();
}

class PsikotesListPageState extends State<PsikotesListPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Psikotes>> _psychotestsFuture;

  @override
  void initState() {
    super.initState();
    _psychotestsFuture = _apiService.getPsychotests();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder<List<Psikotes>>(
        future: _psychotestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final psychotests = snapshot.data!;
            final AuthUtil authUtil = AuthUtil();
            return ListView.builder(
              itemCount: psychotests.length,
              itemBuilder: (context, index) {
                final psychotest = psychotests[index];
                return InkWell(
                  onTap: () {
                    if (psychotest.status == 'finish') {
                      authUtil.cekTokenToProfile(context, 'PsikotesList',
                          route: '/psikotesresult', code: psychotest.code);
                    } else {
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
                                    style:
                                        GoogleFonts.poppins(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  authUtil.cekTokenToProfile(
                                      context, 'PsikotesList',
                                      route: '/psikotesquestion',
                                      code: psychotest.code);
                                },
                                child: Text('Mulai',
                                    style: GoogleFonts.poppins(
                                        color: Colors.blue)),
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
                      padding: const EdgeInsets.only(
                          left: 24, right: 16, top: 16, bottom: 16),
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
                                  color: psychotest.status == 'finish'
                                      ? const Color(0xFF007BFF).withOpacity(0.3)
                                      : const Color(0xFFFFFF00)
                                          .withOpacity(0.5),
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
                                  'Psikotes',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.black87),
                                    children: [
                                      TextSpan(
                                        text: 'Tanggal pembayaran: ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: psychotest.updateDate,
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
                                        text: psychotest.status == 'finish'
                                            ? 'Telah dikerjakan'
                                            : 'Belum dikerjakan',
                                        style: GoogleFonts.poppins(
                                          color: psychotest.status == 'finish'
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
          Navigator.pushReplacementNamed(context, '/homepage');
        },
        child: Container(height: 0),
      ),
    );
  }
}

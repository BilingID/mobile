import 'package:bilingid/controllers/psikotes_provider.dart';
import 'package:bilingid/models/results.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_provider.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.code});

  final String code;

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  late Future<Map<String, dynamic>> _futureResults;

  @override
  void initState() {
    super.initState();
    final psikotesProvider =
        Provider.of<PsikotesProvider>(context, listen: false);
    _futureResults = _fetchResults(psikotesProvider, widget.code);
  }

  Future<Map<String, dynamic>> _fetchResults(
      PsikotesProvider psikotesProvider, String code) async {
    return await psikotesProvider.fetchResults(code);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Results',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF007BFF),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching results'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No results found'));
          } else {
            final Results results = Results.fromJson(snapshot.data!);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your personality is:',
                    style: GoogleFonts.poppins(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    results.personality,
                    style: GoogleFonts.poppins(
                        fontSize: 60, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    results.description,
                    style: GoogleFonts.poppins(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
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
          userProvider.selectMenu('PsikotesList');
          Navigator.pushReplacementNamed(context, '/profilemenu');
        },
        child: Container(height: 0),
      ),
    );
  }
}

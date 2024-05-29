import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'FAQ BiLing.ID',
                              style: GoogleFonts.poppins(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Pertanyaan seputar bimbingan konseling online',
                              style: GoogleFonts.poppins(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      const FAQItem(
                        question:
                            'Apa saja yang akan saya dapatkan setelah konseling?',
                        answer:
                            'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Cupiditate voluptates dolorem necessitatibus maiores? Iusto repellat accusamus vero provident exercitationem. Architecto.',
                      ),
                      const FAQItem(
                        question: 'Konseling itu prosesnya seperti apa?',
                        answer:
                            'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Cupiditate voluptates dolorem necessitatibus maiores? Iusto repellat accusamus vero provident exercitationem. Architecto.',
                      ),
                      const FAQItem(
                        question: 'Berapa lama durasi sesi konseling online?',
                        answer:
                            'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Cupiditate voluptates dolorem necessitatibus maiores? Iusto repellat accusamus vero provident exercitationem. Architecto.',
                      ),
                      const FAQItem(
                        question:
                            'Platform apa yang digunakan untuk konseling online?',
                        answer:
                            'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Cupiditate voluptates dolorem necessitatibus maiores? Iusto repellat accusamus vero provident exercitationem. Architecto.',
                      ),
                      const FAQItem(
                        question:
                            'Apakah privasi dan kerahasiaan cerita saya terjamin?',
                        answer:
                            'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Cupiditate voluptates dolorem necessitatibus maiores? Iusto repellat accusamus vero provident exercitationem. Architecto.',
                      ),
                    ],
                  ),
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
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer, super.key});

  @override
  FAQItemState createState() => FAQItemState();
}

class FAQItemState extends State<FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
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
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 24,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  widget.answer,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

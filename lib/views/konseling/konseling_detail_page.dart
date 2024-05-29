import 'package:bilingid/controllers/konseling_provider.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailKonseling extends StatefulWidget {
  const DetailKonseling({super.key, required this.id});

  final int id;

  @override
  DetailKonselingState createState() => DetailKonselingState();
}

class DetailKonselingState extends State<DetailKonseling> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final konselingProvider =
        Provider.of<KonselingProvider>(context, listen: false);
    User? psycholog = userProvider.getPsycholog(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Konseling',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF007BFF),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: psycholog != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 12,
                  color: const Color(0xDDEFECF3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xDDEFECF3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileSection(psycholog),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Profil Psikolog'),
                          Text(
                            psycholog.bioDesc,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Keahlian Psikolog'),
                          Text(
                            psycholog.skillDesc,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.black),
                          const SizedBox(height: 20),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDateTimePicker(
                                  context,
                                  'Pilih Tanggal',
                                  _selectedDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_selectedDate!)
                                      : 'dd/mm/yyyy',
                                  Icons.calendar_today,
                                  _selectDate,
                                ),
                                const SizedBox(width: 20),
                                _buildDateTimePicker(
                                  context,
                                  'Pilih Waktu',
                                  _selectedTime != null
                                      ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                      : '-- : --',
                                  Icons.access_time,
                                  _selectTime,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_selectedDate != null &&
                                    _selectedTime != null) {
                                  String date = DateFormat('yyyy-MM-dd')
                                      .format(_selectedDate!);
                                  String time =
                                      '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
                                  String status = await konselingProvider
                                      .createKonselingSession(
                                          widget.id, date, time);
                                  if (mounted) {
                                    _handleKonselingSessionCreation(status);
                                  }
                                } else {
                                  _showSnackBar('Mohon isi tanggal dan waktu');
                                }
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
                                'Daftar Konseling',
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
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          userProvider.selectMenu('Konseling');
          Navigator.pop(context);
        },
        child: Container(height: 0),
      ),
    );
  }

  Widget _buildProfileSection(User psycholog) {
    return Row(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF007BFF),
          ),
          child: Center(
            child: psycholog.profilePhoto != null
                ? ClipOval(
                    child: Image.network(
                      psycholog.profilePhoto!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                psycholog.fullName,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Jumlah sesi konseling: ',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '2001+ Sesi',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDateTimePicker(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Future<void> Function(BuildContext) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Icon(icon),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleKonselingSessionCreation(String status) {
    if (status == 'success') {
      Navigator.of(context).pop();
      _showSnackBar('Berhasil mendaftarkan konseling');
    } else {
      _showSnackBar('Error mendaftarkan konseling');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/user.dart';
import 'package:bilingid/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ApiService apiService = ApiService();
  bool isEditing = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String? _gender;
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    _nameController = TextEditingController(text: user?.fullName);
    _phoneController = TextEditingController(text: user?.phone);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _gender = user?.gender;
    _dateOfBirth = user?.dateOfBirth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    bool hasChanges = false;
    bool hasChangesPass = false;
    Map<String, String> updatedFields = {};

    if (_nameController.text != user?.fullName) {
      updatedFields['fullname'] = _nameController.text;
      hasChanges = true;
    }
    if (_phoneController.text != user?.phone &&
        user?.phone != 'Belum ditentukan') {
      if (_phoneController.text.length < 11 ||
          _phoneController.text.length > 14) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone length must be >= 11 and <= 14')),
        );
        return;
      }
      updatedFields['phone'] = _phoneController.text;
      hasChanges = true;
    }
    if (_gender != user?.gender) {
      updatedFields['gender'] = _gender!;
      hasChanges = true;
    }
    if (_dateOfBirth != user?.dateOfBirth) {
      updatedFields['date_of_birth'] =
          DateFormat('yyyy-MM-dd').format(_dateOfBirth!);
      hasChanges = true;
    }
    if (_passwordController.text.isNotEmpty ||
        _confirmPasswordController.text.isNotEmpty) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kata sandi tidak sama')),
        );
        return;
      } else {
        hasChangesPass = true;
      }
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (hasChanges || hasChangesPass) {
      if (hasChangesPass) {
        await apiService.changePassword(
            _passwordController.text, _confirmPasswordController.text);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Password berhasil diubah')),
        );
      } else {
        final String? token = await apiService.updateUser(updatedFields);
        final userProfile = await apiService.getUserProfile(token!);
        userProvider.setUser(userProfile);
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Profil berhasil diubah')),
        );
      }
      setState(() {
        isEditing = false;
      });
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Tidak ada perubahan file')),
      );
    }
  }

  void _cancelChanges() {
    setState(() {
      isEditing = false;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      _nameController.text = user?.fullName ?? '';
      _phoneController.text = user?.phone ?? '';
      _gender = user?.gender ?? 'male';
      _dateOfBirth = user?.dateOfBirth;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Yakin tinggal halaman?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Perubahan belum disimpan. Batal dan tinggalkan?',
            style: GoogleFonts.poppins(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Discard',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 120,
                      backgroundColor: Colors.grey[200],
                      child: user.profilePhoto != null
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.profilePhoto!,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )
                          : const Icon(Icons.person,
                              size: 100, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (isEditing) ...[
                    _buildEditableProfileGrid(user),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _cancelChanges,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: GoogleFonts.poppins(fontSize: 18),
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _saveChanges,
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
                            'Simpan',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildProfileGrid(user),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
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
                          'Ubah Profil',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) async {
          if (didPop) {
            return;
          }
          final bool shouldPop =
              isEditing ? (await _showBackDialog() ?? false) : true;
          if (context.mounted && shouldPop) {
            userProvider.selectMenu('Tentang Kami');
            Navigator.pop(context);
          }
        },
        child: Container(height: 0),
      ),
    );
  }

  Widget _buildProfileGrid(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileItem('Nama', user.fullName),
        _buildProfileItem(
          'Tanggal\nlahir',
          DateFormat('yyyy-MM-dd').format(user.dateOfBirth),
        ),
        _buildProfileItem('Jenis\nkelamin',
            user.gender == 'male' ? 'Laki-laki' : 'Perempuan'),
        _buildProfileItem('Nomor\ntelepon',
            user.phone == '' ? 'Belum ditentukan' : user.phone),
        _buildProfileItem('Email', user.email),
        _buildProfileItem('Kata\nsandi', 'password', isPassword: true),
      ],
    );
  }

  Widget _buildEditableProfileGrid(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEditableProfileItem('Nama', _nameController),
        _buildEditableDateOfBirthItem('Tanggal\nlahir', user),
        _buildEditableGenderItem('Jenis\nkelamin'),
        _buildEditableProfileItem('Nomor\ntelepon', _phoneController,
            isPhone: true),
        _buildEditablePasswordItem('Kata\nsandi'),
      ],
    );
  }

  Widget _buildProfileItem(String title, String value,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 80,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isPassword ? '*' * value.length : value,
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableProfileItem(
      String title, TextEditingController controller,
      {bool isPassword = false,
      bool isPasswordConfirm = false,
      bool confirm = false,
      bool isPhone = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 105,
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: TextField(
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                  controller: controller,
                  obscureText: confirm
                      ? (isPassword
                          ? _obscureNewPassword
                          : _obscureConfirmPassword)
                      : false,
                  keyboardType:
                      isPhone ? TextInputType.number : TextInputType.text,
                  inputFormatters: isPhone
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ]
                      : null,
                  decoration: InputDecoration(
                    hintText: confirm || isPhone
                        ? (isPhone
                            ? "Panjang digit 11-14"
                            : (isPassword
                                ? "Minimal 8 karakter"
                                : "Sama dengan Kata sandi baru"))
                        : 'Nama Lengkap',
                    suffixIcon: confirm
                        ? (isPassword
                            ? IconButton(
                                icon: Icon(
                                  _obscureNewPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureNewPassword = !_obscureNewPassword;
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ))
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableDateOfBirthItem(String title, User user) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 105,
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: InkWell(
                  onTap: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dateOfBirth ?? DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dateOfBirth = selectedDate;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _dateOfBirth != null
                          ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                          : DateFormat('yyyy-MM-dd').format(user.dateOfBirth),
                      style: GoogleFonts.poppins(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableGenderItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                width: 105,
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: DropdownButtonFormField<String>(
                  value: _gender,
                  items: [
                    DropdownMenuItem(
                        value: 'male',
                        child: Text(
                          'Laki-Laki',
                          style: GoogleFonts.poppins(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'female',
                        child: Text(
                          'Perempuan',
                          style: GoogleFonts.poppins(fontSize: 18),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditablePasswordItem(String title) {
    return Column(
      children: [
        _buildEditableProfileItem('Kata sandi baru', _passwordController,
            isPassword: true, confirm: true),
        _buildEditableProfileItem(
            'Konfirmasi kata sandi baru', _confirmPasswordController,
            isPasswordConfirm: true, confirm: true),
      ],
    );
  }
}

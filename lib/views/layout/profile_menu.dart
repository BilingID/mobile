import 'package:bilingid/controllers/auth_util.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/models/user.dart';
import 'package:bilingid/views/konseling/konseling_list_page.dart';
import 'package:bilingid/views/profile_page.dart';
import 'package:bilingid/views/psikotes/psikotes_list_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        elevation: 0,
        leading: IconButton(
          iconSize: 37.0,
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: GestureDetector(
          onTap: () {
            userProvider.selectMenu('Tentang Kami');
            Navigator.pushReplacementNamed(context, '/homepage');
          },
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'BiLing.ID',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      drawer: buildDrawer(context, user, userProvider),
      body: getDrawerItemWidget(userProvider.selectedMenu),
    );
  }

  Widget buildDrawer(
      BuildContext context, User? user, UserProvider userProvider) {
    final AuthUtil authUtil = AuthUtil();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Hai, ${user?.fullName ?? 'Guest'}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              user?.email ?? '',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: user?.profilePhoto != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: user!.profilePhoto!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : user != null
                      ? Text(
                          user.fullName[0],
                          style: GoogleFonts.poppins(fontSize: 40.0),
                        )
                      : const Icon(Icons.person, size: 50, color: Colors.grey),
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF007BFF),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Menu',
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person,
                color: userProvider.selectedMenu == 'Profile'
                    ? Colors.black
                    : null),
            title: Text(
              'Profil',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: userProvider.selectedMenu == 'Profile'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: userProvider.selectedMenu == 'Profile'
                    ? Colors.black
                    : null,
              ),
            ),
            selected: userProvider.selectedMenu == 'Profile',
            selectedTileColor: Colors.grey[400],
            onTap: () {
              authUtil.cekTokenToProfile(context, 'Profile', isMenu: true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment,
                color: userProvider.selectedMenu == 'PsikotesList'
                    ? Colors.black
                    : null),
            title: Text(
              'Psikotes',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: userProvider.selectedMenu == 'PsikotesList'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: userProvider.selectedMenu == 'PsikotesList'
                    ? Colors.black
                    : null,
              ),
            ),
            selected: userProvider.selectedMenu == 'PsikotesList',
            selectedTileColor: Colors.grey[400],
            onTap: () {
              authUtil.cekTokenToProfile(context, 'PsikotesList', isMenu: true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month,
                color: userProvider.selectedMenu == 'Jadwal'
                    ? Colors.black
                    : null),
            title: Text(
              'Jadwal',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: userProvider.selectedMenu == 'Jadwal'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color:
                    userProvider.selectedMenu == 'Jadwal' ? Colors.black : null,
              ),
            ),
            selected: userProvider.selectedMenu == 'Jadwal',
            selectedTileColor: Colors.grey[400],
            onTap: () {
              authUtil.cekTokenToProfile(context, 'Jadwal', isMenu: true);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.house,
                color: userProvider.selectedMenu == 'Tentang Kami'
                    ? Colors.black
                    : null),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: userProvider.selectedMenu == 'Tentang Kami'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: userProvider.selectedMenu == 'Tentang Kami'
                    ? Colors.black
                    : null,
              ),
            ),
            onTap: () {
              userProvider.selectMenu('Tentang Kami');
              Navigator.pushReplacementNamed(context, '/homepage');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onTap: () {
              _showLogoutDialog(context, userProvider);
            },
          ),
        ],
      ),
    );
  }

  Widget getDrawerItemWidget(String menu) {
    switch (menu) {
      case 'Profile':
        return const ProfilePage();
      case 'PsikotesList':
        return const PsikotesListPage();
      case 'Jadwal':
        return const KonselingListPage();
      default:
        return const SizedBox.shrink();
    }
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Yakin ingin logout?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Apakah Anda yakin ingin logout?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                userProvider.selectMenu('Tentang Kami');
                userProvider.logout();
                Navigator.pushReplacementNamed(context, '/loginpage');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil logout')),
                );
              },
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}

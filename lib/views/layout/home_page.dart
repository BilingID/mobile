import 'package:bilingid/controllers/auth_util.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/views/konseling/konseling_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/views/tentang_kami_page.dart';
import 'package:bilingid/views/psikotes/psikotes_page.dart';
import 'package:bilingid/views/faq_page.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthUtil _authUtil = AuthUtil();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF007BFF),
        elevation: 0,
        leading: IconButton(
          iconSize: 37.0,
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: GestureDetector(
          onTap: () {
            _authUtil.cekTokenToProfile(context, 'Tentang Kami', isMenu: true);
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
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            iconSize: 40.0,
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              _authUtil.cekTokenToProfile(context, 'Profile', route: '/profilemenu');
            },
          ),
        ],
      ),
      drawer: Drawer(
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
                        : const Icon(Icons.person,
                            size: 50, color: Colors.grey),
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
              selected: userProvider.selectedMenu == 'Tentang Kami',
              selectedTileColor: Colors.grey[400],
              onTap: () {
                userProvider.selectMenu('Tentang Kami');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer,
                  color:
                      userProvider.selectedMenu == 'FAQ' ? Colors.black : null),
              title: Text(
                'FAQ',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: userProvider.selectedMenu == 'FAQ'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color:
                      userProvider.selectedMenu == 'FAQ' ? Colors.black : null,
                ),
              ),
              selected: userProvider.selectedMenu == 'FAQ',
              selectedTileColor: Colors.grey[400],
              onTap: () {
                _authUtil.cekTokenToProfile(context, 'FAQ', isMenu: true);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Layanan',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.assignment_add,
                  color: userProvider.selectedMenu == 'Psikotes'
                      ? Colors.black
                      : null),
              title: Text(
                'Psikotes',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: userProvider.selectedMenu == 'Psikotes'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: userProvider.selectedMenu == 'Psikotes'
                      ? Colors.black
                      : null,
                ),
              ),
              selected: userProvider.selectedMenu == 'Psikotes',
              selectedTileColor: Colors.grey[400],
              onTap: () {
                _authUtil.cekTokenToProfile(context, 'Psikotes', isMenu: true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.group,
                  color: userProvider.selectedMenu == 'Konseling'
                      ? Colors.black
                      : null),
              title: Text(
                'Konseling',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: userProvider.selectedMenu == 'Konseling'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: userProvider.selectedMenu == 'Konseling'
                      ? Colors.black
                      : null,
                ),
              ),
              selected: userProvider.selectedMenu == 'Konseling',
              selectedTileColor: Colors.grey[400],
              onTap: () {
                _authUtil.cekTokenToProfile(context, 'Konseling', isMenu: true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: getDrawerItemWidget(userProvider.selectedMenu),
    );
  }

  Widget getDrawerItemWidget(String menu) {
    switch (menu) {
      case 'Tentang Kami':
        return const TentangKami();
      case 'Psikotes':
        return const Psikotes();
      case 'Konseling':
        return const Konseling();
      case 'FAQ':
        return const FAQ();
      default:
        return const SizedBox.shrink();
    }
  }
}

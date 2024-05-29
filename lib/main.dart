import 'package:bilingid/controllers/konseling_provider.dart';
import 'package:bilingid/views/layout/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/views/layout/home_page.dart';
import 'package:bilingid/views/profile_page.dart';
import 'package:bilingid/views/login_page.dart';
import 'package:bilingid/views/register_page.dart';
import 'package:bilingid/controllers/psikotes_provider.dart';
import 'package:bilingid/controllers/question_provider.dart';
import 'package:bilingid/controllers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PsikotesProvider()),
        ChangeNotifierProvider(create: (_) => KonselingProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                QuestionProvider(context.read<PsikotesProvider>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BiLing.ID',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/loginpage',
      routes: {
        '/homepage': (context) => const HomePage(),
        '/profilepage': (context) => const ProfilePage(),
        '/profilemenu': (context) => const ProfileMenu(),
        '/loginpage': (context) => const LoginPage(),
        '/registerpage': (context) => const RegisterPage(),
      },
    );
  }
}

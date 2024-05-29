import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/api_service.dart';
import 'package:bilingid/controllers/user_provider.dart';
import 'package:bilingid/views/psikotes/psikotes_question_page.dart';
import 'package:bilingid/views/psikotes/psikotes_result_page.dart';

class AuthUtil {
  final ApiService _apiService = ApiService();

  Future<void> cekTokenToProfile(BuildContext context, String menu,
      {String? route, String? code, bool isMenu = false}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final token = await _apiService.getToken();

    if (token == null) {
      _handleSessionExpired(navigator, scaffoldMessenger);
      return;
    }

    final response = await _apiService.cekToken();

    if (response == 'Unauthenticated.' || userProvider.user == null) {
      userProvider.logout();
      _handleSessionExpired(navigator, scaffoldMessenger);
    } else {
      userProvider.selectMenu(menu);

      if (!isMenu) {
        _navigateToRoute(navigator, route, code);
      }
    }
  }

  void _handleSessionExpired(
      NavigatorState navigator, ScaffoldMessengerState scaffoldMessenger) {
    navigator.pushNamed('/loginpage');
    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text('Session expired. Please login again!')),
    );
  }

  void _navigateToRoute(NavigatorState navigator, String? route, String? code) {
    switch (route) {
      case '/psikotesquestion':
        navigator.push(
          MaterialPageRoute(
            builder: (context) => LoadingQuestionPage(code: code!),
          ),
        );
        break;
      case '/psikotesresult':
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => ResultPage(code: code!)),
        );
        break;
      default:
        navigator.pushNamed(route!);
        break;
    }
  }
}

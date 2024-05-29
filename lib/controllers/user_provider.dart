import 'package:bilingid/api_service.dart';
import 'package:flutter/material.dart';
import 'package:bilingid/models/user.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<User> _psychologs = [];
  List<User> get psychologs => _psychologs;

  User? _user;
  User? get user => _user;
  String _selectedMenu = 'Tentang Kami';
  String get selectedMenu => _selectedMenu;

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void selectMenu(String menu) {
    _selectedMenu = menu;
    notifyListeners();
  }

  void logout() {
    _apiService.logout();
    _user = null;
    notifyListeners();
  }

  Future<List<User>> fetchPsychologs() async {
    try {
      final psychologsData = await _apiService.getPsychologs();
      return User.parseList(psychologsData);
    } catch (e) {
      throw Exception('Error fetching Psychologs: $e');
    }
  }

  Future<void> initializePsychologs() async {
    _psychologs = await fetchPsychologs();
    notifyListeners();
  }

  User? getPsycholog(int id) {
    return psychologs.firstWhere((psycholog) => psycholog.id == id);
  }
}

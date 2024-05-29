import 'package:flutter/material.dart';
import 'package:bilingid/api_service.dart';

class KonselingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<String> createKonselingSession(int psychologistId, String meetDate, String meetTime) async {
    try {
      final int id = await _apiService.createKonselingSession(
          psychologistId, meetDate, meetTime);
      final String status = await _apiService.processPaymentKonseling(id);
      notifyListeners();
      return status;
    } catch (e) {
      throw Exception('Error creating konseling session: $e');
    }
  }

  Future<String> finishKonseling(int id) async {
    try {
      final status = await _apiService.finishKonselingSession(id);
      notifyListeners();
      return status;
    } catch (e) {
      throw Exception('Error finishing konseling session: $e');
    }
  }
}

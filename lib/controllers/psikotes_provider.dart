import 'package:bilingid/models/psikotes.dart';
import 'package:bilingid/models/question.dart';
import 'package:flutter/material.dart';
import 'package:bilingid/api_service.dart';

class PsikotesProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  late Psikotes tempPsikotes;

  Future<String> createPsychotest() async {
    try {
      final String code = await _apiService.createPsychotest();
      final String status = await _apiService.processPayment(code);
      if (status != "success") {
        throw Exception("Error at payment");
      }
      notifyListeners();
      return code;
    } catch (e) {
      throw Exception('Error creating psychotest: $e');
    }
  }

  Future<List<Question>> fetchQuestions(String code) async {
    try {
      final questionsData = await _apiService.getQuestions(code);
      return Question.parseList(questionsData);
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  Future<void> submitAnswers(Map<String, dynamic> answers, String code) async {
    try {
      final status = await _apiService.submitAnswers(code, answers);
      if (status != "success") {
        throw Exception("Error at submitting");
      }
      notifyListeners();
    } catch (e) {
      throw Exception('Error submitting answers: $e');
    }
  }

  Future<Map<String, dynamic>> fetchResults(String code) async {
    try {
      return await _apiService.getResults(code);
    } catch (e) {
      throw Exception('Error fetching results: $e');
    }
  }
}

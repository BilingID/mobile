import 'package:bilingid/controllers/psikotes_provider.dart';
import 'package:bilingid/models/answer.dart';
import 'package:bilingid/models/question.dart';
import 'package:flutter/material.dart';

class QuestionProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  final PsikotesProvider _psikotesProvider;
  Map<int, String> _selectedAnswers = {};
  Answer _answer = Answer(E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0);

  QuestionProvider(this._psikotesProvider);
  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, String> get selectedAnswers => _selectedAnswers;
  Answer get answer => _answer;

  Future<void> initializeQuestions(String code) async {
    _questions = await _psikotesProvider.fetchQuestions(code);
    _currentQuestionIndex = 0;
    _selectedAnswers = {};
    _answer = Answer(E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0);
    notifyListeners();
  }

  void resetQuestions() {
    _questions = questions;
    _currentQuestionIndex = 0;
    _selectedAnswers = {};
    _answer = Answer(E: 0, I: 0, S: 0, N: 0, T: 0, F: 0, J: 0, P: 0);
    notifyListeners();
  }

  void selectAnswer(String choiceType) {
    _selectedAnswers[_currentQuestionIndex] = choiceType;
    _updateAnswer(choiceType);
    notifyListeners();
  }

  void _updateAnswer(String choiceType) {
    switch (choiceType) {
      case 'E':
        _answer = _answer.copyWith(E: _answer.E + 1);
        break;
      case 'I':
        _answer = _answer.copyWith(I: _answer.I + 1);
        break;
      case 'S':
        _answer = _answer.copyWith(S: _answer.S + 1);
        break;
      case 'N':
        _answer = _answer.copyWith(N: _answer.N + 1);
        break;
      case 'T':
        _answer = _answer.copyWith(T: _answer.T + 1);
        break;
      case 'F':
        _answer = _answer.copyWith(F: _answer.F + 1);
        break;
      case 'J':
        _answer = _answer.copyWith(J: _answer.J + 1);
        break;
      case 'P':
        _answer = _answer.copyWith(P: _answer.P + 1);
        break;
      default:
        break;
    }
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  Question getCurrentQuestion() {
    return _questions[_currentQuestionIndex];
  }

  bool isLastQuestion() {
    return _currentQuestionIndex == _questions.length - 1;
  }

  Answer getAnswers() {
    return _answer;
  }
}

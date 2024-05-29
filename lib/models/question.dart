class Question {
  final String questionText;
  final String choiceA;
  final String choiceB;
  final String typeA;
  final String typeB;

  Question({
    required this.questionText,
    required this.choiceA,
    required this.choiceB,
    required this.typeA,
    required this.typeB,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['question_text'] ?? '',
      choiceA: json['choice_a'] ?? '',
      choiceB: json['choice_b'] ?? '',
      typeA: json['type_a'] ?? '',
      typeB: json['type_b'] ?? '',
    );
  }

  static List<Question> parseList(List<dynamic> list) {
    return list.map((item) => Question.fromJson(item)).toList();
  }
}

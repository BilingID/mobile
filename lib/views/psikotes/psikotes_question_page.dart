import 'package:bilingid/controllers/auth_util.dart';
import 'package:bilingid/controllers/psikotes_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bilingid/controllers/question_provider.dart';
import 'package:bilingid/models/answer.dart';

class LoadingQuestionPage extends StatefulWidget {
  const LoadingQuestionPage({super.key, required this.code});

  final String code;

  @override
  LoadingQuestionPageState createState() => LoadingQuestionPageState();
}

class LoadingQuestionPageState extends State<LoadingQuestionPage> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    _initialization = _initializeQuestions(questionProvider);
  }

  Future<void> _initializeQuestions(QuestionProvider questionProvider) async {
    await questionProvider.initializeQuestions(widget.code);
    questionProvider.resetQuestions();
  }

  Future<void> _submitAnswers(BuildContext context) async {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    final psikotesProvider =
        Provider.of<PsikotesProvider>(context, listen: false);
    final Answer answers = questionProvider.getAnswers();
    await psikotesProvider.submitAnswers(answers.toJson(), widget.code);
    final AuthUtil authUtil = AuthUtil();
    if (context.mounted) {
      authUtil.cekTokenToProfile(context, 'PsikotesList',
          route: '/psikotesresult', code: widget.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else {
          return QuestionPage(
              submitAnswersCallback: () => _submitAnswers(context));
        }
      },
    );
  }
}

class QuestionPage extends StatelessWidget {
  final Future<void> Function() submitAnswersCallback;

  const QuestionPage({super.key, required this.submitAnswersCallback});

  @override
  Widget build(BuildContext context) {
    final questionProvider = Provider.of<QuestionProvider>(context);
    final currentQuestion = questionProvider.getCurrentQuestion();
    final selectedAnswer =
        questionProvider.selectedAnswers[questionProvider.currentQuestionIndex];

    final progressPercentage = (questionProvider.currentQuestionIndex + 1) /
        questionProvider.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pertanyaan ke ${questionProvider.currentQuestionIndex + 1}/${questionProvider.questions.length}',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF007BFF),
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progressPercentage,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA500)),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentQuestion.questionText,
              style: GoogleFonts.questrial(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 20),
            buildAnswerOption(currentQuestion.typeA, currentQuestion.choiceA,
                selectedAnswer, questionProvider),
            const SizedBox(height: 10),
            buildAnswerOption(currentQuestion.typeB, currentQuestion.choiceB,
                selectedAnswer, questionProvider),
            const SizedBox(height: 20),
            Row(
              children: [
                if (questionProvider.currentQuestionIndex > 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        questionProvider.previousQuestion();
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
                        'Previous',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                if (questionProvider.currentQuestionIndex > 0)
                  const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedAnswer != null) {
                        if (questionProvider.isLastQuestion()) {
                          submitAnswersCallback();
                        } else {
                          questionProvider.nextQuestion();
                        }
                      }
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
                      questionProvider.isLastQuestion() ? 'Submit' : 'Next',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildAnswerOption(
    String type,
    String choice,
    String? selectedAnswer,
    QuestionProvider questionProvider,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          questionProvider.selectAnswer(type);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedAnswer == type
                ? Colors.lightBlueAccent.withOpacity(0.3)
                : Colors.white,
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Radio<String>(
                value: type,
                groupValue: selectedAnswer,
                activeColor: const Color(0xFF007BFF),
                onChanged: (value) {
                  questionProvider.selectAnswer(value!);
                },
              ),
              Expanded(
                child: Text(
                  choice,
                  style:
                      GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

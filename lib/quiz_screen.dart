import 'package:flutter/material.dart';
import 'package:nagp_quiz/common/theme_helper.dart';
import 'package:nagp_quiz/models/option.dart';
import 'package:nagp_quiz/models/quiz.dart';
import 'package:nagp_quiz/stores/quiz_store.dart';
import 'home_screen.dart';
import 'models/quiz_history.dart';

class QuizScreen extends StatefulWidget {
  late Quiz quiz;

  QuizScreen(this.quiz, {Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState(quiz);
}

class _QuizScreenState extends State<QuizScreen> {
  late Quiz quiz;

  _QuizScreenState(this.quiz);

  late Quiz quizList = Quiz(0, 'default', 'default', true, 'default', 0,
      []); //assign as default data because late give error
  @override
  void initState() {
    var quizStore = QuizStore();

    quizStore.getQuizByIdAsync(quiz.id, quiz.categoryId).then((value) {
      setState(() {
        quizList = value;
      });
    });
    super.initState();
  }

  //define the datas
  int currentQuestionIndex = 0;
  int totalCorrect = 0;
  int totalWrong = 0;
  Option? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: ThemeHelper.fullScreenBgBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                screenHeader(),
                _questionWidget(),
                _answerList(),
                _nextButton(),
                _finishButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget screenHeader() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        quiz.title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${quizList.questions.length.toString()}",
          style: const TextStyle(
            color: Color.fromARGB(255, 108, 109, 95),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 223, 109),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            quizList.questions[currentQuestionIndex].text,
            style: const TextStyle(
              color: Color.fromARGB(255, 35, 27, 27),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: quizList.questions[currentQuestionIndex].options
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Option answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor:
              isSelected ? Color.fromARGB(255, 232, 250, 166) : Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (selectedAnswer == null) {
            if (answer.isCorrect) {
              totalCorrect++;
            } else {
              totalWrong++;
            }
            setState(() {
              selectedAnswer = answer;
            });
          }
        },
        child: Text(answer.text),
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == quizList.questions.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 183, 91, 236),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (isLastQuestion) {
            //display score

            showDialog(context: context, builder: (_) => _showScoreDialog());
          } else {
            //next question
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
        child: Text(isLastQuestion ? "Submit" : "Next"),
      ),
    );
  }

  _finishButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 193, 68, 255),
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          //display score
          showDialog(context: context, builder: (_) => _showScoreDialog());
        },
        child: const Text("finish"),
      ),
    );
  }

  _showScoreDialog() {
    bool isPassed = false;
    double score = totalCorrect - totalWrong * 0.25;

    var quizStore = QuizStore();
    quizStore.getCategoryAsync(quiz.categoryId).then((category) {
      quizStore
          .saveQuizHistory(QuizHistory(quiz.id, quiz.title, category.id,
              "$score", DateTime.now(), "Complete"))
          .then((value) {});
    });

    if (totalCorrect >= quizList.questions.length * 0.6) {
      //pass if 60 %
      isPassed = true;
    }
    String title = isPassed ? "Passed " : "Failed";

    return AlertDialog(
      title: Text(
        "$title | Score is $score",
        style: TextStyle(color: isPassed ? Colors.green : Colors.redAccent),
      ),
      content: ElevatedButton(
        child: const Text("Exit"),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        },
      ),
    );
  }
}

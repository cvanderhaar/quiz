import 'package:flutter/material.dart';
import 'package:quizzler/results.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';
import 'package:percent_indicator/percent_indicator.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  double progress = 0;

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (quizBrain.isFinished() == true) {
        Alert(
          context: context,
          title: 'Finished!',
          desc: 'You\'ve reached the end of the quiz.',
          buttons: [
            DialogButton(
              child: Text(
                "CHECK RESULTS",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Results()),
              ),
              width: 250,
            )
          ],
        ).show();

        quizBrain.reset();

        scoreKeeper = [];
      }

      else {
        if (userPickedAnswer == correctAnswer) {
          scoreKeeper.add(
            Icon(
              Icons.check,
              color: Colors.green,
            ),
          );
        } else {
          scoreKeeper.add(
            Icon(
              Icons.close,
              color: Colors.red,
            ),
          );
        }
        quizBrain.nextQuestion();
      }
    });
  }

  currentProgressColor() {
    if (progress >= 0.6 && progress < 0.8) {
      return Colors.orange;
    }
    if (progress >= 0.8) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 15.0),
            Container(
              padding: EdgeInsets.only(top: 50.0),
              child: CircularPercentIndicator(
                radius: 150.0,
                lineWidth: 12.0,
                percent: progress,
                circularStrokeCap: CircularStrokeCap.butt,
                center: Text(
                  "${this.progress * 100}%",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: currentProgressColor(),
              ),
            ),
          ],
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.black,
              color: Colors.green,
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                final updated = ((this.progress + 0.1).clamp(0.0, 1.0) * 100);
                setState(() {
                  this.progress = updated.round() / 100;
                  checkAnswer(true);
                });
                print(progress);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'No',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                final updated = ((this.progress + 0.1).clamp(0.0, 1.0) * 100);
                setState(() {
                  this.progress = updated.round() / 100;
                  checkAnswer(false);
                });
                print(progress);
              },
            ),
          ),
        ),
//        Row(
//          children: scoreKeeper,
//        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
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
  List<Expanded> scoreKeeper = [];

  void end() {
    setState(() {
      Alert(
        context: context,
        type: AlertType.success,
        title: "Finished!",
        desc: "You have reached the end of quiz.",
        buttons: [
          DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    });
  }

  void checkAnswer(bool userPickedAnswer) {
    bool answer = qBrain.getAnswer();
    setState(() {
      if (userPickedAnswer == answer)
        scoreKeeper.add(Expanded(
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ));
      else
        scoreKeeper.add(Expanded(
          child: Icon(
            Icons.close,
            color: Colors.red,
          ),
        ));

      qBrain.nextQuestion();
      qBrain.sk++;
      print(qBrain.sk);
    });
  }

  QuizBrain qBrain = QuizBrain();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                qBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                if (qBrain.isFinished()) {
                  end();
                  qBrain.reset();
                  scoreKeeper.removeRange(0, scoreKeeper.length - 1);
                } else {
                  checkAnswer(true);
                }
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
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                qBrain.sk++;
                if (qBrain.isFinished()) {
                  end();
                  qBrain.reset();
                  scoreKeeper.removeRange(0, scoreKeeper.length - 1);
                } else {
                  checkAnswer(false);
                }
                print(qBrain.sk);
              },
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: scoreKeeper,
          ),
        )
      ],
    );
  }
}

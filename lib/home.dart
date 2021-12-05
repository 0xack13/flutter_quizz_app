// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app/answer.dart';
import 'dart:math';

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  print(items);

  return items;
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields, unused_field
  List<Icon> _scoreTracker = [];
  // ignore: prefer_final_fields
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;
  // _questions = (_questions);

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  void _questionAnswered(bool answerScore) {
    setState(() {
      answerWasSelected = true;
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
    });
    _scoreTracker.add(
      answerScore
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.error, color: Colors.red),
    );
    print(_questionIndex.toString() + " -- " + _questions.length.toString());
    if (_questionIndex + 1 == _questions.length) {
      endOfQuiz = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Example',
          style: TextStyle(color: Colors.amber),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: 25.0,
                ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 130.0,
              margin: EdgeInsets.only(bottom: 10.0, left: 30.0, right: 30.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30.0),
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Center(
                child: Text(_questions[_questionIndex]['question'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map((answer) => Answer(
                    answerText: answer['answerText'],
                    answerColor: answerWasSelected
                        ? answer['score']
                            ? Colors.green
                            : Colors.red
                        : null,
                    answerTap: () {
                      if (answerWasSelected) {
                        return;
                      }
                      _questionAnswered(answer['score']);
                    })),
            // Answer(),
            // Answer(),
            // Answer(),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Please select an answer before going to the next one")));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40.0)),
            ),
            Container(
                padding: EdgeInsets.all(20.0),
                child: Text('${_totalScore.toString()}/${_questions.length}',
                    style: TextStyle(
                        fontSize: 40.0, fontWeight: FontWeight.bold))),
            if (answerWasSelected && !endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    correctAnswerSelected ? "Well done!" : "Wrong :(",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (endOfQuiz)
              Container(
                height: 100,
                width: double.infinity,
                color: Colors.black,
                child: Center(
                  child: Text(
                    _totalScore > 4
                        ? "Congratulations! your score is $_totalScore"
                        : "your final score is $_totalScore. Better luck time!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

var _questions = shuffle([
  {
    'question': 'What do we commemorate on Anzac Day??',
    'answers': [
      {
        'answerText':
            'The landing of the Australian and New Zealand Army Corps at Gallipoli, Turkey during World War I',
        'score': true
      },
      {
        'answerText':
            'The arrival of the first free settlers from Great Britain.',
        'score': false
      },
      {
        'answerText': 'The landing of the First Fleet at Sydney Cove.',
        'score': false
      },
    ],
  },
  {
    'question': 'What are the colours of the Australian Aboriginal Flag??',
    'answers': [
      {'answerText': 'The national anthem', 'score': false},
      {'answerText': 'Australia’s national flower', 'score': false},
      {
        'answerText':
            'The official symbol of Australia, which identifies Commonwealth property',
        'score': true
      },
    ],
  },
  {
    'question': 'What is the Commonwealth Coat of Arms?',
    'answers': [
      {'answerText': 'Britney Spears', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael Jackson', 'score': true},
    ],
  },
  {
    'question': 'What happened in Australia on 1 January 1901?',
    'answers': [
      {
        'answerText':
            ' The Australian Constitution was changed by a referendum',
        'score': false
      },
      {
        'answerText':
            'The separate colonies were united into a federation of states called the Commonwealth of Australia',
        'score': true
      },
      {
        'answerText': 'The Australian and New Zealand Army Corps was formed',
        'score': false
      },
    ],
  },
  {
    'question': 'What is the capital city of Australia?',
    'answers': [
      {'answerText': 'Brisbane', 'score': true},
      {'answerText': 'Canberra', 'score': false},
      {'answerText': 'Perth', 'score': false},
    ],
  },
  {
    'question': 'Which of these is an example of freedom of speech?',
    'answers': [
      {
        'answerText':
            'People can peacefully protest against a government action',
        'score': true
      },
      {
        'answerText': 'Men and women are treated equally in a court of law',
        'score': false
      },
      {
        'answerText': 'Australians are free to not follow a religion',
        'score': false
      },
    ],
  },
  {
    'question':
        'Which of these statements about government in Australia is correct?',
    'answers': [
      {
        'answerText': 'The government does not allow some religions',
        'score': true
      },
      {'answerText': 'The government in Australia is secular', 'score': false},
      {'answerText': 'Religious laws are passed by Parliament', 'score': false},
    ],
  },
  {
    'question': 'Which of these is an example of equality in Australia?',
    'answers': [
      {'answerText': 'Everyone follows the same religion', 'score': false},
      {'answerText': 'Men and women have equal rights', 'score': false},
      {
        'answerText': 'Everyone belongs to the same political party',
        'score': true
      },
    ],
  },
  {
    'question':
        'Which of these is a responsibility of Australian citizens aged 18 years or over?',
    'answers': [
      {'answerText': 'To attend local council meetings', 'score': false},
      {
        'answerText':
            'To vote in federal and state or territory elections, and in a referendum',
        'score': true
      },
      {'answerText': 'To have a current Australian passport', 'score': false},
    ],
  },
  {
    'question':
        'Which of these is a responsibility of Australian citizens aged 18 years or over?',
    'answers': [
      {'answerText': 'To attend local council meetings', 'score': false},
      {
        'answerText':
            'To vote in federal and state or territory elections, and in a referendum',
        'score': true
      },
      {'answerText': 'To have a current Australian passport', 'score': false},
    ],
  },
  {
    'question':
        'Which of the following is an example of contributing to the Australian community?',
    'answers': [
      {
        'answerText':
            'Volunteering or fundraising for a charity is a great opportunity to strengthen our community',
        'score': false
      },
      {
        'answerText':
            'I should not make any effort to get to know other people',
        'score': true
      },
      {
        'answerText':
            'People in Australia should not contribute to the community because Australia is a free country',
        'score': false
      },
    ],
  },
  {
    'question':
        'Should people tolerate one another where they find that they disagree?',
    'answers': [
      {
        'answerText': 'It is against the law to disagree with one another',
        'score': false
      },
      {
        'answerText':
            'No, people only need to treat each other with respect if they agree with one another',
        'score': true
      },
      {
        'answerText':
            'Yes, peaceful disagreement reflects Australian values in relation to mutual respect',
        'score': false
      },
    ],
  },
  {
    'question': 'Should people in Australia make an effort to learn English?',
    'answers': [
      {
        'answerText':
            'People in Australia should speak whichever language is most commonly spoken in their local neighbourhood',
        'score': false
      },
      {
        'answerText':
            'There is no expectation to learn any particular language in Australia',
        'score': true
      },
      {
        'answerText':
            'Yes, English is the national language of Australia and it helps to get an education, a job, and to integrate into the community',
        'score': false
      },
    ],
  },
  {
    'question':
        'Which of these statements best demonstrates Australian values about freedom of expression?',
    'answers': [
      {
        'answerText':
            'Everyone can peacefully express their opinions within the law',
        'score': false
      },
      {
        'answerText': 'People with different views from me need to keep quiet',
        'score': true
      },
      {'answerText': 'Only approved topics can be discussed', 'score': false},
    ],
  },
  {
    'question': 'Which of these is a role of the Governor-General?',
    'answers': [
      {'answerText': 'The appointment of state premiers', 'score': false},
      {
        'answerText':
            'Signing all Bills passed by the Australian Parliament into law',
        'score': false
      },
      {'answerText': 'The appointment of the Head of State', 'score': true},
    ],
  },
  {
    'question':
        'Which arm of government has the power to interpret and apply laws?',
    'answers': [
      {'answerText': 'Legislative', 'score': false},
      {'answerText': 'Judicial', 'score': true},
      {'answerText': 'Executive', 'score': false},
    ],
  },
]);

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = []; // List of questions from Firebase
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  // Fetch quiz data from Firebase
  Future<void> _loadQuizData() async {
    const url =
        'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/brainboost.json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData != null && decodedData is Map<String, dynamic>) {
          // Remove 'date' from the JSON data
          decodedData.remove('date');

          final firstEntry = decodedData.values.first;

          if (firstEntry != null && firstEntry is Map<String, dynamic>) {
            final questionsData = firstEntry['questions'];

            if (questionsData != null && questionsData is List<dynamic>) {
              List<Question> loadedQuestions = [];
              int questionNumber = 1;

              for (var question in questionsData) {
                if (question != null && question is Map<dynamic, dynamic>) {
                  loadedQuestions
                      .add(Question.fromMap(question, questionNumber));
                  questionNumber++;
                }
              }

              setState(() {
                questions = loadedQuestions;
                isLoading = false;
              });
              return; // Stop here if data is successfully loaded
            }
          }
        }
      }

      throw Exception('Invalid or empty data.');
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
        questions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C6E8F),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Quiz', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
              ? const Center(child: Text('No data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return QuestionWidget(
                        question: questions[index],
                      );
                    },
                  ),
                ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;

  const QuestionWidget({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  Option? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.question.questionNumber}. ${widget.question.text}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: widget.question.options.map((option) {
            bool isSelected = selectedOption == option;
            bool isCorrect = option.isCorrect;

            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isCorrect ? Colors.green : Colors.red)
                    : Colors.blueGrey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  option.text,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: selectedOption ==
                        null // Only allow selection if no option is selected
                    ? () {
                        setState(() {
                          selectedOption = option;
                        });
                      }
                    : null, // Disable interaction after an option is selected
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Show answer only after selecting an option
        if (selectedOption != null)
          Text(
            'Jawaban Anda: ${selectedOption!.isCorrect ? "Benar" : "Salah"} '
            '(Jawaban benar: ${widget.question.options.firstWhere((o) => o.isCorrect).text})',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}


class Question {
  final int questionNumber;
  final String text;
  final List<Option> options;

  Question({
    required this.questionNumber,
    required this.text,
    required this.options,
  });

  factory Question.fromMap(Map<dynamic, dynamic> map, int questionNumber) {
    final correctIndex = map['correctOption'] as int;
    final optionsMap = map['options'] as List<dynamic>;

    return Question(
      questionNumber: questionNumber,
      text: map['question'] as String,
      options: optionsMap.asMap().entries.map((entry) {
        return Option(
          text: entry.value as String,
          isCorrect: entry.key == correctIndex,
        );
      }).toList(),
    );
  }
}

class Option {
  final String text;
  final bool isCorrect;

  Option({
    required this.text,
    required this.isCorrect,
  });
}








// import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: QuizScreen(),
// //     );
// //   }
// // }

// class QuizScreen extends StatelessWidget {
//   const QuizScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2C6E8F),
//         leading: const Icon(Icons.arrow_back, color: Colors.white),
//         title: const Text(
//           'Judul',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const QuestionWidget(
//               questionNumber: 1,
//               questionText: "Soal",
//               options: [
//                 Option(text: "Option A", isCorrect: false, isSelected: true),
//                 Option(text: "Option B", isCorrect: true, isSelected: false),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const QuestionWidget(
//               questionNumber: 2,
//               questionText: "Soal",
//               options: [
//                 Option(text: "Option A", isCorrect: true, isSelected: false),
//                 Option(text: "Option B", isCorrect: false, isSelected: true),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class QuestionWidget extends StatelessWidget {
//   final int questionNumber;
//   final String questionText;
//   final List<Option> options;

//   const QuestionWidget({
//     Key? key,
//     required this.questionNumber,
//     required this.questionText,
//     required this.options,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '$questionNumber. $questionText',
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Column(
//           children: options.map((option) {
//             return Container(
//               margin: const EdgeInsets.only(bottom: 8.0),
//               decoration: BoxDecoration(
//                 color: option.isSelected
//                     ? option.isCorrect
//                         ? Color(0xFF9AE19D)
//                         : Colors.red
//                     : Color(0xFF9AE19D),
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: ListTile(
//                 title: Text(
//                   option.text,
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Jawaban: ${options.any((o) => o.isSelected && !o.isCorrect) ? "Salah" : "Benar"} (Jawaban benar: ${options.firstWhere((o) => o.isCorrect).text})',
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class Option {
//   final String text;
//   final bool isCorrect;
//   final bool isSelected;

//   const Option({
//     required this.text,
//     required this.isCorrect,
//     required this.isSelected,
//   });
// }

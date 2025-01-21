import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'brainboost.dart';

class AddBrainBoostScreen extends StatefulWidget {
  @override
  _AddBrainBoostScreenState createState() => _AddBrainBoostScreenState();
}

class _AddBrainBoostScreenState extends State<AddBrainBoostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  List<Map<String, dynamic>> questions = [
    {
      'questionController': TextEditingController(),
      'selectedAnswerType': [true, false],
      'options': [TextEditingController(text: 'A. ')],
      'correctOption': null,
    },
  ];

  Future<void> submitData() async {
    // Validasi jika semua data sudah terisi
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        questions.any((q) => q['questionController'].text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lengkapi datanya')),
      );
      return; // Tidak melanjutkan jika ada data yang kosong
    }

    try {
      Map<String, dynamic> payload = {
        'title': titleController.text,
        'date': dateController.text,
        'questions': questions.map((q) {
          return {
            'question': q['questionController'].text,
            'type': q['selectedAnswerType'][0] ? 'Essay' : 'Option',
            'options': q['selectedAnswerType'][1]
                ? q['options']
                    .map<String>(
                        (optionController) => optionController.text.toString())
                    .toList()
                : [],
            'correctOption': q['correctOption'],
          };
        }).toList(),
      };

      String apiUrl =
          "https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/brainboost.json";

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data submitted successfully!')),
        );

        // Setelah submitData selesai (jika berhasil), navigasi ke BrainboostScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BrainboostScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit data: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2F6376),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Brain Boost',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Judul',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6376),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF9AE19D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'dd/mm/yyyy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F6376),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF9AE19D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 16),
              ...questions.map((question) {
                int index = questions.indexOf(question);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F6376),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: question['questionController'],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF9AE19D),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ToggleButtons(
                      isSelected: question['selectedAnswerType'],
                      onPressed: (int selectedIndex) {
                        setState(() {
                          for (int i = 0;
                              i < question['selectedAnswerType'].length;
                              i++) {
                            question['selectedAnswerType'][i] =
                                i == selectedIndex;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      selectedColor: Colors.white,
                      fillColor: Color(0xFF9AE19D),
                      color: Color(0xFF2F6376),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Essay', style: TextStyle(fontSize: 16)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('Option', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (question['selectedAnswerType'][1])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...question['options'].asMap().entries.map((entry) {
                            int optionIndex = entry.key;
                            TextEditingController optionController =
                                entry.value;

                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextField(
                                      controller: optionController,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Option ${String.fromCharCode(65 + optionIndex)}',
                                        filled: true,
                                        fillColor: Color(0xFF9AE19D),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Checkbox(
                                  value:
                                      question['correctOption'] == optionIndex,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      question['correctOption'] =
                                          value == true ? optionIndex : null;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      question['options'].removeAt(optionIndex);
                                      if (question['correctOption'] ==
                                          optionIndex) {
                                        question['correctOption'] = null;
                                      }
                                    });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                          IconButton(
                            icon: Icon(Icons.add_circle,
                                color: Color(0xFF2F6376), size: 36),
                            onPressed: () {
                              setState(() {
                                int newIndex = question['options'].length;
                                question['options'].add(TextEditingController(
                                  text: String.fromCharCode(65 + newIndex),
                                ));
                              });
                            },
                          ),
                        ],
                      ),
                  ],
                );
              }).toList(),
              Center(
                child: IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Color(0xFF2F6376), size: 36),
                  onPressed: () {
                    setState(() {
                      questions.add({
                        'questionController': TextEditingController(),
                        'selectedAnswerType': [true, false],
                        'options': [],
                        'correctOption': null,
                      });
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Panggil submitData terlebih dahulu
                    await submitData();

                    // Setelah submitData selesai (jika berhasil), navigasi ke BrainboostScreen
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2F6376),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

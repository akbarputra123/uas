import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditBrainBoostScreen extends StatefulWidget {
  final Map<dynamic, dynamic> brainboost; // Data brainboost yang akan diedit

  const EditBrainBoostScreen({Key? key, required this.brainboost})
      : super(key: key);

  @override
  _EditBrainBoostScreenState createState() => _EditBrainBoostScreenState();
}

class _EditBrainBoostScreenState extends State<EditBrainBoostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController brainboostController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi form dengan data brainboost yang sudah ada
    titleController.text = widget.brainboost['title'];
    brainboostController.text = widget.brainboost['content'];
    dateController.text = widget.brainboost['date'];
  }

  Future<void> updateBrainBoost(String brainboostKey) async {
    // URL untuk update data brainboost di Firebase
    final String url =
        'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/brainboost/$brainboostKey.json';

    // Data brainboost yang diperbarui
    Map<String, String> updatedData = {
      'title': titleController.text,
      'brainboost': brainboostController.text,
      'date': dateController.text,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Kembali ke halaman utama setelah update sukses
        Navigator.pop(context, true); // Mengembalikan nilai true
      } else {
        throw Exception('Failed to update brainboost');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A3E4B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali tanpa perubahan
          },
        ),
        title: Text('Edit BrainBoost'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title'),
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
            Text('BrainBoost'),
            TextField(
              controller: brainboostController,
              maxLines: 3,
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
            Text('Date'),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF9AE19D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                updateBrainBoost(widget.brainboost['key']);
              },
              child: Text('Update BrainBoost'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1A3E4B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

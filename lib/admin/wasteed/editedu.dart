import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditWasteedScreen extends StatefulWidget {
  final Map<dynamic, dynamic> wasteed; // Data wasteed yang akan diedit

  const EditWasteedScreen({Key? key, required this.wasteed}) : super(key: key);

  @override
  _EditWasteedScreenState createState() => _EditWasteedScreenState();
}

class _EditWasteedScreenState extends State<EditWasteedScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController wasteedController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi form dengan data wasteed yang sudah ada
    titleController.text = widget.wasteed['title'];
    wasteedController.text = widget.wasteed['content'];
    dateController.text = widget.wasteed['date'];
  }

  Future<void> updateWasteed(String wasteedKey) async {
    // URL untuk update data wasteed di Firebase
    final String url =
        'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/wasteed/$wasteedKey.json';

    // Data wasteed yang diperbarui
    Map<String, String> updatedData = {
      'title': titleController.text,
      'wasteed': wasteedController.text,
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
        throw Exception('Failed to update wasteed');
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
        title: Text('Edit Wasteed'),
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
            Text('Wasteed'),
            TextField(
              controller: wasteedController,
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
                updateWasteed(widget.wasteed['key']);
              },
              child: Text('Update Wasteed'),
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

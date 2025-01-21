import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditNewsScreen extends StatefulWidget {
  final Map<dynamic, dynamic> news; // Data berita yang akan diedit

  const EditNewsScreen({Key? key, required this.news}) : super(key: key);

  @override
  _EditNewsScreenState createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController newsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi form dengan data berita yang sudah ada
    titleController.text = widget.news['title'];
    newsController.text = widget.news['content'];
    dateController.text = widget.news['date'];
  }

  Future<void> updateNews(String newsKey) async {
    // URL untuk update data berita di Firebase
    final String url =
        'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/news/$newsKey.json';

    // Data berita yang diperbarui
    Map<String, String> updatedData = {
      'title': titleController.text,
      'news': newsController.text,
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
        throw Exception('Failed to update news');
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
        title: Text('Edit News'),
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
            Text('News'),
            TextField(
              controller: newsController,
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
                updateNews(widget.news['key']);
              },
              child: Text('Update News'),
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

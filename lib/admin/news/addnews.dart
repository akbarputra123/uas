import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl untuk format tanggal
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'newspage.dart';

class AddNewsScreen extends StatelessWidget {
  final Map<dynamic, dynamic>? news; // Tambahkan parameter untuk menerima data berita

  AddNewsScreen({Key? key, this.news}) : super(key: key);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController newsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  Future<void> addNews(BuildContext context) async {
    // Memeriksa apakah ada kolom yang kosong
    if (titleController.text.isEmpty || newsController.text.isEmpty || dateController.text.isEmpty) {
      // Menampilkan pesan error jika ada field yang kosong
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Peringatan'),
          content: Text('Harap isi semua data sebelum menambahkan berita.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Membatalkan proses jika ada data yang kosong
    }

    // URL Firebase Realtime Database
    final String url = 'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/news.json';

    // Prepare data to send
    Map<String, String> newsData = {
      'title': titleController.text,
      'news': newsController.text,
      'date': dateController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(newsData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Data berhasil disimpan!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Peringatan'),
            content: Text('Gagal menyimpan data: ${response.statusCode}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Peringatan'),
          content: Text('Terjadi kesalahan: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika ada data berita yang diteruskan, isikan pada form
    if (news != null) {
      titleController.text = news!['title'];
      newsController.text = news!['content'];
      dateController.text = news!['date'];
    }

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
          'Add New',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Field
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

            // News Field
            Text(
              'News',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F6376),
              ),
            ),
            const SizedBox(height: 8),
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

            // Date Field with Day Name
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
                  // Format tanggal dan hari menggunakan DateFormat
                  String formattedDate = DateFormat('EEEE, dd/MM/yyyy').format(pickedDate);

                  // Set the formatted date with day
                  dateController.text = formattedDate;
                }
              },
            ),
            const SizedBox(height: 32),

            // Add Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addNews(context);
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
                  'Add',
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
    );
  }
}

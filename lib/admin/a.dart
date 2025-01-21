import 'package:flutter/material.dart';

class lihatWasteEd extends StatelessWidget {
  const lihatWasteEd({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian atas (Header)
          Container(
            color: Color(0xFF2F6376), // Warna biru sesuai gambar
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Judul',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Kamis, 16 Januari 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Bagian konten
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  '''Saat ini, area depan Laboratorium Rekayasa Perangkat Lunak (RPL) di Universitas Khairun Ternate menjadi salah satu titik yang menyedihkan, di mana sampah terlihat berserakan di sekitar lingkungan tersebut. Kertas, botol plastik, dan berbagai jenis sampah lain tampak terabaikan, menciptakan pemandangan yang tidak hanya mengganggu estetika kampus tetapi juga dapat menimbulkan dampak lingkungan yang buruk.

Kondisi ini menunjukkan pentingnya kesadaran bersama dalam menjaga kebersihan kampus, terutama di area yang sering dilalui mahasiswa dan civitas akademika. Keberadaan sampah yang berserakan ini seharusnya menjadi pengingat bagi kita semua akan tanggung jawab untuk menjaga lingkungan sekitar tetap bersih dan sehat.''',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


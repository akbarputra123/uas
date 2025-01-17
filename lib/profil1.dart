import 'package:flutter/material.dart';

class HomePages extends StatelessWidget {
  final List<String> availableProjectors = [
    'Proyektor A - Ruang 101',
    'Proyektor B - Ruang 102',
    'Proyektor C - Ruang 103',
    'Proyektor D - Ruang 104',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peminjaman Proyektor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Proyektor Tersedia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableProjectors.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(availableProjectors[index]),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Aksi untuk meminjam proyektor
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Proyektor ${availableProjectors[index]} berhasil dipinjam!'),
                            ),
                          );
                        },
                        child: Text('Pinjam'),
                        style: ElevatedButton.styleFrom(iconColor: Colors.blue),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DaftarProyektorPage extends StatelessWidget {
  const DaftarProyektorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contoh data proyektor (dapat diganti dengan data dari Firebase)
    final List<Map<String, String>> proyektors = [
      {'kode': 'PRJ001', 'merk': 'Epson', 'status': 'Tersedia'},
      {'kode': 'PRJ002', 'merk': 'Canon', 'status': 'Dipinjam'},
      {'kode': 'PRJ003', 'merk': 'BenQ', 'status': 'Tersedia'},
      {'kode': 'PRJ004', 'merk': 'Sony', 'status': 'Dipinjam'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Proyektor'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: proyektors.length,
          itemBuilder: (context, index) {
            final proyektor = proyektors[index];
            final statusColor = proyektor['status'] == 'Tersedia'
                ? Colors.green
                : Colors.red;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(
                  Icons.video_label,
                  size: 40,
                  color: statusColor,
                ),
                title: Text(
                  proyektor['merk'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kode: ${proyektor['kode']}'),
                    Text('Status: ${proyektor['status']}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: proyektor['status'] == 'Tersedia'
                      ? () {
                          // Aksi ketika tombol dipencet, misalnya meminjam
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Meminjam proyektor: ${proyektor['kode']}'),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: const Text('Pinjam'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

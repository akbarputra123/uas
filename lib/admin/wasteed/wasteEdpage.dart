import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'addedu.dart';
import 'editedu.dart';

class WasteedScreen extends StatefulWidget {
  const WasteedScreen({Key? key}) : super(key: key);

  @override
  _WasteedScreenState createState() => _WasteedScreenState();
}

class _WasteedScreenState extends State<WasteedScreen> {
  final String _url =
      'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/wasteed.json';
  List<Map<dynamic, dynamic>> _wasteedList = [];

  @override
  void initState() {
    super.initState();
    _fetchWasteed();
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> _fetchWasteed() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          List<Map<dynamic, dynamic>> wasteed = data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>;
            return {
              'key': entry.key,
              'title': value['title'] ?? 'No Title',
              'date': value['date'] ?? 'Unknown Date',
              'content': value['wasteed'] ?? 'No Content Available',
            };
          }).toList();

          setState(() {
            _wasteedList = wasteed;
          });
        } else {
          setState(() {
            _wasteedList = [];
          });
        }
      } else {
        throw Exception('Failed to load wasteed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk menghapus data dari Firebase
  Future<void> _deleteWasteed(String key) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/wasteed/$key.json'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _wasteedList.removeWhere((wasteed) => wasteed['key'] == key);
        });
      } else {
        throw Exception('Failed to delete wasteed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF1A3E4B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text('Wasteed', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 8),
            Icon(Icons.article, color: Colors.white),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _wasteedList.isEmpty
            ? Center(child: Text('Upload Wasteed', style: TextStyle(fontSize: 20)))
            : ListView.builder(
                itemCount: _wasteedList.length,
                itemBuilder: (context, index) {
                  var wasteed = _wasteedList[index];
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF9AE19D),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wasteed['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          wasteed['date'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Tombol More
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => lihatWasteed(wasteed: wasteed),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1A3E4B),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                'More',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            Row(
                              children: [
                                // Tombol Edit
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF1A3E4B)),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditWasteedScreen(wasteed: wasteed),
                                      ),
                                    ).then((_) {
                                      // Memanggil kembali untuk memuat ulang data
                                      _fetchWasteed();
                                    });
                                  },
                                ),

                                // Tombol Hapus
                                IconButton(
                                  icon: Icon(Icons.delete, color: Color(0xFF1A3E4B)),
                                  onPressed: () {
                                    _deleteWasteed(wasteed['key']);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWasteedScreen()),
          );
        },
        backgroundColor: Color(0xFF1A3E4B),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class lihatWasteed extends StatelessWidget {
  final Map<dynamic, dynamic> wasteed;
  const lihatWasteed({Key? key, required this.wasteed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF2F6376),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      wasteed['title'],
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
                  wasteed['date'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  wasteed['content'],
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

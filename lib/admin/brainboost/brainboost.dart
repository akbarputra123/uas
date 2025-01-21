import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'add_brainboost.dart';

class BrainboostScreen extends StatefulWidget {
  const BrainboostScreen({Key? key}) : super(key: key);

  @override
  _BrainboostScreenState createState() => _BrainboostScreenState();
}

class _BrainboostScreenState extends State<BrainboostScreen> {
  final String _url =
      'https://barr-502d7-default-rtdb.asia-southeast1.firebasedatabase.app/wasteed.json';
  List<Map<dynamic, dynamic>> _brainboostList = [];

  @override
  void initState() {
    super.initState();
    _fetchBrainboost();
  }

  // Fungsi untuk mengambil data dari Firebase
  Future<void> _fetchBrainboost() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          List<Map<dynamic, dynamic>> brainboost = data.entries.map((entry) {
            final value = entry.value as Map<dynamic, dynamic>;
            return {
              'key': entry.key,
              'title': value['title'] ?? 'No Title',
              'date': value['date'] ?? 'Unknown Date',
              'content': value['content'] ?? 'No Content Available',
            };
          }).toList();

          setState(() {
            _brainboostList = brainboost;
          });
        } else {
          setState(() {
            _brainboostList = [];
          });
        }
      } else {
        throw Exception('Failed to load brainboost');
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
            Text('Brainboost', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 8),
            Icon(Icons.article, color: Colors.white),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _brainboostList.isEmpty
            ? Center(
                child:
                    Text('Upload Brainboost', style: TextStyle(fontSize: 20)))
            : ListView.builder(
                itemCount: _brainboostList.length,
                itemBuilder: (context, index) {
                  var brainboost = _brainboostList[index];
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
                          brainboost['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brainboost['date'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end, // Tombol di kanan
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddBrainBoostScreen(),
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
                                'Add Brain Boost',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class AddBrainboostScreen extends StatelessWidget {
  const AddBrainboostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Brain Boost'),
        backgroundColor: Color(0xFF1A3E4B),
      ),
      body: Center(
        child: Text(
          'Halaman Tambah Brainboost',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// class LihatBrainboost extends StatelessWidget {
//   final Map<dynamic, dynamic> brainboost;
//   const LihatBrainboost({Key? key, required this.brainboost}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             color: Color(0xFF2F6376),
//             padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       brainboost['title'],
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   brainboost['date'],
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SingleChildScrollView(
//                 child: Text(
//                   brainboost['content'],
//                   style: TextStyle(
//                     fontSize: 16,
//                     height: 1.5,
//                     color: Colors.black87,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tes/login.dart';
import 'package:tes/mhs/daftar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Peminjaman Proyektor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: user == null
              ? const Text(
                  'Silakan login untuk melanjutkan',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                       Icons.tv, // Atau Icons.present_to_all
                      size: 100.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Selamat datang di aplikasi peminjaman proyektor!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        bool? confirmLogout = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi Logout'),
                              content: const Text('Apakah Anda yakin ingin keluar?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Keluar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmLogout == true) {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPages()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(200, 50),
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                   ElevatedButton(
  onPressed: () {
    // Navigate to the ProjectorListPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DaftarProyektorPage(), // Replace with your page's name
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.greenAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    minimumSize: const Size(200, 50),
  ),
  child: const Text(
    'Lihat Daftar Proyektor',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
)

                  ],
                ),
        ),
      ),
    );
  }
}

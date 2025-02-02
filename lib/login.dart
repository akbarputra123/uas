
import 'package:tes/admin/adminhome.dart';
import 'lupa.dart';
import 'registrasi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart'; // Ganti dengan halaman yang sesuai setelah login
import 'package:flutter/services.dart'; // Untuk menangani error di iOS
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tes/pages/home.dart';

class LoginPages extends StatefulWidget {
  const LoginPages({super.key});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // TextEditingControllers for phone and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FormKey for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Obscure password flag
  bool _obscurePassword = true;

 Future<void> _signInWithGoogle() async {
  try {
    // Melakukan sign-in dengan Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // Jika user membatalkan login (googleUser null), tampilkan pesan
      print("User canceled Google Sign-In");
      return; // Menghindari error jika user cancel
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Mencoba login menggunakan kredensial yang didapatkan
    final UserCredential userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      // Simpan idUser ke SharedPreferences dengan kunci 'idUser'
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idUser', userCredential.user!.uid);

      // Login berhasil, arahkan ke halaman utama (ProfilPage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboard(), // Ganti dengan halaman ProfilPage
        ),
      );
    }
  } catch (e) {
    // Menangani error jika terjadi
    print("Error during Google Sign-In: $e");
    // Anda bisa menampilkan pesan kesalahan jika diperlukan
  }
}

  // Fungsi untuk login dengan Apple
  Future<void> _signInWithApple() async {
    try {
      // Implementasi login Apple di sini
      // Untuk login dengan Apple, Anda bisa menggunakan package `sign_in_with_apple`
      // Pastikan Anda telah mengonfigurasi Firebase dan Apple Sign-In di Firebase Console

      print("Login with Apple (Fitur ini memerlukan konfigurasi lebih lanjut)");

      // Jika login Apple berhasil, Anda bisa mengarahkan ke halaman berikutnya
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPages()), // Ganti dengan halaman yang sesuai
      );
    } catch (e) {
      print("Error during Apple Sign-In: $e");
    }
  }
// Ambil id_user yang disimpan di SharedPreferences
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('idUser');  // Ambil UID menggunakan kunci yang sama
}

Future<void> _signInWithEmailPassword() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  print('=== DEBUG LOG ===');
  print('Email: $email');
  print('Password: $password');
  print('==================' );

  // Cek jika email adalah admin
  if (email == 'admin@gmail.com' && password == '123') {
    print('Login sebagai Admin');

    // Simpan idUser sebagai admin ke SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('idUser', 'admin'); // Menyimpan ID sebagai admin

    // Arahkan ke halaman Admin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDashboard(), // Halaman khusus untuk admin
      ),
    );
    return; // Menghentikan eksekusi agar tidak melakukan login Firebase
  }

  try {
    // Jika bukan admin, lakukan login menggunakan Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      print('Login berhasil: ${userCredential.user!.uid}');

      // Simpan idUser ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('idUser', userCredential.user!.uid); // Menyimpan UID pengguna

      print('UID pengguna berhasil disimpan ke SharedPreferences.');

      // Arahkan ke halaman sesuai (HomePages untuk pengguna biasa)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboard(), // Halaman home untuk pengguna biasa
        ),
      );
    } else {
      print('Login gagal: UserCredential null.');
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    if (e.code == 'user-not-found') {
      errorMessage = 'Pengguna tidak ditemukan. Silakan periksa email Anda.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Password yang Anda masukkan salah.';
    } else {
      errorMessage = 'Terjadi kesalahan: ${e.message}';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Enter your email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
  controller: emailController,
  keyboardType: TextInputType.emailAddress, // Keyboard mendukung format email
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  },
  decoration: InputDecoration(
    prefixIcon: const Icon(Icons.email), // Ikon untuk email
    hintText: 'Masukkan email Anda',
    suffixIcon: const Icon(
      Icons.check_circle_outline_outlined,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
),

                          const SizedBox(height: 20),
                          const Text(
                            "Enter your password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password must be filled';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: '********',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _signInWithEmailPassword(); // Panggil fungsi login
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistrasiPages(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        
                       
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

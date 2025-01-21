import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

import 'package:tes/login.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userEmail = "Loading...";
  String userPhone = "Loading...";
  String userPassword = "Loading...";
  bool isLoading = true;
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isEditing = false;
  bool _obscurePassword = true; // To toggle password visibility

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Ambil data pengguna dari FirebaseAuth
 Future<void> fetchUserData() async {
  setState(() {
    isLoading = true;
  });

  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Jika user tidak login
      setState(() {
        userEmail = "User not logged in";
        userPhone = "-";
        userPassword = "-";
        isLoading = false;
      });
      print("User is not logged in.");
      return;
    }

    // Log data pengguna yang sudah terautentikasi
    print("User logged in:");
    print("Email: ${user.email}");
    print("Phone: ${user.phoneNumber}");

    // Ambil data pengguna yang sudah terautentikasi
    setState(() {
      userEmail = user.email ?? "Email not available";
      userPhone = user.phoneNumber ?? "Phone not available";
      userPassword = "********"; // Password tidak bisa diambil langsung
      _emailController.text = userEmail;
      _phoneController.text = userPhone;
      _passwordController.text = userPassword;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      userEmail = "Error loading email";
      userPhone = "Error loading phone";
      userPassword = "Error loading password";
      isLoading = false;
    });
    print("Error fetching user data: $e");
  }
}

  // Fungsi untuk update data pengguna
  Future<void> updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return; // Jika tidak ada user yang login
      }

      // Update email dan nomor telepon
      await user.updateEmail(_emailController.text);
      await user.updatePhoneNumber(PhoneAuthProvider.credential(
        verificationId: 'verificationId', // Anda perlu mengimplementasikan ini jika menggunakan nomor telepon
        smsCode: 'smsCode',
      ));

      // Update password
      if (_passwordController.text.isNotEmpty) {
        await user.updatePassword(_passwordController.text);
      }

      // Set state untuk menampilkan perubahan
      setState(() {
        userEmail = _emailController.text;
        userPhone = _phoneController.text;
        userPassword = _passwordController.text;
        isEditing = false; // Stop editing mode
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diperbarui!')),
      );
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating data')),
      );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFF346E81),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Row(
        children: [
          Icon(Icons.person, color: Colors.white),
          SizedBox(width: 8),
          Text("User", style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
    
    body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menambahkan sapaan halo dengan email pengguna
               Center(
                child: Container(
                  width: 300,
                  height: 100,
                 
                  
                  child:  Text(
                  'Halo, ${userEmail}', // Menampilkan sapaan dengan email
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ),

               ),
           
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF346E81),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPages()),
                      );
                    },
                    child: const Text("Logout",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
  );
}
}
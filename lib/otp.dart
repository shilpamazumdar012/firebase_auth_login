import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  OtpScreen({Key? key, required this.verificationId})
      : super(key: key); // Modify the constructor

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const Text('OTP Screen', style: TextStyle(fontSize: 24)),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  otp = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your otp',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () =>
                  signInWithOTP(_auth, otp, widget.verificationId, context),
              child: Text("Verify Otp"))
        ],
      ),
    );
  }
}

Future<void> signInWithOTP(
    _auth, String otp, String verificationId, context) async {
  try {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await _auth.signInWithCredential(credential);
    print('User is signed in');
    
    await secureStorage.write(key: 'isLoggedIn', value: 'true');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );
  } catch (e) {
    print('Failed to sign in: $e');
  }
}

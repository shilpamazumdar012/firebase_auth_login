import 'package:firebase_auth_login/otp.dart';
import 'package:firebase_auth_login/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/otp': (context) => OtpScreen(verificationId: ''),
        '/welcome': (context) => WelcomeScreen(),
        // Other routes
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String phoneNumber = '+91 1234 567 890';
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                //  onChanged: (value) {
                //     setState(() {
                //       phoneNumber = value;
                //     });
                //   },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your phone number',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => verifyPhoneNumber(phoneNumber, context),
                child: const Text("Generate Otp"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Function to send an OTP to the provided phone number
Future<void> verifyPhoneNumber(String phoneNumber, context) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // Automatically sign in when verification is completed
      await _auth.signInWithCredential(credential);
      print('Verification Completed');
    },
    verificationFailed: (FirebaseAuthException e) {
      print('Verification Failed: ${e.message}');
    },
    codeSent: (String verificationId, int? resendToken) {
      // Store verification ID to use it later
      print('Code Sent. Verification ID: $verificationId');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId),
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Auto-retrieval timeout (no user action required)
      print('Auto-Retrieval Timeout. Verification ID: $verificationId');
    },
  );
}

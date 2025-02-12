import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home_screen.dart';
import 'package:flutter_application_2/screens/login_screen.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Web Firebase Initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDtEh7lGWKotTgRBr0xus5Je9ZBsOnBjEI",
        authDomain: "flutter-application-2-df821.firebaseapp.com",
        projectId: "flutter-application-2-df821",
        storageBucket: "flutter-application-2-df821.appspot.com",
        messagingSenderId: "1075629369168",
        appId: "1:1075629369168:web:6d4e688e95256d58b52e55",
        measurementId: "G-5S2LCJ0K3W",
      ),
    );
  } else {
    // Mobile Firebase Initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDn4BG357OxFle4LbC_4ZOfs03szSTqCtk",
        appId: "1:1075629369168:android:62fd22619ca4ea0fb52e55",
        messagingSenderId: "1075629369168",
        projectId: "flutter-application-2-df821",
      ),
    );
  }

  runApp(const MyApp());
}

String? validUsername;
String? validPassword;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> creds = [];

  Future<List<Map<String, dynamic>>> getCreds() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('login_authority').get();
      final List<QueryDocumentSnapshot> documents = snapshot.docs;
      return documents
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      log("Error fetching data: $e");
      return [];
    }
  }

  @override
  void initState() {
    getCreds().then(
      (value) {
        if (value.isNotEmpty) {
          validUsername = value[0]['id'];
          validPassword = value[0]['pass'];
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.blueAccent),
          ),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEAF4FF),
            foregroundColor: Colors.blue,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.blue),
          labelStyle: TextStyle(color: Colors.black54),
          focusColor: Colors.blue,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

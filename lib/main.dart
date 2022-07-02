import 'package:flutter/material.dart';
import 'package:phone_call_app/phone_call_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PhoneCallApp());
}

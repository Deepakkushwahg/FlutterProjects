// ignore_for_file: unused_import, prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:phone_call_app/assessment/user_login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GetStarted(),
  ));
}

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
                child: Text(
              "TRAINING",
              style: TextStyle(color: Colors.purple, fontSize: 40),
            )),
            Container(
              width: 250,
              height: 400,
              child: Image(
                  image: NetworkImage(
                      "https://png.pngtree.com/png-clipart/20191120/original/pngtree-vector-illustration-man-training-presentation-flat-cartoon-style-png-image_5047445.jpg")),
            ),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UserLogin();
                  }));
                },
                child: Center(child: Text("Get Started")),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

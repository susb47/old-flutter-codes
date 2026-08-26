import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: IDCard(),
        ),
      ),
    );
  }
}

class IDCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 300,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ID Card",
            style: TextStyle(color: Colors.yellow, fontSize: 16),
          ),
          SizedBox(height: 10),
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/Passport.jpg'),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10), 
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Name:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Susmoy Biswas",
              style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "ID:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "221-15-5647",
              style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Current Semester:",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "8th",
              style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.email, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Text(
                "susmoy@gmail.com",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

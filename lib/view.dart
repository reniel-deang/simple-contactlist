import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewContact extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String email;

  const ViewContact({
    Key? key,
    required this.name,
    required this.phoneNumber,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phone ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      phoneNumber,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Email ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

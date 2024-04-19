import 'package:flutter/material.dart';

class TokenPage extends StatelessWidget {
  final String accessToken;

  const TokenPage({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Token'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tu token personal es:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                accessToken,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String pageName;

  const DetailPage({Key? key, required this.pageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
      ),
      body: Center(
        child: Text('Contenido de $pageName'),
      ),
    );
  }
}

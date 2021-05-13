import 'package:flutter/material.dart';

class WasteScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  const WasteScaffold({Key key, this.body, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: body,
    );
  }
}

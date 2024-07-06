import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Adopt extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AdoptState();
  }
}

class AdoptState extends State<Adopt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adopt"),
      ),
      body: Center(
        child: Text("This is Adopt."),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BrowseState();
  }
}

class BrowseState extends State<Browse> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browse"),
      ),
      body: Center(
        child: Text("This is browse."),
      ),
    );
  }
}

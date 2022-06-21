import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/user.dart';

class HomePage extends StatefulWidget {
  final User loggedUser;
  const HomePage(this.loggedUser, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(),
    );
  }
}

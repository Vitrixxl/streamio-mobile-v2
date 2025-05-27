import 'package:flutter/material.dart';
import 'package:streamio_mobile/pages/list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Bienvenue sur la gestion des stock de streamio",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              TextField(decoration: InputDecoration(labelText: "Email")),
              TextField(decoration: InputDecoration(labelText: "Password")),
              ElevatedButton(
                child: Text("coucou"),
                onPressed: () => login(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

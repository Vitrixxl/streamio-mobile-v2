import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streamio_mobile/pages/list_page.dart';
import 'package:streamio_mobile/service/http_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _errorMessage;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) async {
    final resp = await HttpService.dio.post(
      "/api/auth/sign-in/email",
      data: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );
    if (resp.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ListPage()),
      );
    } else {
      setState(() {
        final data = resp.data is String ? json.decode(resp.data) : resp.data;
        _errorMessage = data["message"] ?? "Erreur inconnue";
      });
    }
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
              TextField(
                decoration: InputDecoration(labelText: "Email"),
                controller: emailController,
              ),
              Flex(
                direction: Axis.horizontal,
                spacing: 12,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(labelText: "Password"),
                      controller: passwordController,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      child: Icon(Icons.check),
                      onPressed: () => login(context),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

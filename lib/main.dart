import 'package:flutter/material.dart';
import 'package:streamio_mobile/pages/list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: Colors.orange,
          secondary: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFF151515),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.green,
          ), // couleur par défaut du texte dans TextField
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Colors.orange,
          fillColor: Colors.orange,
          hoverColor: Colors.orange,
          hintStyle: TextStyle(color: Colors.orange),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Center(child: const Text('Streamio'))),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(decoration: InputDecoration(labelText: "Email")),
                IntrinsicHeight(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(labelText: "Password"),
                        ),
                      ),
                      SizedBox(
                        height: 52,
                        child: Builder(
                          builder: (context) => ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListPage(),
                                ),
                              );
                            },
                            style: ButtonStyle(),
                            child: Icon(Icons.check),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

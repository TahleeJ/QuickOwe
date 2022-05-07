import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const QuickOweApp());
}

class QuickOweApp extends StatefulWidget {
  const QuickOweApp({Key? key}) : super(key: key);

  @override
  QuickOweAppState createState() => QuickOweAppState();
}

class QuickOweAppState extends State<QuickOweApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quick Owe',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: Colors.blue[900]
            )
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen()
    );
  }
}



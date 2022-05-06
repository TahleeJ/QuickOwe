import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuickOweApp());
}

class QuickOweApp extends StatelessWidget {
  const QuickOweApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Owe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.blue[900]
        )
      ),
      home: const HomeScreen(title: 'Quick Owe'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  Map<UniqueKey, TextEditingController> _nameControllers = {};
  Map<UniqueKey, TextEditingController> _subtotalControllers = {};
  Map<UniqueKey, TextEditingController> _oweControllers = {};

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the HomeScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title)
          ],
        )
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                buildBorrower(),
                buildBorrower()
              ]
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildBorrower() {
    final UniqueKey borrowerKey = UniqueKey();
    final nameController = TextEditingController();
    final subtotalController = TextEditingController();
    final oweController = TextEditingController();

    _nameControllers.putIfAbsent(borrowerKey, () => nameController);
    _subtotalControllers.putIfAbsent(borrowerKey, () => subtotalController);
    _oweControllers.putIfAbsent(borrowerKey, () => oweController);

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.greenAccent[400],
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.white70
                      ),
                      controller: nameController,
                      showCursor: true,
                      style: const TextStyle(fontSize: 20),
                    )
                ),
                const Spacer(),
                const Text("\$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                    child: TextField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent)
                          ),
                          hintText: 'Subtotal',
                          filled: true,
                          fillColor: Colors.white70
                        ),
                      controller: subtotalController,
                      showCursor: true,
                      style: const TextStyle(fontSize: 20),
                    )
                )
              ],
            ),
          ),
        ),
        const Divider()
      ]
    );
  }
}

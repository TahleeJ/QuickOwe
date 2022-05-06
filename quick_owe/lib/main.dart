import 'package:flutter/material.dart';

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

  List<UniqueKey> _borrowerKeys = [];
  Map<UniqueKey, TextEditingController> _nameControllers = {};
  Map<UniqueKey, TextEditingController> _subtotalControllers = {};
  Map<UniqueKey, TextEditingController> _oweControllers = {};

  final TextEditingController _taxController = TextEditingController(text: "0.00");
  final TextEditingController _tipController = TextEditingController(text: "0.00");

  void _addBorrowerSubtotalCard() {
    setState(() {
      final borrowerKey = UniqueKey();

      _borrowerKeys.add(borrowerKey);
      _nameControllers.putIfAbsent(borrowerKey, () => TextEditingController());
      _subtotalControllers.putIfAbsent(borrowerKey, () => TextEditingController());
      _oweControllers.putIfAbsent(borrowerKey, () => TextEditingController());
    });
  }

  void _removeBorrowerSubtotalCard(UniqueKey borrowerKey) {
    setState(() {
      _borrowerKeys.remove(borrowerKey);
      _nameControllers.remove(borrowerKey);
      _subtotalControllers.remove(borrowerKey);
      _oweControllers.remove(borrowerKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 28))
          ],
        )
      ),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                   height: MediaQuery.of(context).size.height * 3/4 - 50,
                   child: ListView.builder(
                     itemCount: _borrowerKeys.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildBorrower(_borrowerKeys[index]);
                      },
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.add_circle_outlined, size: 50, color: Colors.grey),
                      onTap: () {
                        _addBorrowerSubtotalCard();
                      },
                    )
                  ],
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.yellowAccent[400],
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 10.0),
                    child: Row(
                      children: [
                        const Text("Tax: \$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70
                                ),
                                controller: _taxController,
                                showCursor: true,
                                style: const TextStyle(fontSize: 20)
                            )
                        ),
                        const Spacer(),
                        const Text("Tip: \$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70
                                ),
                                controller: _tipController,
                                showCursor: true,
                                style: const TextStyle(fontSize: 20)
                            )
                        )
                      ],
                    ),
                  ),
                )
              ]
          )
        )
      ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildBorrower(UniqueKey borrowerKey) {
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
                      controller: _nameControllers[borrowerKey],
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
                      controller: _subtotalControllers[borrowerKey],
                      showCursor: true,
                      style: const TextStyle(fontSize: 20),
                    )
                ),
                const Spacer(),
                GestureDetector(
                  child: const Icon(Icons.remove_circle_outlined, size: 50, color: Colors.grey),
                  onTap: () {
                    _removeBorrowerSubtotalCard(borrowerKey);
                  },
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

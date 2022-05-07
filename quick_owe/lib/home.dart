import 'package:faker_dart/faker_dart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final List<UniqueKey> _borrowerKeys = [];
  final Map<UniqueKey, TextEditingController> _nameControllers = {};
  final Map<UniqueKey, TextEditingController> _subtotalControllers = {};
  final Map<UniqueKey, TextEditingController> _oweControllers = {};

  final TextEditingController _taxController = TextEditingController(text: "0.00");
  final TextEditingController _tipController = TextEditingController(text: "0.00");

  final faker = Faker.instance;

  late final TabController _tabController;
  final int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        initialIndex: _index,
        vsync: this
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addBorrowerSubtotalCard() {
    setState(() {
      final borrowerKey = UniqueKey();
      String randomAnimal = faker.animal.animal();

      _borrowerKeys.add(borrowerKey);
      _nameControllers.putIfAbsent(borrowerKey, () => TextEditingController(text: randomAnimal));
      _subtotalControllers.putIfAbsent(borrowerKey, () => TextEditingController(text: "0.00"));
      _oweControllers.putIfAbsent(borrowerKey, () => TextEditingController(text: "0.00"));
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

  double validateDouble(String input) {
    if (input.isEmpty || double.tryParse(input) == null) {
      return 0.0;
    }

    return double.parse(input);
  }

  void _updateBorrowerOwe() {
    final double tax = validateDouble(_taxController.text);
    final double tip = validateDouble(_tipController.text);
    double total = 0.0;
    double subtotal;
    double percentage;
    double owe;

    _subtotalControllers.forEach((key, value) {
      subtotal = validateDouble(value.text.toString());
      total += subtotal;
    });

    _subtotalControllers.forEach((key, value) {
      subtotal = validateDouble(value.text.toString());
      percentage = total == 0 ? 0.0 : subtotal / total;
      owe = subtotal + percentage * tip + percentage * tax;

      _oweControllers[key]!.text = owe.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    bool _validTax = true;
    bool _validTip = true;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Quick Owe", style: TextStyle(fontSize: 28))
            ],
          ),
          actions: [
            IconButton(onPressed: () { Navigator.popAndPushNamed(context, '/'); }, icon: const Icon(Icons.refresh))
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            reverse: true,
            child: SizedBox(
                height: MediaQuery.of(context).size.height - 85,
                child: StatefulBuilder(
                    builder: (context, setState) {
                      return Stack(
                          alignment: Alignment.center,
                          children: [
                            PageView(
                              controller: pageController,
                              children: [
                                Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Padding(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text("Borrower Subtotals", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context).size.height * 3 / 4 - 125,
                                                  child: Scrollbar(
                                                      child: ListView.builder(
                                                        itemCount: _borrowerKeys.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return buildBorrower(_borrowerKeys[index]);
                                                        },
                                                      )
                                                  )
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(7.5),
                                                child: Row(
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
                                              ),
                                              Container(
                                                  height: 75,
                                                  decoration: BoxDecoration(
                                                      color: Colors.yellowAccent[400],
                                                      borderRadius: BorderRadius.circular(10.0)
                                                  ),
                                                  child: Padding(
                                                      padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 10.0),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            const Text("Tax: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                            const Text("\$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                                            SizedBox(
                                                                width: MediaQuery.of(context).size.width / 4,
                                                                child: TextField(
                                                                    decoration: InputDecoration(
                                                                        border: const OutlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.transparent)
                                                                        ),
                                                                        errorText: _validTax ? null : "0.0",
                                                                        filled: true,
                                                                        fillColor: Colors.white70
                                                                    ),
                                                                    controller: _taxController,
                                                                    showCursor: true,
                                                                    style: const TextStyle(fontSize: 20),
                                                                    onChanged: (value) {
                                                                      setState(() {
                                                                        _validTax = double.tryParse(value) != null;

                                                                        if (_validTax) {
                                                                          _updateBorrowerOwe();
                                                                        }
                                                                      });
                                                                    }
                                                                )
                                                            ),
                                                            const Spacer(),
                                                            const Text("Tip: ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                            const Text("\$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                                            SizedBox(width: MediaQuery.of(context).size.width / 4,
                                                                child: TextField(
                                                                    decoration: InputDecoration(
                                                                        border: const OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.transparent),
                                                                        ),
                                                                        errorText: _validTip ? null : "0.0",
                                                                        filled: true,
                                                                        fillColor: Colors.white70
                                                                    ),
                                                                    controller: _tipController,
                                                                    showCursor: true,
                                                                    style: const TextStyle(fontSize: 20),
                                                                    onChanged: (value) =>
                                                                        setState(() {
                                                                          _validTip = (double.tryParse(value) != null);

                                                                          if (_validTip) {
                                                                            _updateBorrowerOwe();
                                                                          }
                                                                        })
                                                                )
                                                            )
                                                          ]
                                                      )
                                                  )
                                              )
                                            ]
                                        )
                                    ) // This trailing comma makes auto-formatting nicer for build methods.
                                ),
                                Center(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: const [
                                                  Padding(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text("Borrower Oweage", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context).size.height * 3 / 4,
                                                  child: Scrollbar(
                                                      child: ListView.builder(
                                                        itemCount: _borrowerKeys.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return buildOwe(_borrowerKeys[index]);
                                                        },
                                                      )
                                                  )
                                              )
                                            ]
                                        )
                                    )
                                )
                              ],
                              onPageChanged: (page) {
                                _tabController.index = page;
                              },
                            ),
                            Positioned(
                              child: TabPageSelector(
                                controller: _tabController,
                              ),
                              bottom: 20.0,
                            )
                          ]
                      );
                    }
                )
            )
        )
    );
  }

  Widget buildBorrower(UniqueKey borrowerKey) {
    bool _validSubtotal = true;

    return StatefulBuilder(
        builder: (context, setState) {
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
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: TextField(
                                decoration: const InputDecoration(hintText: 'Name', filled: true, fillColor: Colors.white70
                                ),
                                controller: _nameControllers[borrowerKey],
                                showCursor: true,
                                style: const TextStyle(fontSize: 18),
                                onChanged: (value) {
                                  _updateBorrowerOwe();
                                }
                            )
                        ),
                        const Spacer(),
                        const Text("\$", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    hintText: 'Subtotal',
                                    errorText: _validSubtotal ? null : "0.0",
                                    filled: true,
                                    fillColor: Colors.white70
                                ),
                                controller: _subtotalControllers[borrowerKey],
                                showCursor: true,
                                style: const TextStyle(fontSize: 20),
                                onChanged: (value) {
                                  setState(() {
                                    _validSubtotal = double.tryParse(value) != null;

                                    if (_validSubtotal) {
                                      _updateBorrowerOwe();
                                    }
                                  });
                                }
                            )
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: const Icon(Icons.remove_circle_outlined, size: 36, color: Colors.grey),
                          onTap: () {
                            _removeBorrowerSubtotalCard(borrowerKey);
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                )
              ]
          );
        }
    );
  }

  Widget buildOwe(UniqueKey borrowerKey) {
    final name = _nameControllers[borrowerKey]!.text;
    final owe = _oweControllers[borrowerKey]!.text;

    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text(name, style: const TextStyle(fontSize: 20))
                  ),
                  const Spacer(),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child: Text('\$$owe', style: const TextStyle(fontSize: 20))
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.transparent,
          )
        ]
    );
  }
}
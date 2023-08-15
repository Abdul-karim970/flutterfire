import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference extends StatefulWidget {
  const MySharedPreference({super.key});

  @override
  State<MySharedPreference> createState() => _MySharedPreferenceState();
}

class _MySharedPreferenceState extends State<MySharedPreference> {
  late TextEditingController _keyController;
  late TextEditingController _valueController;
  String fetchedValue = '';
  // late SharedPreferences sharedPreference;
  List<String> dummyList = List.generate(5, (index) => '$index');

  @override
  void initState() {
    super.initState();
    _keyController = TextEditingController();
    _valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> initializingSharedPreferenceInstance() async {
    //   sharedPreference = await SharedPreferences.getInstance();
    // }

    // initializingSharedPreferenceInstance();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(fetchedValue),
            SizedBox(
              width: 300,
              height: 200,
              child: ListView.builder(
                itemExtent: 70,
                itemCount: dummyList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dummyList[index]),
                  );
                },
              ),
            ),
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreference =
                      await SharedPreferences.getInstance();
                  var isStored = await sharedPreference.setString(
                      _keyController.text, _valueController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isStored.toString())));
                },
                child: const Text('Put String')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreference =
                      await SharedPreferences.getInstance();
                  var isStored = await sharedPreference.setStringList(
                      _keyController.text,
                      _valueController.text.codeUnits
                          .map((integerValue) => '$integerValue')
                          .toList());
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isStored.toString())));
                },
                child: const Text('Put List of String')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreference =
                      await SharedPreferences.getInstance();
                  fetchedValue =
                      (sharedPreference.getString(_keyController.text)) ??
                          'Nothing fetched';
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(fetchedValue.toString())));
                },
                child: const Text('Get String')),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreference =
                      await SharedPreferences.getInstance();
                  dummyList =
                      sharedPreference.getStringList(_keyController.text) ??
                          dummyList;
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(dummyList.toString())));
                },
                child: const Text('Gut List of String')),
          ],
        ),
      ),
    );
  }
}

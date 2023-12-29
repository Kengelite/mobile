import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure you've initialized Firebase
  await Firebase.initializeApp();
  runApp(FetchData());
}

class FetchData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int _creditBalance = 0;

  @override
  void initState() {
    super.initState();
    _readCreditBalance();
    print(' หฟหฟหฟหฟ.');
  }

  Future<void> _readCreditBalance() async {
    try {
      print('หฟหฟ222.');
      DataSnapshot snapshot =
          await _database.child('box1/credit_balance').get();
      print('avaiหหหlable.');
      if (snapshot.exists) {
        setState(() {
          _creditBalance = int.parse(snapshot.value.toString());
        });
        print('available.');
      } else {
        print('No data available.');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Demo'),
      ),
      body: Center(
        child: Text('Credit Balance: $_creditBalance'),
      ),
    );
  }
}

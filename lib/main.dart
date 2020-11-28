import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';
import 'package:personal_expenses/utils/database_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
          button: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              ),
            )),
      ),
      title: 'Personal Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TransactionModel> userTransactions;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TransactionModel> get _recentTransactions {
    return userTransactions.where((tx) {
      return DateTime.fromMillisecondsSinceEpoch(tx.date).isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double price, int date) async {
    TransactionModel newTx = TransactionModel(
      title,
      price,
      date,
    );
    int res = await databaseHelper.insert(newTx);
    res != 1
        ? _showSnackBar('Added Successfully')
        : _showSnackBar('Failed To Add');
    _updateListView();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        isScrollControlled: true,
        context: ctx,
        builder: (builderCtx) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(BuildContext ctx, TransactionModel tx) async {
    int res = await databaseHelper.delete(tx.id);
    res == 1
        ? _showSnackBar('Deleted Successfully')
        : _showSnackBar('Failed To Delete');
    _updateListView();
  }

  void _showSnackBar(String msg) {
    final snackbar = SnackBar(content: Text(msg));
    if (Platform.isIOS) return;
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    if (userTransactions == null) {
      userTransactions = List<TransactionModel>();
      _updateListView();
    }
    final homeWidget = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Chart(_recentTransactions),
          Expanded(
              child: TransactionList(userTransactions, _deleteTransaction)),
        ],
      ),
    );

    Widget _androidScaffold() {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Personal Expenses'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _startAddNewTransaction(context);
              },
            ),
          ],
        ),
        body: homeWidget,
        floatingActionButton: Platform.isIOS
            ? Container()
            : FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    }

    Widget _iosScaffold() {
      return CupertinoPageScaffold(
        key: _scaffoldKey,
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Personal Expenses'),
          trailing: GestureDetector(
            child: const Icon(CupertinoIcons.add),
            onTap: () {
              _startAddNewTransaction(context);
            },
          ),
        ),
        child: homeWidget,
      );
    }

    return Platform.isIOS ? _iosScaffold() : _androidScaffold();
  }

  void _updateListView() {
    final db = DatabaseHelper().initializeDatabase();
    db.then((database) {
      Future<List<TransactionModel>> transactions =
      databaseHelper.getTransactionsList();
      transactions.then((value) {
        setState(() {
          userTransactions = value;
        });
      });
    });
  }
}

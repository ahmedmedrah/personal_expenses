import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:personal_expenses/models/transaction.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String transactionTable = 'transactions_table';
  String colId = 'id';
  String colTitle = 'title';
  String colAmount = 'amount';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'transactions.db';
    var transactionsDB = openDatabase(path, version: 1, onCreate: _createDB);
    return transactionsDB;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $transactionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        ' $colAmount REAL, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getTransactionsMapList() async {
    Database db = await this.database;
    // var result = db.rawQuery('select * from $transactionTable order by $colDate DESC');
    var result = db.query(transactionTable, orderBy: '$colDate DESC');
    return result;
  }

  Future<int> insert(TransactionModel tx) async {
    Database db = await this.database;
    print(tx.toMap());
    var result = await db.insert(transactionTable, tx.toMap());
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    var result = await db
        .rawDelete('DELETE FROM $transactionTable WHERE $colId = ${id}');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> res =
        await db.rawQuery('select COUNT(*) from $transactionTable');
    int cnt = Sqflite.firstIntValue(res);
    return cnt;
  }

  Future<List<TransactionModel>> getTransactionsList() async {
    var transactionsMapList = await getTransactionsMapList();
    List<TransactionModel> res = transactionsMapList
        .map((e) => TransactionModel.fromMapObject(e))
        .toList();
    return res;
  }
}

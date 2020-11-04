import 'package:flutter/foundation.dart';

class TransactionModel {
  int _id;
  String _title;
  double _amount;
  int _date;

  TransactionModel.withId(
    this._id,
    this._title,
    this._amount,
    this._date,
  );

  TransactionModel(
    this._title,
    this._amount,
    this._date,
  );

  TransactionModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._amount = map['amount'];
    this._date = int.parse(map['date']);
  }

  int get date => _date;

  set date(int value) {
    _date = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  String get title => _title;

  set title(String value) {
    if (value.length <= 255) {
      _title = value;
    }
  }

  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (this._id != null) {
      map['id'] = this._id;
    }
    map['title'] = this._title;
    map['amount'] = this._amount;
    map['date'] = this._date;
    return map;
  }
}

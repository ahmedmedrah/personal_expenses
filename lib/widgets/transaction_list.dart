import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:personal_expenses/utils/database_services.dart';
import 'dart:async';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function deleteTX;

  TransactionList(this.transactions, this.deleteTX);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Empty',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.all(3),
                  child: ListTile(
                    leading: Container(
                      width: 80,
                      height: 40,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: FittedBox(
                        child: Text(
                          '\$ ${transactions[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    title: Text(transactions[index].title,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6),
                    subtitle: Text(
                      DateFormat.yMMMEd().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              transactions[index].date)),
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: MediaQuery
                        .of(context)
                        .size
                        .width > 360
                        ? FlatButton.icon(
                      label: Text('Delete'),
                      textColor: Theme
                          .of(context)
                          .errorColor,
                      icon: Icon(
                        Icons.delete,
                        color: Theme
                            .of(context)
                            .errorColor,
                      ),
                      onPressed: () =>
                          deleteTX(context, transactions[index]),
                    )
                        : IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme
                            .of(context)
                            .errorColor,
                      ),
                      onPressed: () =>
                          deleteTX(context, transactions[index]),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}

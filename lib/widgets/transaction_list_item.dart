import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required this.transaction,
    @required this.deleteTX,
  }) : super(key: key);

  final TransactionModel transaction;
  final Function deleteTX;

  @override
  Widget build(BuildContext context) {
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
              '\$ ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        title: Text(transaction.title,
            style: Theme.of(context).textTheme.headline6),
        subtitle: Text(
          DateFormat.yMMMEd()
              .format(DateTime.fromMillisecondsSinceEpoch(transaction.date)),
          style: TextStyle(color: Colors.grey[700]),
        ),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                label: const Text('Delete'),
                textColor: Theme.of(context).errorColor,
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.delete : Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => deleteTX(context, transaction),
              )
            : IconButton(
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.delete : Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => deleteTX(context, transaction),
              ),
      ),
    );
  }
}

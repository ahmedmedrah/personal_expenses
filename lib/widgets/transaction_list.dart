import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/transaction_list_item.dart';

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
                return TransactionListItem(
                    transaction: transactions[index], deleteTX: deleteTX);
              },
              itemCount: transactions.length,
            ),
    );
  }
}

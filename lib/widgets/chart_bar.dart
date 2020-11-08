import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String title;
  final double spendingAmount;
  final double spendingPct;

  const ChartBar(this.title, this.spendingAmount, this.spendingPct);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            height: 20,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: 70,
            width: 14,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Colors.grey[400],
                    // color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPct,
                  child: Container(
                      decoration: BoxDecoration(
                    // color: Colors.grey[400],
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  )),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(title)
        ],
      ),
    );
  }
}

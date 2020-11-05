import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/adaptive_flat_button.dart';
import 'package:personal_expenses/widgets/adaptive_text_field.dart';
import 'package:personal_expenses/widgets/adaptive_raised_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTxHandler;

  NewTransaction(this.addTxHandler);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_priceController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredPrice = double.parse(_priceController.text);

    if (enteredPrice <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }
    widget.addTxHandler(
        enteredTitle, enteredPrice, _selectedDate.millisecondsSinceEpoch);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
        left: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AdaptiveTextField(
              text: 'title',
              handler: _submitData,
              controller: _titleController,
              textInputType: TextInputType.text),
          AdaptiveTextField(
              text: 'price',
              handler: _submitData,
              controller: _priceController,
              textInputType: TextInputType.number),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                    child: Text(_selectedDate == null
                        ? 'no date choosen'
                        : 'Picked Date:\t\t${DateFormat.yMMMd().format(_selectedDate)}')),
                AdaptiveFlatButton('Select Date', _showDatePicker),
              ],
            ),
          ),
          AdaptiveRaisedButton('Add Transaction', _submitData),
        ],
      ),
    );
  }
}

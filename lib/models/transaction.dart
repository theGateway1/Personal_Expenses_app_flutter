import 'package:flutter/material.dart';

class Transaction {
  //These all 4 properties are final, i.e. they get their values when this transaction is created, but this value never changes.

  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.amount,
    @required this.date,
    @required this.id,
    @required this.title,
  });
}

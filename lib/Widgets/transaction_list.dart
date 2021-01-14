import 'package:flutter/material.dart';
import '../models/transaction.dart';

import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  //Constructor:
  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No Transactions',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                transaction: transactions[index],
                deleteTx: deleteTx,
              );
            },
            itemCount:
                transactions.length, //Gives no. of items in transactions list.
          );
  }
}

//This is shifted to user_transaction.dart
// final List<Transaction> _userTransactions = [
//   Transaction(
//     amount: 49.99,
//     id: 'f1',
//     date: DateTime.now(),
//     title: 'Shoes',
//   ),
//   Transaction(
//     amount: 69.99,
//     id: 'f2',
//     date: DateTime.now(),
//     title: 'Groceries',
//   ),
// ];

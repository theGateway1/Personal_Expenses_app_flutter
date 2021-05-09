import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import './Widgets/transaction_list.dart';
import './Widgets/new_transaction.dart';
import './models/transaction.dart';
import './Widgets/chart.dart';

main() {
  //Allowing only Portrait mode:

  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  //Creating a new transaction here with received txtitle and txamount.

  void _addNewTransaction(
      String txtitle, double txamount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txtitle,
      amount: txamount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      //isScrollControlled: true,
      context: ctx,
      builder: (bctx) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );
  }

  List<Widget> _buildLandscapeContent(AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = _buildAppBar();

    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.6,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}

/////////-------------------Step 1 Code---------------------------/////////////

//This gives 2 widgets Chart and List in column style:
// body: Column(
//       children: <Widget>[
//         Card(
//           child: Text('CHART!'),
//         ),
//         Card(
//           child: Text('List'), //Code B
//         ),
//       ],
//     )

//Card by default assumes size of the child.
//To change size of card,
// 1. we can change size of child, to do so wrap the child i.e. text in a container and assign it a width.
// children: <Widget>[
// Card(
//   child: Container(
//     width: 100,
//     child: Text('CHART!'),
//     color: Colors.blue,
//   ),
//   elevation: 5,)

//width can also be set to double.infinity, it takes the size of the screen.

// 2. Card can be given a parent container, since container's width is large, card will take container's width.
//Card by default depends on size of child for width, unless there is a parent like container, which has its own clearly defined width.

//Alignment in column and Row:
//Column(
// mainAxisAlignment: MainAxisAlignment.end,
//crossAxisAlignment: CrossAxisAlignment.stretch,

//Transaction is id + title + value + Date(that is of DateTime type), so a seperate class is made.

// Now we have to show the transactions, to show those transactions, we'll use column() so remove the code B snippet and make a column there.
// Card(
//   child: Text('List'),
//   color: Colors.red,
// ),
//Instead of above card() that shows list, we will display actual transactions.

// import 'package:flutter/material.dart';
// import './transaction.dart';
// import 'package:intl/intl.dart';

// main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final List<Transaction> transactions = [
//     Transaction(
//       amount: 49.99,
//       id: 'f1',
//       date: DateTime.now(),
//       title: 'Shoes',
//     ),
//     Transaction(
//       amount: 69.99,
//       id: 'f2',
//       date: DateTime.now(),
//       title: 'Groceries',
//     ),
//   ]; //List of transactions

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter app'),
//         ),
//         body: Column(
//           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Card(
//               child: Container(
//                 width: double.infinity,
//                 child: Text('CHART!'),
//                 color: Colors.blue,
//               ),
//               elevation: 5,
//             ),
//             Column(
//               children: transactions.map((tx) {
//                 return Row(
//                   children: <Widget>[
//                     //New List Desgin's Row part
//                     Container(
//                       margin: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.purple,
//                           width: 2,
//                         ),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Text(
//                         //tx.amount.toString(), //Just amount with $ sign
//                         //'A: ${tx.amount}', //String Interpolation
//                         '\$${tx.amount}', //String Interpolation
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.purple,
//                         ),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           tx.title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           DateFormat.yMMMEd().format(tx.date),
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ));
//   }
// }

//-----------------------Adding button and functionality--------------------------//

// import 'package:flutter/material.dart';
// import './models/transaction.dart';
// import 'package:intl/intl.dart';

// main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter App',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final List<Transaction> transactions = [
//     Transaction(
//       amount: 49.99,
//       id: 'f1',
//       date: DateTime.now(),
//       title: 'Shoes',
//     ),
//     Transaction(
//       amount: 69.99,
//       id: 'f2',
//       date: DateTime.now(),
//       title: 'Groceries',
//     ),
//   ]; //List of transactions

// // Method 1: Manual method of saving the input, using onchanged listener.... Method A
//   //String titleInput;
//   //String amountInput;

// // Method 2: Built-in method of saving the input, using onchanged listener.... Method B
//   final titleController = TextEditingController();
//   final amountController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter app'),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Container(
//               width: double.infinity,
//               child: Card(
//                 child: Text('CHART!'),
//                 color: Colors.blue,
//                 elevation: 5,
//               ),
//             ),

//             //------------ New Input Area after Chart -------------------------//
//             Card(
//               elevation: 5,
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: <Widget>[
//                     TextField(
//                       decoration: InputDecoration(labelText: 'Title'),
//                       //Method A
//                       //onChanged: (val) {
//                       //titleInput = val;
//                       //},

//                       //Method B
//                       controller: titleController,
//                     ),
//                     TextField(
//                       decoration: InputDecoration(labelText: 'Amount'),
//                       //Method A
//                       // onChanged: (val) {
//                       //   amountInput = val;
//                       // },

//                       //Mehod B
//                       controller: amountController,
//                     ),
//                     //Now Adding the button.
//                     FlatButton(
//                       child: Text('Add Transaction'),
//                       onPressed: () {
//                         //Method A
//                         //The values of Title and Amount get printed.
//                         // print(titleInput);
//                         // print(amountInput);

//                         //Method B
//                         print(titleController.text);
//                         print(amountController.text);
//                       },
//                       textColor: Colors.purple,
//                     )
//                   ],
//                 ),
//               ),
//             ),

//             // --------------------Input Area Ends----------------------------------//
//             Column(
//               children: transactions.map((tx) {
//                 return Row(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: Colors.purple,
//                           width: 2,
//                         ),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Text(
//                         '\$${tx.amount}',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                           color: Colors.purple,
//                         ),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           tx.title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           DateFormat.yMMMEd().format(tx.date),
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 );
//               }).toList(),
//             ),
//           ],
//         ));
//   }
// }

//----------------------Most Recent Version----------------------------------------------//
//---------------Splitting App into Widgets and ---------------------------------------//

//class MyHomePage extends StatelessWidget {
//final List<Transaction> transactions = [
//These 2 transactions will be moved to transaction_list.dart file
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
// ]; //List of transactions

//------------ New Input Area after Chart -------------------------//
//Moved to new_transaction.dart return() section.
// Card(
//   elevation: 5,
//   child: Container(
//     padding: EdgeInsets.all(10),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         TextField(
//           decoration: InputDecoration(labelText: 'Title'),

//           //Method B
//           controller: titleController,
//         ),
//         TextField(
//           decoration: InputDecoration(labelText: 'Amount'),
//           //Mehod B
//           controller: amountController,
//         ),
//         //Now Adding the button.
//         FlatButton(
//           child: Text('Add Transaction'),
//           onPressed: () {
//             //Method B
//             print(titleController.text);
//             print(amountController.text);
//           },
//           textColor: Colors.purple,
//         )
//       ],
//     ),
//   ),
// ),

// In transaction_List, we have our list of transactions, and this list should change, but the change is triggered by text fields that are in card in main.dart file.
// Lifting State Up.
// The text field aren't inside the TransactionList(), so we add 2 new widgets.
//1. For Text Input Area
//2. Put Text input widget and Transactionlist() widget into a 3rd new widget, which we'll use in MyHomePage widget.

//Advantage of this: MyHomePage widget will stay stateless.

// --------------------Input Area Ends----------------------------------//

//-----------------Output List of Transactions---------------------------//

//This list of txn output will now be displayed in transaction_list.dart file//

// Column(
//   children: transactions.map((tx) {
//     return Row(
//       children: <Widget>[
//         Container(
//           margin: EdgeInsets.symmetric(
//             vertical: 10,
//             horizontal: 15,
//           ),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Colors.purple,
//               width: 2,
//             ),
//           ),
//           padding: EdgeInsets.all(10),
//           child: Text(
//             '\$${tx.amount}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.purple,
//             ),
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               tx.title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               DateFormat.yMMMEd().format(tx.date),
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }).toList(),
// ),

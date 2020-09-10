import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items =
      List<String>.generate(20, (i) => "Item ${i + 1} A B C D E... X Y Z");

  String whatHappened;

  @override
  Widget build(BuildContext context) {
    final title = 'Notification Items List';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Dismissible(
              key: Key(item),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("$item was $whatHappened")));
              },
              confirmDismiss: (DismissDirection dismissDirection) async {
                switch (dismissDirection) {
                  case DismissDirection.endToStart:
                    whatHappened = 'ARCHIVED';
                    return await _showConfirmationDialog(context, 'Archive') ==
                        true;
                  case DismissDirection.startToEnd:
                    whatHappened = 'DELETED';
                    return await _showConfirmationDialog(context, 'Delete') ==
                        true;
                  case DismissDirection.horizontal:
                  case DismissDirection.vertical:
                  case DismissDirection.up:
                  case DismissDirection.down:
                    assert(false);
                }
                return false;
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.cancel),
              ),
              secondaryBackground: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.green,
                alignment: Alignment.centerRight,
                child: Icon(Icons.check),
              ),
              child: ListTile(title: Text('$item')),
            );
          },
        ),
      ),
    );
  }
}

Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to $action this item?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}

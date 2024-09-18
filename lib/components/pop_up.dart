import 'package:flutter/material.dart';

class MyPopup extends StatelessWidget {
  final String title;
  final String content;

  const MyPopup({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

void _showPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MyPopup(
        title: 'Popup Title',
        content: 'This is a popup message.',
      );
    },
  );
}

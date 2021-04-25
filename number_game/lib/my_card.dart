import 'package:flutter/material.dart';

class MyCardWidget extends StatefulWidget {
  final int value;
  final ValueChanged<int> onTapped;
  MyCardWidget(this.value, this.onTapped);

  @override
  _MyCardWidgetState createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<MyCardWidget> {

  void _handleTap(){
    widget.onTapped(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    int value = widget.value;
    return GestureDetector(
      onTap: _handleTap,
      child: Card(
        child: Center(
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
          ),
        )
      ),
    );
  }
}
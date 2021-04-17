import 'dart:math';

import 'package:flutter/material.dart';

const double iconSize = 72;

class Player {
  List numbers = [];
  String username;
  Player(int turnNum, String uname){
    username = uname;
    for(int i = 1; i <= turnNum; i++){
      numbers.add(i);
    }
  }

  void use(int number){
    int index = this.numbers.indexOf(number);
    if(index != -1){
      this.numbers.removeAt(index);
    }
  }
}

class PlayerWidget extends StatefulWidget{
  final Player player;

  PlayerWidget({
    this.player,
  }) : super(key: ValueKey(player));

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: iconSize),
          Text(
            widget.player.username,
            style: TextStyle(fontSize: 18),
          )
        ],
      )
    );
  }
}

class PlayerFieldWidget extends StatefulWidget {
  @override
  _PlayerFieldWidgetState createState() => _PlayerFieldWidgetState();
}

class _PlayerFieldWidgetState extends State<PlayerFieldWidget> {
  List players = [
    new Player(4, 'User 1'),
    new Player(4, 'User 2'),
    new Player(4, 'User 3'),
    new Player(4, 'User 4'),
    new Player(5, 'User 5'),
    new Player(6, 'User 6'),
    new Player(7, 'User 7')
  ];
  @override
  Widget build(BuildContext context) {
    final double r = (MediaQuery.of(context).size.width - iconSize) / 2 ;
    return Expanded(
      child: Stack(
        children: <Widget>[
          for(int i = 0; i < players.length; i++)
            Positioned(
              child: PlayerWidget(player: players[i],),
              left: r - cos(pi * i / (players.length - 1)) * r,
              top: r - sin(pi * i / (players.length - 1)) * r,
            ),
        ],
      )
    );
  }
}
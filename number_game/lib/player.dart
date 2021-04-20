import 'dart:math';
import './my_card.dart';

import 'package:flutter/material.dart';

const double iconSize = 72;

class Player{
  List numbers = [];
  String username;
  Player(int turnNum, String uname){
    username = uname;
    for(int i = 1; i <= turnNum; i++){
      numbers.add(i);
    }
  }

  void init(int turnNum){
    for(int i = 1; i <= turnNum; i++){
      numbers.add(i);
    }
  }

  void use(int number){
    this.numbers.remove(number);
  }

  bool isHaving(int number){
    return this.numbers.indexOf(number) != -1;
  }
}


class PlayerWidget extends StatefulWidget{
  final Player player;
  final Color color;

  PlayerWidget({
    this.player,
    this.color
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
          Icon(
            Icons.person,
            size: iconSize,
            color: widget.color,
          ),
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
  final List<Player> players;
  final int selectedNumber;
  final List selections;

  PlayerFieldWidget(this.players, this.selectedNumber, this.selections);

  @override
  _PlayerFieldWidgetState createState() => _PlayerFieldWidgetState();
}

class _PlayerFieldWidgetState extends State<PlayerFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final double r = (MediaQuery.of(context).size.width - iconSize) / 2;
    final double cardWidth = iconSize / 2;
    return SizedBox(
      child: Stack(
        children: <Widget>[
          for(int i = 0; i < widget.selections.length; i++)
            Positioned(
              child: MyCardWidget(widget.selections[i], null),
              left: r - cos(pi * i / (widget.players.length - 1)) * r * 0.5 + cardWidth / 2,
              top: r - sin(pi * i / (widget.players.length - 1)) * r * 0.5,
              width: cardWidth,
              height: cardWidth * (1 + sqrt(5)) / 2,
            ),
          for(int i = 0; i < widget.players.length; i++)
            Positioned(
              child: PlayerWidget(
                player: widget.players[i],
                color: widget.players[i].isHaving(widget.selectedNumber) ? Colors.red : null,
              ),
              left: r - cos(pi * i / (widget.players.length - 1)) * r,
              top: r - sin(pi * i / (widget.players.length - 1)) * r,
            ),
        ],
      ),
      height: r * 1.5,
    );
  }
}
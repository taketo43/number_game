import 'package:flutter/material.dart';
import 'package:number_game/waiting_room.dart';


class CreatedGameListState extends State<CreatedGameList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("募集中のゲーム"),
      ),
      body: ListView(
        children: [
          _gameItem("hayato", 3, context),
          _gameItem("takeda", 0, context),
          _gameItem("fujitani", 3, context),
          _gameItem("tanuma", 2, context),
        ],
      ),
    );
  }
  Widget _gameItem(String host, int participants, context) {
    String username = widget.username;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: new BoxDecoration(
          border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
            ),
            Text(
              host + " : " + participants.toString() + "人",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaitingRoom(username))
        );
      },
    );
  }
}

class CreatedGameList extends StatefulWidget {
  CreatedGameList(this.username);
  final String username;

  @override
  CreatedGameListState createState() => new CreatedGameListState();
}
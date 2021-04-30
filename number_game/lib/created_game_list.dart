import 'package:flutter/material.dart';
import 'package:number_game/socket_io_setup.dart';
import 'package:number_game/waiting_room.dart';


class CreatedGameListState extends State<CreatedGameList> {
  List gameList = [];
@override
void initState() {
  super.initState();
  socket.emit('get rooms');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("募集中のゲーム"),
      ),
      body: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.hasData && snapshot.data["event"] == "room list"){
            gameList = snapshot.data["rooms"];
            streamSocket.addResponse(null);
          }
          print(gameList);
          return ListView(
            children: [
              for(var room in gameList)
                _gameItem(room["host"], room["people"], room["room_id"], context),
              ElevatedButton(
                onPressed: (){
                  socket.emit('get rooms');
                },
                child: Text('reload')
              )
            ],
          );
        }
      )
    );
  }

  Widget _gameItem(String host, int participants, String roomID, context) {
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
        socket.emit('join', [roomID, 'test_user']);
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
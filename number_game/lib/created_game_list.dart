import 'package:flutter/material.dart';
import 'package:number_game/socket_io_setup.dart';
import 'package:number_game/waiting_room.dart';
import 'dart:async';


class CreatedGameListState extends State<CreatedGameList> {
  List gameList = [];
  int userID;
  List memberList = [];
  String joinedRoomID;

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
          }
          if(snapshot.hasData && snapshot.data["event"] == "user_id"){
            userID = snapshot.data["user_id"];
            memberList = snapshot.data["members"];
          }
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
    return ListTile(
      title: Text("$roomID"),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("ホスト : $host"),
          Text("現在の人数 : $participants"),
        ]
      ),
      onTap: (){
        socket.emit('join', [roomID, username]);
        joinedRoomID = roomID;
        Timer(Duration(microseconds: 10), _toNextPage);
      },
      leading: Icon(Icons.group, size: 48),
    );
  }

  void _toNextPage(){
    if(userID == null || joinedRoomID == null) {
      Timer(Duration(microseconds: 10), _toNextPage);
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WaitingRoom(userID, joinedRoomID, memberList))
      );
    }
  }
}

class CreatedGameList extends StatefulWidget {
  CreatedGameList(this.username);
  final String username;

  @override
  CreatedGameListState createState() => new CreatedGameListState();
}
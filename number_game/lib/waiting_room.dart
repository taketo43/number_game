import 'package:flutter/material.dart';
import 'package:number_game/socket_io_setup.dart';
import 'dart:async';
import 'gamepage.dart';

class WaitingRoom extends StatefulWidget {
  final List membarList;

  WaitingRoom(this.userID, this.roomID, this.membarList);
  final int userID;
  final String roomID;

  @override
  WaitingRoomState createState() => new WaitingRoomState();
}

class WaitingRoomState extends State<WaitingRoom> {
  List userList = [];
  int userID;
  int turns = 4;
  bool startFlag = false;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
    userList = widget.membarList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("待機部屋"),
        automaticallyImplyLeading: false
      ),
      body: Container(
        alignment: Alignment.center,
        child: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
            if(snapshot.hasData && snapshot.data["event"] == "enter"){
              userList = snapshot.data["members"];
            }
            if(snapshot.hasData && snapshot.data["event"] == "leave"){
              userList.removeAt(snapshot.data["user_id"]);
              if(snapshot.data["user_id"] < userID) userID -= 1;
            }
            if(snapshot.hasData && snapshot.data["event"] == "start"){
              userList = snapshot.data["members"];
              print(snapshot.data);
              Timer(Duration(milliseconds: 100), () {
                print(userList);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GamePage(userID, userList.length, snapshot.data["turns"], userList)
                ));
              });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(children: [
                  for (int i = 0; i < userList.length; i++)
                    Text(userList[i] + (userID == i ? " (You)" : ""))
                ]),
                ButtonTheme(
                  buttonColor: Colors.white54,
                  minWidth: 150,
                  height: 40,
                  child: ElevatedButton(
                    child: Text("ゲームを始める"),
                    onPressed: widget.userID == 0 ? () {
                      socket.emit('start', [widget.roomID, turns]);
                    } : null,
                  )
                ),
                ButtonTheme(
                  buttonColor: Colors.white54,
                  minWidth: 150,
                  height: 40,
                  child: ElevatedButton(
                    child: Text("部屋を抜ける"),
                    onPressed: () {
                      socket.emit('leave', [widget.roomID, widget.userID]);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  )
                ),
              ],
            );
          }
        ),
      )
    );
  }
}

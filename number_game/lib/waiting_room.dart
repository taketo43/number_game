import 'package:flutter/material.dart';

class WaitingRoom extends StatefulWidget {
  WaitingRoom(this.host);
  final String host;

  @override
  WaitingRoomState createState() => new WaitingRoomState();
}

class WaitingRoomState extends State<WaitingRoom> {
  var userList = ['mitomi', 'fujitani', 'takeda', 'tanuma', 'akisawa'];
  var isHost = [true, false, false, false, false];
  var isMe = [false, false, false, false, true];
  @override
  Widget build(BuildContext context) {
    String host = widget.host;
    return Scaffold(
      appBar: AppBar(
        title: Text("待機部屋"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              for (int i = 0; i < userList.length; i++)
                (isHost[i] == true)
                    ? Text(userList[i] + "(host)")
                    : Text(userList[i])
            ]),
            ButtonTheme(
                buttonColor: Colors.white54,
                minWidth: 150,
                height: 40,
                child: RaisedButton(
                  child: Text("ゲームを始める"),
                  onPressed: () {
                    //  ゲームを始める処理
                  },
                )),
            ButtonTheme(
                buttonColor: Colors.white54,
                minWidth: 150,
                height: 40,
                child: RaisedButton(
                  child: Text("部屋を抜ける"),
                  onPressed: () {
                    //  部屋を抜ける処理
                    //  ホストが抜けた場合どうするか
                  },
                )),
          ],
        ),
      ),
    );
  }
}

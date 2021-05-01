import 'package:flutter/material.dart';
import './socket_io_setup.dart';
import 'package:number_game/created_game_list.dart';
import 'package:number_game/waiting_room.dart';
import 'package:number_game/socket_io_setup.dart';
import 'package:uuid/uuid.dart';

void main() {
  connectAndListen();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Number Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String username = "";
  var uuid = Uuid();
  void _handleText(String e) {
    setState(() {
      username = e;
    });
  }

  Future _showDialog() async {
    var value = await showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text(''),
        content: new Text('名前を入力してください'),
        actions: <Widget>[
          new SimpleDialogOption(
            child: new Text('閉じる'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'User Name',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  // Text(
                  //   host,
                  //   style: TextStyle(
                  //     fontSize: 25,
                  //   ),
                  // ),
                  Container(
                    width: 175,
                    child: new TextFormField(
                      enabled: true,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: '名前を入力してください',
                      ),
                      onChanged: _handleText,
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  ButtonTheme(
                    buttonColor: Colors.white54,
                    minWidth: 150,
                    height: 40,
                    child: RaisedButton(
                        child: Text("ホストで始める"),
                        onPressed: () {
                          if (this.username.length == 0) {
                            _showDialog();
                          } else {
                            String roomId = uuid.v1();
                            socket.emit('create', [roomId, username]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        WaitingRoom(0, roomId, [username])));
                          }
                          //　サーバーに名前を渡す？
                        }),
                  ),
                  Container(
                    height: 20,
                  ),
                  ButtonTheme(
                    minWidth: 150,
                    height: 40,
                    buttonColor: Colors.white54,
                    child: RaisedButton(
                        child: Text("ゲームに参加する"),
                        onPressed: () {
                          if (this.username.length == 0) {
                            _showDialog();
                          } else {
                            socket.emit('get rooms');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreatedGameList(username)),
                            );
                          }
                          // サーバーに名前を渡す？
                        }),
                  )
                ],
              ),
            );
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

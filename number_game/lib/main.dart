import 'package:flutter/material.dart';
import './socket_io_setup.dart';
import 'package:number_game/created_game_list.dart';
import 'package:number_game/waiting_room.dart';

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
  void _handleText(String e) {
    setState(() {
      username = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
              width: 150,
              child: new TextField(
                textAlign: TextAlign.center,
                maxLength: 15,
                maxLengthEnforced: false,
                maxLines: 1,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaitingRoom(0, "test_room", [username])));
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreatedGameList(username)),
                    );
                    // サーバーに名前を渡す？
                  }),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

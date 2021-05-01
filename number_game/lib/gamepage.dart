import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import './player.dart';
import './socket_io_setup.dart';


class GamePage extends StatefulWidget {
  final List<Player> players = [];
  final List myNumbers = [];
  final int playerNumbers; // プレイヤーの人数
  final int playerID; // プレイヤーの中の自分のID
  final int turns;
  GamePage(this.playerID, this.playerNumbers, this.turns, playerData){
    for(int i = 1; i <= turns; i++){
      myNumbers.add(i);
    }
    for(int i = 0; i < playerNumbers; i++){
      if(i == playerID) continue;
      players.add(new Player(turns, playerData[i]));
    }
  }

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int selectedNumber;
  bool isDetermined = false;
  List<dynamic> selections = [];
  int turnNum = 1;
  String roomID = "test"; // 後で書き換える

  void _handleSelectedNumberChanged(int newValue) {
    setState(() {
      selectedNumber = newValue;
    });
  }

  void _handleDeterminedNumber() {
    setState(() {
      isDetermined = true;
    });
    socket.emit('choose', [roomID, widget.playerID, turnNum, selectedNumber]);
  }

  void _everyoneSelected() async{
    await showDialog(
      context: context,
      builder: (context){
        Widget res = selections.indexOf(selectedNumber) == -1 ? SimpleDialog(
          title: Text("セーフ"),
          children: [
            Text("今回はセーフ") // 差し替えてもいいかも
          ],
        ) : SimpleDialog(
          title: Text("アウト"),
          children: [
            Text("$selectedNumber 被り") // 差し替えてもいいかも
          ]
        );
        return res;
      }
    );

    setState(() {
      isDetermined = false;
      for(int i = 0; i < selections.length; i++){
        widget.players[i].use(selections[i]);
      }
      widget.myNumbers.remove(selectedNumber);
      selectedNumber = null;
      turnNum++;
      selections = [];
    });
    streamSocket.addResponse(null); // なぜかここでnullを入れないと同じデータが２回読み込まれてしまう
  }
  
  void _handleGameResart() {
    if(widget.myNumbers.length == 0){
      setState(() {
        for(int i = 1; i <= widget.turns; i++){
          widget.myNumbers.add(i);
        }
        for(int i = 0; i < widget.players.length; i++){
          widget.players[i].init(widget.turns);
        }
        turnNum = 1;
      });
    }
    streamSocket.addResponse(null);
  }

  void _handleFinishGame() {
    socket.emit('finish', roomID);
    streamSocket.addResponse(null);
  }

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width / 3.5;
    double height = width * (1 + sqrt(5)) / 2;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false
      ),
      body: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.hasData && snapshot.data['event'] == 'everyone selected'){
            selections = snapshot.data['numbers'];
            selections.removeAt(widget.playerID);
            Timer(Duration(seconds: 2), _everyoneSelected);
          }else if(snapshot.hasData && snapshot.data['event'] == 'start'){
            print('start');
            Timer(Duration(microseconds: 100), _handleGameResart);
          }else if(snapshot.hasData && snapshot.data['event'] == 'finish'){
            print('finish');
            Timer(Duration(microseconds: 100), () {
              socket.emit('exit room', roomID);
              print('exit');
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          }
          for(int i = 0; i < selections.length; i++){
            selections[i] = int.parse(selections[i]);
            widget.players[i].use(selections[i]);
          }
          List<DropdownMenuItem<int>> _numbers = [];
          for(int value in widget.myNumbers){
            _numbers.add(DropdownMenuItem(
              child: Text('$value'),
              value: value,
            ));
          }
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20), // margin
                PlayerFieldWidget(widget.players, selectedNumber, selections),
                SizedBox(height: 10), // margin
                SizedBox(
                  child: Card(
                    child: Center(
                      child: Text(
                        selectedNumber == null ? '' : '$selectedNumber',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  ),
                  width: width,
                  height: height,
                ),
                SizedBox(height: 10), // margin
                Container(
                  child: Padding(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: _numbers,
                        value: selectedNumber,
                        onChanged: isDetermined ? null : _handleSelectedNumberChanged,
                      ),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10),
                  ),
                  color: Colors.white,
                ),
                SizedBox(height: 10), // margin
                if(selectedNumber != null) ElevatedButton(
                  onPressed: isDetermined ? null : _handleDeterminedNumber,
                  child: Text("確定する"),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(height: 5), // margin
                if(widget.myNumbers.length == 0) ElevatedButton(
                  onPressed: _handleGameResart,
                  child: Text("もう一度"),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                ),
                SizedBox(height: 5), // margin
                if(widget.myNumbers.length == 0) ElevatedButton(
                  onPressed: _handleFinishGame,
                  child: Text("ホームへ"),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                ),
                Expanded(child: Container())
              ]
            ),
            color: Colors.blueGrey[50],
          );
        }
      )
    );
  }
}
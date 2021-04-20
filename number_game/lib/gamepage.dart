import 'dart:math';
import 'package:flutter/material.dart';
import './player.dart';
import './my_card.dart';
import './socket_io_setup.dart';


class GamePage extends StatefulWidget {
  final List<Player> players = [];
  final List<int> myNumbers = [];
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
  List<int> selections = [];
  int turn_num = 1;
  String room_id = "test"; // 後で書き換える

  void _handleSelectedNumberChanged(int newValue) {
    setState(() {
      if(selectedNumber == newValue) selectedNumber = null;
      else selectedNumber = newValue;
    });
  }

  void _handleDeterminedNumber() {
    setState(() {
      isDetermined = true;
    });
    socket.emit('choose', [room_id, widget.playerID, turn_num, selectedNumber]);
  }

  void _everyoneSelected(List<int> selections) async {
    selections.removeAt(widget.playerID);
    setState(() {
      this.selections = selections;
    });


    await Future.delayed(Duration(seconds: 2));
    
    await showDialog(
      context: context,
      builder: (context){
        return selections.indexOf(selectedNumber) == -1 ? SimpleDialog(
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
      }
    );

    setState(() {
      isDetermined = false;
      for(int i = 0; i < widget.players.length; i++){
        widget.players[i].use(selections[i]);
      }
      widget.myNumbers.remove(selectedNumber);
      selections = [];
      selectedNumber = null;
      turn_num++;
    });
  }

  // 全員の選択が完了したら
  // myNumbers.remove(selectedNumber);
  // selectdNumber = null;
  // isDetermined = false;
  // playersのuseメソッドの実行
  // 
  
  void _handleGameResart() {
    setState(() {
      for(int i = 1; i <= widget.turns; i++){
        widget.myNumbers.add(i);
      }
      for(int i = 0; i < widget.players.length; i++){
        widget.players[i].init(widget.turns);
      }
      turn_num = 1;
    });
  }

  void _handleFinishGame() {
    // ホーム画面へ戻る処理
  }

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width / widget.turns;
    double height = width * (1 + sqrt(5)) / 2;
    return Expanded(
      child: StreamBuilder(
        stream: streamSocket.getResponse,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
          if(snapshot.hasData && snapshot.data['event'] == 'everyone selected'){
            _everyoneSelected(snapshot.data['numbers']);
          }
          return Column(
            children: [
              PlayerFieldWidget(widget.players, selectedNumber, selections),
              SizedBox(
                child: Stack(
                  children: [
                    for(int i = 0; i < widget.myNumbers.length; i++)
                      AnimatedPositioned(
                        child: MyCardWidget(widget.myNumbers[i], _handleSelectedNumberChanged),
                        top: widget.myNumbers[i] != selectedNumber ? height : isDetermined ? 0 : height / 2,
                        left: i * width + (widget.turns - widget.myNumbers.length) / widget.myNumbers.length * width * (i + 0.5),
                        width: width,
                        height: height,
                        duration: Duration(milliseconds: 200),
                      ),
                  ],
                ),
                height: height * 2,
              ),
              if(selectedNumber != null) ElevatedButton(
                onPressed: isDetermined ? null : _handleDeterminedNumber,
                child: Text("数字を確定する"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
              ),
              if(widget.myNumbers.length == 0) ElevatedButton(
                onPressed: _handleGameResart,
                child: Text("もう一度"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
              ),
              if(widget.myNumbers.length == 0) ElevatedButton(
                onPressed: _handleFinishGame,
                child: Text("ホームへ戻る"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                ),
              ),
            ]
          );
        }
      )
    );
  }
}
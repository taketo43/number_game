import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';


// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<Map<String, dynamic>>();

  void Function(Map<String, dynamic>) get addResponse => _socketResponse.sink.add;

  Stream<Map<String, dynamic>> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

IO.Socket socket = IO.io('http://localhost:3000',
      IO.OptionBuilder()
       .setTransports(['websocket']).build());

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen(){

    socket.onConnect((_) {
     print('connect');
     socket.emit('create', ['test', 'test_user']);
    });

    //When an event recieved from server, data is added to the stream
    socket.on('enter', (data){
      data['event'] = 'enter';
      streamSocket.addResponse(data);
    });

    socket.on('user_id', (data){
      data['event'] = 'user_id';
      streamSocket.addResponse(data);
    });

    socket.on('room list', (data){
      data['event'] = 'room list';
      streamSocket.addResponse(data);
    });

    socket.on('start', (data){
      data['event'] = 'start';
      streamSocket.addResponse(data);
    });

    socket.on('everyone selected', (data){
      data['event'] = 'everyone selected';
      streamSocket.addResponse(data);
    });

    socket.on('finish', (data){
      Map<String, dynamic> res = {
        'event': 'finish'
      };
      streamSocket.addResponse(res);
    });

    socket.on('err', (data){
      print(data);
    });

    socket.onDisconnect((_) => print('disconnect'));

}


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class LayoutSpectate extends StatefulWidget {
  const LayoutSpectate({Key? key}) : super(key: key);
  @override
  _LayoutSpectateState createState() => _LayoutSpectateState();
}

class _LayoutSpectateState extends State<LayoutSpectate> {
  String _status = 'Disconnected';
  String _message = '';
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.connectSocket();

    socketService.channel.stream.listen((message) {
      var decodedMessage = jsonDecode(message);
      if (decodedMessage['data']['connection'] == 201) {
        var encodeMessage = jsonEncode({
          'type': 'HANDSHAKE',
          'data': {'client': 'flutter'}
        });
        socketService.channel.sink.add(encodeMessage);
        setState(() {
          _status = 'Connected';
        });
      }
    }, onDone: () {
      setState(() {
        _status = 'Disconnected';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Client'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Connection Status: $_status'),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}

class SocketService {
  final wsUrl = Uri.parse('ws://192.168.18.148:80');
  late WebSocketChannel channel;

  Future<void> connectSocket() async {
    channel = WebSocketChannel.connect(wsUrl);
  }
}

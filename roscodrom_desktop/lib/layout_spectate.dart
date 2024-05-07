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
  List<dynamic> _players = [];
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    socketService.connectSocket();

    socketService.channel.stream.listen((message) {
      var decodedMessage = jsonDecode(message);
      print(decodedMessage);
      if (decodedMessage['data'] is Map<String, dynamic> &&
          decodedMessage['data'].containsKey('connection') &&
          decodedMessage['data']['connection'] == 201 &&
          _status != 'Connected') {
        var encodeMessage = jsonEncode({
          'type': 'HANDSHAKE',
          'data': {'client': 'flutter'}
        });
        socketService.channel.sink.add(encodeMessage);
        setState(() {
          _status = 'Connected';
        });
      }
      if (decodedMessage['type'] == 'GAME_INFO') {
        setState(() {
          for (var player in decodedMessage['data']['message']) {
            if (!_players.contains(player)) {
              _players.add(player);
            } else {
              _players[player]['points'] = player['points'];
            }
          }
        });
      }
      if (decodedMessage['type'] == 'TIEMPO_PARA_INICIO' &&
          decodedMessage['data']['enPartida'] == false) {
        setState(() {
          _players = [];
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
        title: Text('Spectate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Connection Status: $_status'),
            SizedBox(height: 20),
            Text(_message),
            if (_players.isNotEmpty)
              Column(
                children: _players
                    .map((player) => Text(
                        'Player: ${player['nickname']} - Score: ${player['points']}'))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class SocketService {
  final wsUrl = Uri.parse('ws://roscodrom2.ieti.site');
  late WebSocketChannel channel;

  Future<void> connectSocket() async {
    channel = WebSocketChannel.connect(wsUrl);
  }
}

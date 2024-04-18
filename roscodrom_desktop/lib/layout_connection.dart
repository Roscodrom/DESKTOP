import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConnectionScreenState createState() => ConnectionScreenState();
}

class ConnectionScreenState extends State<ConnectionScreen> {
  String ipAddress = '';
  String ipPort = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Connect to server'),
        ),
        body: Center(
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                  ),
                  onChanged: (value) {
                    setState(() {
                      ipAddress = value;
                    });
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'IP Port',
                  ),
                  onChanged: (value) {
                    setState(() {
                      ipPort = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  child: const Text('Connect'),
                  onPressed: () {
                    () => {};
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

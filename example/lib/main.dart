import 'package:flutter/material.dart';
import 'package:pusher_flutter/pusher_flutter.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _latestMessage;
  PusherConnectionState _connectionState;
  PusherFlutter pusher = new PusherFlutter("<your_key>");

  @override
  initState() {
    super.initState();
    pusher.onConnectivityChanged.listen((state) {
      setState(() => _connectionState = state);
    });
    _connectionState = PusherConnectionState.disconnected;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text('Plugin example app'),
          ),
          body: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text('Latest message ${_latestMessage.toString()}')
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              buildConnectRow(context)
            ],
          )),
    );
  }

  Widget buildConnectRow(BuildContext context) {
    switch (_connectionState) {
      case PusherConnectionState.connected:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(
                onPressed: disconnect, child: new Text("Disconnect"))
          ],
        );
      case PusherConnectionState.disconnected:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(onPressed: connect, child: new Text("Connect"))
          ],
        );
      case PusherConnectionState.disconnecting:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text("Disconnecting...")],
        );
      case PusherConnectionState.connecting:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text("Connecting...")],
        );
      case PusherConnectionState.reconnectingWhenNetworkBecomesReachable:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("Will reconnect when network becomes available")
          ],
        );
      case PusherConnectionState.reconnecting:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[new Text("Reconnecting...")],
        );
    }
    return new Text("Invalid state");
  }

  void connect() {
    pusher.connect();
    pusher.subscribe("test_channel", "test_event");
    pusher.onMessage("test_channel", "test_event").listen((map) {
      setState(() => _latestMessage = map);
    });
  }

  void disconnect() {
    pusher.disconnect();
  }
}
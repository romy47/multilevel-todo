import 'package:flutter/material.dart';

class Dasjboard extends StatefulWidget {
  @override
  _DasjboardState createState() => _DasjboardState();
}

class _DasjboardState extends State<Dasjboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Dashboard')),
      ),
      body: Center(
        child: Container(
          // scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            // Container
            children: [
              Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Today', style: TextStyle(fontSize: 17.0)),
                ),
              ),
              Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Streaks', style: TextStyle(fontSize: 17.0)),
                ),
              ),
              Card(
                elevation: 7,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('History', style: TextStyle(fontSize: 17.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

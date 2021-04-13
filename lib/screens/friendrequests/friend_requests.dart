//ToDo: Implement accepting friend requests

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/screens/friendrequests/friend_request_list.dart';
import 'package:go_out_v2/screens/friendrequests/sent_friend_requests_list.dart';
import 'package:go_out_v2/services/database.dart';

class FriendRequests extends StatefulWidget {

  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    FriendRequestList(),
    SentFriendRequestList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_up),
            label: 'Received Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down_outlined),
            label: 'Sent Requests',
          )

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
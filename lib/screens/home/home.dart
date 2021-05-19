import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_out_v2/screens/home/eventPlanning.dart';
import 'package:go_out_v2/screens/home/event_list.dart';
import 'package:go_out_v2/screens/home/friends_list.dart';
import 'package:go_out_v2/screens/home/settings_form.dart';
import 'package:go_out_v2/screens/profile/profile_page.dart';
import 'package:go_out_v2/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int currentIndex = 0;
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    EventList(),
    EventPlanning(),
    FriendsList(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 1000,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Go Out'),
        backgroundColor: Colors.red[400],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
              onPressed: () => _showSettingsPanel(),
              icon: Icon(Icons.info_sharp)),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                //navigate to the profile page here
                print('Clicked on profile editing button');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/pub.jpg'), fit: BoxFit.cover)),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.celebration,
              size: 40,
            ),
            label: 'Events',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mapMarkedAlt, size: 40),
            label: 'Plan',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.users, size: 40),
            label: 'Friends',
            backgroundColor: Colors.red,
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey.shade700,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}

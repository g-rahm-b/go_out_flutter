
import 'package:flutter/material.dart';
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
  @override
  final AuthService _auth = AuthService();
  int currentIndex = 0;
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    EventList(),
    EventPlanning(),
    FriendsList(),
    Container()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
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
              onPressed: () async{
                await _auth.signOut();
              },
              icon: Icon(Icons.logout),
            ),
            IconButton(onPressed: () => _showSettingsPanel(), icon: Icon(Icons.settings)),
            IconButton(
                icon: Icon(Icons.person),
                onPressed: (){
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
                  image: AssetImage('assets/pub.jpg'),
                  fit: BoxFit.cover
              )
          ),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),


        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_bar),
              label:'Events',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.celebration),
              label:'Plan',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Friends',
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
                backgroundColor: Colors.red
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          onTap: _onItemTapped,
        ),

      );

  }
}

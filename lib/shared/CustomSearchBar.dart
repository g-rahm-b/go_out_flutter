import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/friendsearch/friend_search_tile.dart';
import 'package:go_out_v2/services/database.dart';

import 'loading.dart';

class CustomSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search for New Friends"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            })
      ]),
      body: Center(
        child: Text(
          'Tap the search icon to begin searching for new friends!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,

          ),
        ),
      ),
      //drawer: Drawer(),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  //ToDo: Populate this list with actual data.
  final userSearch = ["pat", "Ashley", "John", "Graeme", "Ashley 2"];

  final recentUsers = ["pat", "fuck", "gay", "blah"];

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for app bar
    return [
      //onpress, should clear the current user Query
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //When the user hits enter, or the search icon, this is where the query will be built.
    //For now, might make more sense to build a new list here, with everything that contains
    //the user's query.
    print('I AM HERE');
    return FutureBuilder(
      future: DatabaseService().getUsersFromQuery(query),
      builder:
          (BuildContext context, AsyncSnapshot<List<CustomUser>> snapshot) {
        if (!snapshot.hasData) return Loading();
        final List<CustomUser> userQueryList = snapshot.data;

        return Expanded(
            child: ListView.builder(
                itemCount: userQueryList.length,
                itemBuilder: (context, index) {
                  if (userQueryList.length == 0) {
                    print('WE HAVE A HUGE ISSUE HERE');
                    return Text('No user name matches search');
                  }
                  return Dismissible(
                      key: Key(UniqueKey().toString()),
                      direction: DismissDirection.endToStart,
                      background: slideRightBackground(),
                      secondaryBackground: slideLeftBackground(),
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        // setState(() {
                        //   //Maybe do something here.
                        // });
                      },
                      child: FriendSearchTile(
                        //user: sentFriendRequests[index]
                        user: userQueryList[index],
                      ));
                }));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentUsers
        : userSearch.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.person),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            Text(
              " Remove Friend",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

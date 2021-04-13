//ToDo: Implement friend search
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/friendsearch/friend_search_list.dart';
import 'package:go_out_v2/services/database.dart';
import 'package:go_out_v2/shared/CustomSearchBar.dart';
import 'package:provider/provider.dart';

class FriendSearch extends StatefulWidget{
  @override
  _FriendSearch createState () => _FriendSearch();
}

class _FriendSearch extends State <FriendSearch> {
  @override
  Widget build(BuildContext context) {

    return CustomSearchBar();

    return StreamProvider<List<CustomUser>>.value(
        value: DatabaseService().listOfAllUsers,
        initialData: [],
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text('Find Friends'),
            backgroundColor: Colors.red[400],
            elevation: 0.0,
            ),
          body: FriendSearchList()
        ),
    );
  }
}

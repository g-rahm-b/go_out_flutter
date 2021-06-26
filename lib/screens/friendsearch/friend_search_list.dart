import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_out/shared/CustomSearchBar.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class FriendSearchList extends StatefulWidget {
  @override
  _FriendSearchListState createState() => _FriendSearchListState();
}

class _FriendSearchListState extends State<FriendSearchList> {
  SearchBar searchBar;
  @override
  Widget build(BuildContext context) {
    return CustomSearchBar();

    // final users = Provider.of<List<CustomUser>>(context) ??[];
    // final String currentUid = AuthService().fetchUid();

    // //ToDo: Need to remove friends from this list
    // return ListView.builder(
    //     itemCount: users.length,
    //     itemBuilder: (context, index){
    //       print('Auth UID is: $currentUid');
    //       print('current index is: $index');
    //       print('list length is: ${users.length}');
    //
    //       //Want to make sure the user isn't in this list. If it is, remove it.
    //       //If we remove an item, want to make sure we don't index out of bounds.
    //       if(users.length <= index)
    //       {
    //           return null;
    //       }
    //       //Otherwise, check to see if our person is in here.
    //       else if(users[index].uid == currentUid)
    //       {
    //         print('in the if: ${users[index].uid}');
    //         print('user name is: ${users[index].name}');
    //         users.removeAt(index);
    //         print('user removed');
    //         //index = index -1;
    //         // index = index +1;
    //         // return FriendSearchTile(user:users[index+1]);
    //        }
    //
    //         print('in the else: ${users[index].uid}');
    //         print('user name is: ${users[index].name}');
    //         print('====================================');
    //         return FriendSearchTile(user: users[index]);
    //
    //     },
    // );
  }
}

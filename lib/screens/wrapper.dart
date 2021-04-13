import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/authentication/authenticate.dart';
import 'package:go_out_v2/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Checking the value of the user.
    //If there's a logout, this will be null, otherwise, it will be the user.
    final user = Provider.of<CustomUser>(context);
    //return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}

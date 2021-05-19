import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_out_v2/models/custom_user.dart';
import 'package:go_out_v2/screens/wrapper.dart';
import 'package:go_out_v2/services/auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

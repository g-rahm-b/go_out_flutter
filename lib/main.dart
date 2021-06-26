import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_out/models/custom_user.dart';
import 'package:go_out/screens/wrapper.dart';
import 'package:go_out/services/auth.dart';
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
        title: 'GoOut',
        theme: ThemeData(
            brightness: Brightness.dark,
            visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
            primarySwatch: Colors.purple),
        home: Wrapper(),
      ),
    );
  }
}

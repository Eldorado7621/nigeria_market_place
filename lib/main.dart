
import 'package:flutter/material.dart';

import 'MyApp.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyNmp());
}

class MyNmp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyApp.id,
      routes: {
        MyApp.id:(context)=>MyApp(),

      },
    );
  }
}


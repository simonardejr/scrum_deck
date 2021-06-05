import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_form.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: SprintModule(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/sprintForm': (_) => SprintForm()
      },
    );
  }
}

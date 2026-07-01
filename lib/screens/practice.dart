import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Practicewidget extends StatefulWidget {
  const Practicewidget({super.key});

  @override
  State<Practicewidget> createState() => _PracticewidgetState();
}

class _PracticewidgetState extends State<Practicewidget> {
  int counter=0;
  void increasecount()
  {
    setState(() {
      counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
          children: [
            Text("Set state demonsatration"),
            ElevatedButton(onPressed: increasecount,child: const Icon(Icons.add)),
            Text("$counter")
          ],
        )
      ),
    );
  }
}
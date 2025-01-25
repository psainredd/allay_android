import 'package:allay/src/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AllayTextField(
            label: "Blah",
          ),
          AllayTextField(
            label: "Blah1",
          )
        ],
      ),
    );
  }

}
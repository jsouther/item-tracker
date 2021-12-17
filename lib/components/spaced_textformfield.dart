import 'package:flutter/material.dart';

class SpacedTextFormField extends StatelessWidget {

  final double height;
  final String text;
  final void Function(dynamic) onSaved;
  final String Function(dynamic) validator;


  const SpacedTextFormField({Key key, this.text, this.height = 8.0, this.onSaved, this.validator}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: text,
                    border: OutlineInputBorder(),
                  ),
                  onSaved: onSaved,
                  validator: validator,
                )
      ]
    );
  }
}
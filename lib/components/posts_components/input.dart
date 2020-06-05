import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Input extends StatelessWidget {
  String comment;
  final _formKey = GlobalKey<FormState>();
  final addComment;
  final hintText;
  final labelText;

  Input(this.addComment, this.hintText, this.labelText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.purple,
      validator: (val) => val.isEmpty ? 'Write a comment' : null,
      onChanged: (val) {
        comment = val;
      },
      decoration: InputDecoration(
          focusColor: Colors.black12,
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          hintText: this.hintText,
          labelText: this.labelText,
          labelStyle: TextStyle(color: Colors.purple),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.purple,
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                this.addComment(comment);
              }
            },
          )),
    );
  }
}

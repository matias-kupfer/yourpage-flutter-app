import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Input extends StatelessWidget {
  final postId;
  String comment;
  final _formKey = GlobalKey<FormState>();
  final addComment;
  final position;
  final hintText;
  final labelText;

  Input(this.postId, this.addComment, this.position, this.hintText,
      this.labelText);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
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
                  this.addComment(position, comment);
                }
              },
            )),
      ),
    );
  }
}

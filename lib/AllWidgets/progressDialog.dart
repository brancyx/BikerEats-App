import "package:flutter/material.dart";

/// Shows progress of action
class ProgressDialog extends StatelessWidget
{
  String message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.lightGreen,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),

        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(width: 6.0),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
              SizedBox(width: 26.0),
              Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 14.0),
              )],
              )
          ),
        ),
      );
  }
}
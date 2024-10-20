import 'package:flutter/material.dart';

showFeedbackSnackbar(BuildContext context,{required String message}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontSize: 13, color: Colors.white),
            )));

}
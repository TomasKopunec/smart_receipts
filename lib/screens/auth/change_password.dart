import 'package:flutter/material.dart';

import 'authentication_screen.dart';

class ChangePassword extends StatefulWidget {
  final Function(AuthState state) func;

  const ChangePassword({super.key, required this.func});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email"),
          TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8))),
          Text("Reset instructions will be sent to the provided email"),
          ElevatedButton(
              onPressed: () {
                // TODO Sent change password stuff to email
              },
              child: Text('RESET'))
        ],
      ),
    );
  }
}

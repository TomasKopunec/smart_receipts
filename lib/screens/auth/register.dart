import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/auth/authentication_screen.dart';

class Register extends StatefulWidget {
  final Function(AuthState state) func;

  const Register({super.key, required this.func});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
          Text("Password"),
          TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8))),
          Text("Repeat Password"),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password again',
                contentPadding: EdgeInsets.symmetric(horizontal: 8)),
          ),
          ElevatedButton(onPressed: () {}, child: Text("SIGN UP")),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            children: [
              Text('Already a user?'),
              TextButton(
                  onPressed: () {
                    widget.func(AuthState.login);
                  },
                  child: Text('LOGIN'))
            ],
          )
        ],
      ),
    );
  }
}

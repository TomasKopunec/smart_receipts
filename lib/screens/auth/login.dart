import 'package:flutter/material.dart';

import 'authentication_screen.dart';

class Login extends StatefulWidget {
  final Function(AuthState state) func;

  const Login({super.key, required this.func});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;

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
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4),
                    value: _rememberMe,
                    onChanged: (val) => setState(() {
                          _rememberMe = val!;
                        })),
                SizedBox(width: 6),
                Text('Remember me?')
              ]),
          ElevatedButton(onPressed: () {}, child: Text('LOGIN')),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    widget.func(AuthState.changePassword);
                  },
                  child: Text('Forgot password?'))
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Row(
            children: [
              Text('Need an account?'),
              TextButton(
                  onPressed: () {
                    widget.func(AuthState.register);
                  },
                  child: Text('SIGN UP'))
            ],
          )
        ],
      ),
    );
  }
}

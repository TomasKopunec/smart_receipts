import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/screens/auth/change_password.dart';
import 'package:smart_receipts/screens/auth/login.dart';
import 'package:smart_receipts/screens/auth/register.dart';

enum AuthState {
  register('Register'),
  login('Login'),
  changePassword('Change Password');

  final String name;

  const AuthState(this.name);

  @override
  String toString() {
    return name;
  }
}

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  AuthState _state = AuthState.register;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(top: SizeHelper.getTopPadding(context)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeHelper.getScreenWidth(context) * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getHeader(),
                  getScreen(_state),
                ],
              ),
            )));
  }

  Widget getHeader() {
    final textWidget = Container(
      //  color: Colors.blue.withOpacity(0.2),
      padding: EdgeInsets.only(
        top: SizeHelper.getScreenHeight(context) * 0.03,
        bottom: SizeHelper.getScreenHeight(context) * 0.03,
      ),
      child: Text(
        _state.toString(),
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).indicatorColor,
            fontWeight: FontWeight.w600),
      ),
    );

    if (_state != AuthState.changePassword) {
      return textWidget;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () => changeScreen(AuthState.login),
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Theme.of(context).primaryColor),
          const  SizedBox(width: 8),
        textWidget,
      ],
    );
  }

  Widget getScreen(AuthState state) {
    switch (state) {
      case AuthState.register:
        return Register(func: changeScreen);
      case AuthState.login:
        return Login(func: changeScreen);
      case AuthState.changePassword:
        return ChangePassword(func: changeScreen);
    }
  }

  void changeScreen(AuthState state) {
    setState(() {
      _state = state;
    });
  }
}

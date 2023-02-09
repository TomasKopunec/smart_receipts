import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';

abstract class Loader {
  AuthProvider? _auth;
  UserProvider? _users;
  ReceiptsProvider? _receipt;
  SettingsProvider? _settings;
  BuildContext context;

  Loader({required this.context, required Function onLoad}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _auth = Provider.of<AuthProvider>(context, listen: false);
      _users = Provider.of<UserProvider>(context, listen: false);
      _receipt = Provider.of<ReceiptsProvider>(context, listen: false);
      _settings = Provider.of<SettingsProvider>(context, listen: false);
      initialise();
      onLoad();
    });
  }

  void initialise();

  AuthProvider get auth {
    return _auth!;
  }

  UserProvider get users {
    return _users!;
  }

  ReceiptsProvider get receipt {
    return _receipt!;
  }

  SettingsProvider get settings {
    return _settings!;
  }

  void log(String title, String body) {
    print("[$runtimeType] ${title.toUpperCase()}: $body");
  }
}

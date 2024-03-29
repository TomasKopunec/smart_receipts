import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/returns/returns_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/utils/logger.dart';

abstract class Loader {
  final Logger logger = Logger(Loader);
  AuthProvider? _auth;
  UserProvider? _users;
  ReceiptsProvider? _receipt;
  SettingsProvider? _settings;
  ReturnsProvider? _returns;
  BuildContext context;

  Loader({required this.context, required Function onLoad}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _auth = Provider.of<AuthProvider>(context, listen: false);
      _users = Provider.of<UserProvider>(context, listen: false);
      _receipt = Provider.of<ReceiptsProvider>(context, listen: false);
      _settings = Provider.of<SettingsProvider>(context, listen: false);
      _returns = Provider.of<ReturnsProvider>(context, listen: false);
      final result = await initialise();
      if (result) {
        onLoad();
      } else {
        log("Error", "Initialization failed!");
      }
    });
  }

  Future<bool> initialise();

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

  ReturnsProvider get returns {
    return _returns!;
  }

  void log(String name, String message) {
    logger.log(message, name: name);
  }
}

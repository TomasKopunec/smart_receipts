import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(BuildContext context, AppSnackBarBuilder builder) {
    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
    ScaffoldMessenger.of(context).showSnackBar(builder.build());
  }
}

class AppSnackBarBuilder {
  String _text = "";
  Function _action = () {};
  String _actionLabel = "";
  Duration _duration = const Duration(seconds: 2);
  bool _hasAction = false;

  AppSnackBarBuilder withText(String text) {
    _text = text;
    return this;
  }

  AppSnackBarBuilder withAction(Function action, String actionLabel) {
    _action = action;
    _actionLabel = actionLabel;
    _hasAction = true;
    return this;
  }

  AppSnackBarBuilder withDuration(Duration duration) {
    _duration = duration;
    return this;
  }

  SnackBar build() {
    return SnackBar(
      duration: _duration,
      action: _hasAction
          ? SnackBarAction(
              label: _actionLabel,
              onPressed: () {
                _action();
              },
            )
          : null,
      content: Text(_text),
    );
  }
}

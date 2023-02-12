import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_receipts/helpers/qr_code_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/receipts/receipts_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/widgets/toggle_switch.dart';
import '../../tab_control/abstract_tab_screen.dart';

class ReceiveReceiptScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Receive Receipt';
  }

  @override
  IconData getIcon() {
    return Icons.qr_code_scanner_rounded;
  }

  @override
  State<StatefulWidget> createState() => _ReceiveReceiptScreenState();

  @override
  String getIconTitle() {
    return 'Receive';
  }
}

class _ReceiveReceiptScreenState extends State<ReceiveReceiptScreen> {
  late final Timer timeTimer;

  String _timeString = DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now());

  @override
  void initState() {
    _timeString = _formatTime(DateTime.now());

    timeTimer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _getTimeString());

    // Start a background thread that will listen to any changes
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<ReceiptsProvider>(context, listen: false).startListening(
        context,
        Provider.of<UserProvider>(context, listen: false),
        auth.token!.accessToken,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    timeTimer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm:ss').format(dateTime);
  }

  _getTimeString() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);

    setState(() {
      _timeString = formattedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(screenBody: Center(
      child: Consumer2<SettingsProvider, AuthProvider>(
        builder: (ctx, settings, auth, _) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getQRCodeView(context, settings, auth),
                const SizedBox(height: 8),
                getSwitchWidget(context, settings)
              ]);
        },
      ),
    ));
  }

  Widget getQrCode(SettingsProvider settings, AuthProvider auth, String email) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: QrCodeHelper.getReceiveQrCodeWidget(
          context, email, settings.digitalOnly),
    );
  }

  Widget getQRCodeView(context, SettingsProvider settings, AuthProvider auth) {
    final double qrCodeSize = SizeHelper.getScreenWidth(context) * 0.9;
    final double padding =
        (SizeHelper.getScreenWidth(context) - qrCodeSize) * 0.5;

    return Consumer<UserProvider>(
      builder: (ctx, users, _) => Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        child: Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: getQrCode(settings, auth, users.user!.email),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      users.user!.email,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.cardSize)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _timeString,
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.regularLarge)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getSwitchWidget(context, SettingsProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Digital receipt only',
          style: TextStyle(
              fontSize: SizeHelper.getFontSize(context, size: FontSize.large),
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 2),
        ToggleSelection(
          defaultState: provider.digitalOnly,
          onToggle: (value) {
            provider.setDigitalOnly(value);
            print('Digital receipt only ${value ? "enabled" : "disabled"}');
          },
        )
      ],
    );
  }
}

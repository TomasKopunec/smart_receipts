import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_receipts/helpers/qr_code_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';
import 'package:smart_receipts/widgets/toggle_switch.dart';
import '../tab_control/abstract_tab_screen.dart';

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

  Widget getQrCode(SettingsProvider settings, AuthProvider auth) {
    final double qrCodeSize = SizeHelper.getScreenWidth(context) * 0.8;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: QrImage(
        data: QrCodeHelper.getReceiveReceiptQrCode(
          "email@email.com",
          settings.digitalOnly,
        ),
        padding: EdgeInsets.zero,
        version: QrVersions.auto,
        constrainErrorBounds: true,
        size: qrCodeSize,
        foregroundColor: Theme.of(context).indicatorColor,
        backgroundColor: Colors.transparent,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        gapless: false,
      ),
    );
  }

  Widget getQRCodeView(context, SettingsProvider settings, AuthProvider auth) {
    final double qrCodeSize = SizeHelper.getScreenWidth(context) * 0.9;
    final double padding =
        (SizeHelper.getScreenWidth(context) - qrCodeSize) * 0.5;

    return Card(
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
              child: getQrCode(settings, auth),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tomas Kopunec',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.cardSize)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    softWrap: true,
                    'vpke9ePEgAgySvFFwNsTc8/LZa03Ow==',
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

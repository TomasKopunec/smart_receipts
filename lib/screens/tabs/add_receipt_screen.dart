import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import '../tab_control/abstract_tab_screen.dart';

class AddReceiptScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Receive Receipt';
  }

  @override
  IconData getIcon() {
    return Icons.qr_code_scanner_rounded;
  }

  @override
  State<StatefulWidget> createState() => _AddReceiptScreenState();

  @override
  String getIconTitle() {
    return 'Receive';
  }
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  bool _isDigitalOnly = true;

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
        screenBody: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getQRCodeView(context),
            const SizedBox(height: 8),
            getSwitchWidget(context)
          ]),
    ));
  }

  Widget getQRCodeView(context) {
    final double qrCodeSize = SizeHelper.getScreenWidth(context) * 0.9;
    final double padding =
        (SizeHelper.getScreenWidth(context) - qrCodeSize) * 0.5;

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  height: qrCodeSize,
                  width: qrCodeSize,
                  child: Icon(Icons.qr_code_2, size: qrCodeSize)),
            ),
            const SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tomas Kopunec',
                    style: TextStyle(
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.largest),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    softWrap: true,
                    'vpke9ePEgAgySvFFwNsTc8/LZa03Ow==',
                    style: TextStyle(
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.regularLarge),
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSwitchWidget(context) {
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
        Transform.scale(
          scale: 1.25,
          child: Switch(
              activeColor: Theme.of(context).primaryColor,
              value: _isDigitalOnly,
              onChanged: (val) {
                setState(() {
                  _isDigitalOnly = val;
                });
              }),
        )
      ],
    );
  }
}

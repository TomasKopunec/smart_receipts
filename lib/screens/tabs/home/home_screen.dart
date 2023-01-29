import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/screens/auth/authentication_screen.dart';
import 'package:smart_receipts/screens/tabs/home/recent_receipts.dart';
import 'package:smart_receipts/screens/tabs/home/sustainability_widget.dart';

import '../../../utils/snackbar_builder.dart';
import '../../tab_control/abstract_tab_screen.dart';

class HomeScreen extends AbstractTabScreen {
  @override
  String getTitle() {
    return 'Home';
  }

  @override
  IconData getIcon() {
    return Icons.home;
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

  @override
  String getIconTitle() {
    return 'Home';
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSigningOut = false;

  @override
  Widget build(BuildContext context) {
    return widget.getScreen(
        headerBody: headerBody, screenBody: screenBody, action: action);
  }

  Widget get screenBody {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SustainabilityWidget(),
        RecentReceipts(),
      ],
    );
  }

  Widget get action {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        return _isSigningOut
            ? Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Transform.scale(
                  scale: 0.75,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            : TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor.withOpacity(0.2)),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  final result = await auth.signOut();

                  setState(() {
                    _isSigningOut = false;
                  });

                  if (!mounted) {
                    return;
                  }

                  if (!result) {
                    AppSnackBar.show(context,
                        AppSnackBarBuilder().withText("Sign Out failed!"));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AuthenticationScreen(),
                    ));
                  }

                  // TODO handle backend Sign Out
                  print("[API] Sign Out");
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: SizeHelper.getFontSize(context,
                          size: FontSize.regular)),
                ));
      },
    );
  }

  Widget get headerBody {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.person,
              color: Theme.of(context).canvasColor,
            ),
          ),
          const SizedBox(width: 16),
          Text('Hello, ',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w300)),
          Text('Tomas!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w500))
        ],
      ),
    );
  }
}

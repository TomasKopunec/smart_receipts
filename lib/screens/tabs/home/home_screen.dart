import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/requests/request_helper.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/user.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/screens/tabs/home/recent_receipts.dart';
import 'package:smart_receipts/screens/tabs/home/sustainability_widget.dart';

import '../../tab_control/abstract_tab_screen.dart';

class HomeScreen extends AbstractTabScreen {
  const HomeScreen({super.key});

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
    return Consumer<UserProvider>(
        builder: (ctx, user, _) => widget.getScreen(
              headerBody: getHeaderBody(user.user),
              screenBody: getScreenBody(user.user),
              action: action,
            ));
  }

  Widget getScreenBody(User? user) {
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SustainabilityWidget(isLoading: user == null),
          RecentReceipts(isLoading: user == null),
        ],
      ),
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
                  handleLogout(auth);
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

  void handleLogout(AuthProvider auth) async {
    setState(() {
      _isSigningOut = true;
    });

    // Wait for response
    final result = await auth.logout();

    setState(() {
      _isSigningOut = false;
    });

    if (!result && mounted) {
      RequestHelper.showNetworkErrorDialog(context, err: 'Failed to log-out.');
    }
    auth.setToken(null);
  }

  Widget getHeaderBody(User? user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: SizeHelper.getScreenHeight(context) * 0.032,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).canvasColor,
                  size: SizeHelper.getScreenHeight(context) * 0.03,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: getEmail(user),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget getEmail(User? user) {
    if (user == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile loading',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w300)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w300)),
          const SizedBox(height: 3),
          AutoSizeText(
            user.email,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      );
    }
  }
}

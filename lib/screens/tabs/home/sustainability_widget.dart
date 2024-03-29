import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/screens/tabs/home/grid_card.dart';
import 'package:smart_receipts/widgets/section.dart';
import 'package:smart_receipts/widgets/shimmer_widget.dart';

class SustainabilityWidget extends StatefulWidget {
  final bool isLoading;

  const SustainabilityWidget({super.key, required this.isLoading});

  @override
  State<SustainabilityWidget> createState() => _SustainabilityWidgetState();
}

class _SustainabilityWidgetState extends State<SustainabilityWidget> {
  late final UserProvider user;

  @override
  void initState() {
    user = Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Sustainability',
      body: getGrid(),
    );
  }

  Widget getGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      padding: EdgeInsets.zero,
      childAspectRatio: 4 / 3,
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      children: gridCards,
    );
  }

  List<Widget> get gridCards {
    final list = [paper, co2, trees, water];

    return widget.isLoading
        ? list.map((e) => ShimmerWidget(child: e)).toList()
        : list;
  }

  GridCard get paper {
    return GridCard(
        icon: Icons.auto_awesome_motion_rounded,
        number: user.user == null ? "" : user.user!.count.toStringAsFixed(0),
        title: 'No. of digital receipts');
  }

  GridCard get co2 {
    String number = "";
    final count = user.user == null ? -1 : user.user!.count;
    if (count != -1) {
      final double result = count * 2.5;
      number = (result - result.floor() == 0)
          ? result.toStringAsFixed(0)
          : result.toStringAsFixed(1);
    }

    return GridCard(
      icon: Icons.eco_rounded,
      number: number,
      title: 'CO2 Saved',
      unit: 'g',
    );
  }

  GridCard get trees {
    return GridCard(
      icon: Icons.delete_sweep_rounded,
      number:
          user.user == null ? "" : (user.user!.count / 3).toStringAsFixed(0),
      title: 'Waste Saved',
      unit: 'g',
    );
  }

  GridCard get water {
    return GridCard(
      icon: Icons.water_drop_rounded,
      number:
          user.user == null ? "" : (user.user!.count / 7).toStringAsFixed(1), //
      unit: 'L',
      title: 'Water Saved',
    );
  }
}

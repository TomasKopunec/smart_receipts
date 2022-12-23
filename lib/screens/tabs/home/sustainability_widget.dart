import 'package:flutter/material.dart';
import 'package:smart_receipts/screens/tabs/home/grid_card.dart';
import 'package:smart_receipts/widgets/section.dart';

class SustainabilityWidget extends StatefulWidget {
  const SustainabilityWidget();

  @override
  State<SustainabilityWidget> createState() => _SustainabilityWidgetState();
}

class _SustainabilityWidgetState extends State<SustainabilityWidget> {
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
      children: [paper, co2, trees, water],
    );
  }

  GridCard get paper {
    return const GridCard(
        icon: Icons.auto_awesome_motion_rounded,
        number: 10,
        title: 'No. of digital receipts');
  }

  GridCard get co2 {
    return const GridCard(
      icon: Icons.eco_rounded,
      number: 165,
      title: 'CO2 Saved',
      unit: 'g',
    );
  }

  GridCard get trees {
    return const GridCard(
      icon: Icons.forest_rounded,
      number: 3,
      title: 'Trees Saved',
    );
  }

  GridCard get water {
    return const GridCard(
      icon: Icons.water_drop_rounded,
      number: 5,
      unit: 'L',
      title: 'Water Saved',
    );
  }
}

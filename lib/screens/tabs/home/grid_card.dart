import 'package:flutter/material.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

class GridCard extends StatelessWidget {
  final String number;
  final String? unit;
  final IconData icon;
  final String title;

  const GridCard({
    required this.number,
    this.unit = '',
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${number}$unit',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: SizeHelper.getFontSize(context,
                              size: FontSize.cardSize)),
                    ),
                    Icon(
                      icon,
                      color: Theme.of(context).indicatorColor,
                      size:
                          SizeHelper.getIconSize(context, size: IconSize.large),
                    )
                  ],
                ),
              ),
              Text(title,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w300))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/providers/settings_provider.dart';

class CurrencyDropdownButton extends StatefulWidget {
  final double width;
  final Color backgroundColor;
  final Color textColor;

  CurrencyDropdownButton(
      {required this.width,
      required this.textColor,
      required this.backgroundColor});

  @override
  State<CurrencyDropdownButton> createState() => _CurrencyDropdownButtonState();
}

class _CurrencyDropdownButtonState extends State<CurrencyDropdownButton> {
  late Currency _selected;

  double get iconSize {
    return SizeHelper.getScreenWidth(context) * 0.09;
  }

  @override
  void initState() {
    _selected = Currency.pound;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: widget.backgroundColor),
          child: PopupMenuButton(
            constraints:
                BoxConstraints(maxWidth: widget.width, minWidth: widget.width),
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            initialValue: _selected,
            itemBuilder: (_) {
              List<PopupMenuEntry<Currency>> widgets = [];

              for (final item in Currency.values) {
                widgets.add(getListItem(item));
                widgets.add(const PopupMenuDivider(
                  height: 0,
                ));
              }

              return widgets;
            },
            onSelected: (Currency value) {
              setState(() {
                _selected = value;
              });

              Provider.of<SettingsProvider>(context, listen: false)
                  .selectCurrency(_selected);
            },
            child: SizedBox(
              width: widget.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: InkWell(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Image.asset(
                        'icons/currency/${_selected.code}.png',
                        package: 'currency_icons',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${_selected.code.toUpperCase()} (${_selected.currency.toUpperCase()})',
                          style: TextStyle(
                              color: Colors.black.withOpacity(1),
                              fontSize: SizeHelper.getFontSize(context,
                                  size: FontSize.regular)),
                        ),
                        Text(
                          _selected.name,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: SizeHelper.getFontSize(context,
                                  size: FontSize.regular)),
                        )
                      ],
                    ),
                    Icon(Icons.arrow_drop_down, color: widget.textColor)
                  ],
                )),
              ),
            ),
          )),
    );
  }

  PopupMenuItem<Currency> getListItem(Currency currency) {
    return PopupMenuItem<Currency>(
      height: 0,
      value: currency,
      child: getCurrencyView(currency),
    );
  }

  Widget getCurrencyView(Currency currency) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      leading: SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(
          'icons/currency/${currency.code}.png',
          package: 'currency_icons',
        ),
      ),
      trailing: Text(
        currency.currency.toUpperCase(),
        style: TextStyle(
            fontSize:
                SizeHelper.getFontSize(context, size: FontSize.regularLarge)),
      ),
      title: Text(
        currency.code.toUpperCase(),
      ),
      subtitle: Text(
        currency.name,
      ),
    );
  }
}

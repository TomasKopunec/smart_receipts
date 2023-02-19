import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/product/product.dart';
import 'package:smart_receipts/providers/settings/settings_provider.dart';

import '../../helpers/currency_helper.dart';

class Selection {
  bool enabled;
  Product product;
  int quantity;

  Selection(this.enabled, this.product, this.quantity);

  @override
  int get hashCode {
    return product.sku.hashCode;
  }

  @override
  bool operator ==(o) => o is Selection && product.sku == o.product.sku;
}

class ReturnSelection extends StatefulWidget {
  final Product product;
  final int size;
  final Function(Selection) onSelect;
  final bool enabled;
  final Currency currency;

  const ReturnSelection({
    super.key,
    required this.product,
    required this.size,
    required this.onSelect,
    required this.enabled,
    required this.currency,
  });

  @override
  State<ReturnSelection> createState() => _ReturnSelectionState();
}

class _ReturnSelectionState extends State<ReturnSelection> {
  bool _isSelected = false;
  late final Selection pair;

  @override
  void initState() {
    pair = Selection(false, widget.product, 1);
    super.initState();
  }

  void _select(val) {
    setState(() {
      if (_isSelected) {
        _isSelected = false;
        pair.enabled = false;
      } else {
        _isSelected = true;
        pair.enabled = true;
        pair.quantity = 1;
      }
      widget.onSelect(pair);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bckg = _isSelected
        ? Theme.of(context).primaryColor.withOpacity(0.1)
        : Colors.white;

    if (!widget.enabled) {
      bckg = Colors.black.withOpacity(0.08);
    }

    return Column(
      key: ValueKey(widget.product.sku),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: bckg,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                value: _isSelected,
                onChanged: !widget.enabled
                    ? null
                    : (val) {
                        _select(val);
                      }),
            title: Text(widget.product.name),
            subtitle: Consumer<SettingsProvider>(
                builder: (ctx, settings, _) => Text(CurrencyHelper.getFormatted(
                    price: widget.product.price,
                    originCurrency: widget.currency,
                    targetCurrency: settings.currency))),
            trailing: _isSelected ? quantity : null,
          ),
        ),
        Divider(
          color: widget.enabled
              ? Theme.of(context).primaryColor.withOpacity(0.5)
              : Colors.black.withOpacity(0.5),
          height: 0,
          thickness: 1,
          endIndent: 0,
          indent: 0,
        ),
      ],
    );
  }

  Widget get quantity {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select Quantity: ",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
              value: pair.quantity,
              borderRadius: BorderRadius.circular(8),
              iconSize: SizeHelper.getIconSize(context, size: IconSize.regular),
              iconEnabledColor: Theme.of(context).primaryColor,
              isDense: true,
              elevation: 2,
              items: getItemsList()
                  .map((e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text(e.toString()),
                      ))
                  .toList(),
              onChanged: !widget.enabled
                  ? null
                  : (val) {
                      setState(() {
                        pair.quantity = val!;
                        widget.onSelect(pair);
                      });
                    }),
        ],
      ),
    );
  }

  List<int> getItemsList() {
    List<int> res = [];
    for (int i = 1; i <= widget.size; i++) {
      res.add(i);
    }
    return res;
  }
}

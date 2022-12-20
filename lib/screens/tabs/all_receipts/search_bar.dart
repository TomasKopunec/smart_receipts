import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_receipts/helpers/color_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/providers/receipts_provider.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final color = ColorHelper.APP_COLOR;

  final _controller = TextEditingController();

  bool get isEmpty {
    return _controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiptsProvider>(
      builder: (_, provider, child) {
        return TextFormField(
          onChanged: (value) {
            provider.setFilterValue(value);
          },
          controller: _controller,
          cursorColor: color,
          // maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            filled: true,
            alignLabelWithHint: true,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            prefixIconConstraints: const BoxConstraints(),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 10, right: 4),
              child: Icon(
                Icons.search,
                color: color,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 4, right: 10),
              child: AnimatedRotation(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 1500),
                turns: isEmpty ? 0 : 0.5,
                child: AnimatedOpacity(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 500),
                  opacity: isEmpty ? 0 : 1,
                  child: GestureDetector(
                    onTap: () => _controller.clear(),
                    child: Icon(
                      Icons.clear,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
            hintText: 'Receipt\'s ${provider.searchKey.toString()}',
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: color.withOpacity(0.5), width: 1.25),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color, width: 2.25),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchBar extends StatefulWidget {
  final Color color;

  const SearchBar({required this.color});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: widget.color,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        isDense: true,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 4),
          child: Icon(
            Icons.search,
            color: widget.color,
          ),
        ),
        hintText: 'Input text',
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: widget.color.withOpacity(0.5), width: 1.25),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.color, width: 2.25),
        ),
      ),
    );
  }
}

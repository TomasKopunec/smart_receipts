import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onValueChanged;
  final Function hintText;

  const SearchBar(
      {super.key, required this.hintText, required this.onValueChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState<T> extends State<SearchBar> {
  final _controller = TextEditingController();

  bool get isEmpty {
    return _controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return TextFormField(
      onChanged: (value) => widget.onValueChanged(value),
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
                onTap: () {
                  _controller.clear();
                  widget.onValueChanged(_controller.text);
                },
                child: Icon(
                  Icons.clear,
                  color: color,
                ),
              ),
            ),
          ),
        ),
        hintText: widget.hintText(),
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color.withOpacity(0.5), width: 1.25),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.25),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

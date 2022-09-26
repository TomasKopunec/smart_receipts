import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final String searchKey;
  final Color color;
  final Function(String) filter;

  const SearchBar(
      {required this.searchKey, required this.color, required this.filter});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  bool get isEmpty {
    return _controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      setState(() => widget.filter(_controller.text));
    });

    return TextFormField(
      controller: _controller,
      cursorColor: widget.color,
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
            color: widget.color,
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
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
        hintText: 'Receipt\'s ${widget.searchKey}',
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: widget.color.withOpacity(0.5), width: 1.25),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.color, width: 2.25),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

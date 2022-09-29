import 'package:flutter/material.dart';

class DatatableHeader {
  final String text;
  final String value;
  final bool sortable;
  final bool editable;
  bool show;
  final TextAlign textAlign;
  final int flex;

  DatatableHeader({
    required this.text,
    required this.value,
    this.textAlign = TextAlign.center,
    this.sortable = false,
    this.show = true,
    this.editable = false,
    this.flex = 1,
  });

  factory DatatableHeader.fromMap(Map<String, dynamic> map) => DatatableHeader(
        text: map['text'],
        value: map['value'],
        sortable: map['sortable'],
        show: map['show'],
        textAlign: map['textAlign'],
        flex: map['flex'],
      );
  Map<String, dynamic> toMap() => {
        "text": text,
        "value": value,
        "sortable": sortable,
        "show": show,
        "textAlign": textAlign,
        "flex": flex,
      };
}

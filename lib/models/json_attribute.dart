class JsonAttribute {
  final String _attribute;
  final dynamic _value;

  JsonAttribute(this._attribute, this._value);

  String get attribute {
    return _attribute;
  }

  dynamic get value {
    return _value;
  }
}

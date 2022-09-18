import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:intl/intl.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:smart_receipts/helpers/size_helper.dart';
import 'package:smart_receipts/models/receipt_column.dart';
import 'package:smart_receipts/widgets/table_header.dart';

class ReceiptTable extends StatefulWidget {
  final Color headerColor;

  const ReceiptTable({required this.headerColor});

  @override
  State<ReceiptTable> createState() => _ReceiptTableState();
}

class _ReceiptTableState extends State<ReceiptTable> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();

  List<Map<String, dynamic>> _generateData({int n: 100}) {
    final List source = List.filled(n, Random.secure());
    List<Map<String, dynamic>> temps = [];
    var i = 1;
    print(i);
    // ignore: unused_local_variable
    for (var data in source) {
      temps.add({
        'store_name': 'Store $i',
        'amount': '${(i * 10.0).toString()}\$',
        'date':
            DateFormat.yMd().format(DateTime.now().subtract(Duration(days: i))),
        'location': 'London, UK',
        'category': 'Fashion',
        'expiration': DateFormat.yMd().format(DateTime.now()
            .subtract(Duration(days: i))
            .add(Duration(days: 365))),
        'sku': '$i\000$i',
        'uid': i,
        'status': 'Active'
      });
      i++;
    }
    return temps;
  }

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 1)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: random.nextInt(10000)));
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
        _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
                .toString()
                .toLowerCase()
                .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(
          text: "Store name",
          value: "store_name",
          show: true,
          // flex: 2,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Amount",
          value: "amount",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Date",
          value: "date",
          show: true,
          // flex: 2,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Location",
          value: "location",
          show: true,
          // flex: 2,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Category",
          value: "category",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Expiration",
          value: "expiration",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "SKU",
          value: "sku",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "UID",
          value: "uid",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Status",
          value: "status",
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalPadding = SizeHelper.getTopPadding(context);

    final maxHeight = SizeHelper.getScreenHeight(context) * 0.92;

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: verticalPadding, left: 0, right: 0),
                padding: EdgeInsets.zero,
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: ResponsiveDatatable(
                    prefferedColor: widget.headerColor,
                    // rowTextStyle: TextStyle(color: Colors.black),

                    title: TextButton.icon(
                      onPressed: () => {
                        // Do something
                      },
                      icon: Icon(
                        Icons.add,
                        color: widget.headerColor,
                      ),
                      label: Text(
                        "Add receipt",
                        style: TextStyle(color: widget.headerColor),
                      ),
                    ),

                    // Have to leave this for correct orientation change
                    reponseScreenSizes: [ScreenSize.xs],
                    actions: [
                      if (_isSearch)
                        Expanded(
                            child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter search term based on ' +
                                  _searchKey!
                                      .replaceAll(new RegExp('[\\W_]+'), ' ')
                                      .toUpperCase(),
                              prefixIcon: IconButton(
                                  icon: Icon(Icons.cancel),
                                  color: widget.headerColor,
                                  onPressed: () {
                                    setState(() {
                                      _isSearch = false;
                                    });
                                    _initializeData();
                                  }),
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.search,
                                      color: widget.headerColor),
                                  onPressed: () {})),
                          onSubmitted: (value) {
                            _filterData(value);
                          },
                        )),
                      if (!_isSearch)
                        IconButton(
                            icon: Icon(
                              Icons.search,
                              color: widget.headerColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSearch = true;
                              });
                            })
                    ],
                    headers: _headers,
                    source: _source,
                    selecteds: _selecteds,
                    showSelect: _showSelect,
                    autoHeight: true,
                    dropContainer: (data) {
                      if (int.tryParse(data['id'].toString())!.isEven) {
                        return Text("is Even");
                      }
                      return _DropDownContainer(data: data);
                    },
                    onChangedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onSubmittedRow: (value, header) {
                      /// print(value);
                      /// print(header);
                    },
                    onTabRow: (data) {
                      print(data);
                    },
                    onSort: (value) {
                      setState(() => _isLoading = true);

                      setState(() {
                        _sortColumn = value;
                        _sortAscending = !_sortAscending;
                        if (_sortAscending) {
                          _sourceFiltered.sort((a, b) =>
                              b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                        } else {
                          _sourceFiltered.sort((a, b) =>
                              a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                        }
                        var _rangeTop =
                            _currentPerPage! < _sourceFiltered.length
                                ? _currentPerPage!
                                : _sourceFiltered.length;
                        _source =
                            _sourceFiltered.getRange(0, _rangeTop).toList();
                        _searchKey = value;

                        _isLoading = false;
                      });
                    },
                    expanded: _expanded,
                    sortAscending: _sortAscending,
                    sortColumn: _sortColumn,
                    isLoading: _isLoading,
                    onSelect: (value, item) {
                      print("$value  $item ");
                      if (value!) {
                        setState(() => _selecteds.add(item));
                      } else {
                        setState(() =>
                            _selecteds.removeAt(_selecteds.indexOf(item)));
                      }
                    },
                    onSelectAll: (value) {
                      if (value!) {
                        setState(() => _selecteds =
                            _source.map((entry) => entry).toList().cast());
                      } else {
                        setState(() => _selecteds.clear());
                      }
                    },
                    footers: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Rows per page:"),
                      ),
                      if (_perPages.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: DropdownButton<int>(
                            value: _currentPerPage,
                            items: _perPages
                                .map((e) => DropdownMenuItem<int>(
                                      child: Text("$e"),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (dynamic value) {
                              setState(() {
                                _currentPerPage = value;
                                _currentPage = 1;
                                _resetData();
                              });
                            },
                            isExpanded: false,
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child:
                            Text("$_currentPage - $_currentPerPage of $_total"),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                        ),
                        onPressed: _currentPage == 1
                            ? null
                            : () {
                                var _nextSet = _currentPage - _currentPerPage!;
                                setState(() {
                                  _currentPage = _nextSet > 1 ? _nextSet : 1;
                                  _resetData(start: _currentPage - 1);
                                });
                              },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: _currentPage + _currentPerPage! - 1 > _total
                            ? null
                            : () {
                                var _nextSet = _currentPage + _currentPerPage!;

                                setState(() {
                                  _currentPage = _nextSet < _total
                                      ? _nextSet
                                      : _total - _currentPerPage!;
                                  _resetData(start: _nextSet - 1);
                                });
                              },
                        padding: EdgeInsets.symmetric(horizontal: 15),
                      )
                    ],
                  ),
                ),
              ),
            ]));
  }
}

class _DropDownContainer extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = data.entries.map<Widget>((entry) {
      Widget w = Row(
        children: [
          Text(entry.key.toString()),
          Spacer(),
          Text(entry.value.toString()),
        ],
      );
      return w;
    }).toList();

    return Container(
      /// height: 100,
      child: Column(
        /// children: [
        ///   Expanded(
        ///       child: Container(
        ///     color: Colors.red,
        ///     height: 50,
        ///   )),

        /// ],
        children: _children,
      ),
    );
  }
}

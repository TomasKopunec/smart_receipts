import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:smart_receipts/helpers/size_helper.dart';

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
  String? _searchKey = "uid";

  int _currentPage = 1;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  // ignore: unused_field

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
        'amount': '${((i * 10.00) - 0.01).toString()}\$',
        'date': DateFormat.yMMMMd()
            .format(DateTime.now().subtract(Duration(days: i))),
        'location': 'London, UK',
        'category': 'Fashion',
        'expiration': DateFormat.yMMMMd('en_US').format(DateTime.now()
            .subtract(Duration(days: i))
            .add(Duration(days: 365))),
        'sku': '$i\000$i',
        'uid': '$i',
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
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(_generateData(n: 120)); // random.nextInt(1000)));
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
    Future.delayed(const Duration(seconds: 0)).then((value) {
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
        /// Exact match
        /// CONTAINS
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
    return _getTableWrapper(
        table: ResponsiveDatatable(
      prefferedColor: widget.headerColor,
      reponseScreenSizes: const [ScreenSize.xs],
      title: _getTitle(),
      actions: _getActions(),
      headers: _headers,
      source: _source,
      selecteds: _selecteds,
      showSelect: _showSelect,
      autoHeight: true,
      dropContainer: (data) {
        if (int.tryParse(data['uid'].toString())!.isEven) {
          return const Text("is Even");
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
            _sourceFiltered
                .sort((a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
          } else {
            _sourceFiltered
                .sort((a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
          }
          var _rangeTop = _currentPerPage! < _sourceFiltered.length
              ? _currentPerPage!
              : _sourceFiltered.length;
          _source = _sourceFiltered.getRange(0, _rangeTop).toList();
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
          setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
        }
      },
      onSelectAll: (value) {
        if (value!) {
          setState(
              () => _selecteds = _source.map((entry) => entry).toList().cast());
        } else {
          setState(() => _selecteds.clear());
        }
      },
      footers: _getFooters(),
    ));
  }

  /// Wrapper for the table to provide nice padding and margins
  Widget _getTableWrapper({required ResponsiveDatatable table}) {
    final verticalPadding = SizeHelper.getTopPadding(context);
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(top: verticalPadding),
            padding: EdgeInsets.zero,
            child: Card(
              elevation: 5,
              shadowColor: widget.headerColor,
              clipBehavior: Clip.none,
              child: table,
            ),
          )
        ],
      ),
    );
  }

  /// Header
  Widget _getTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: TextButton.icon(
        onPressed: () => {
          // Do something
        },
        icon: _getIcon(Icons.add, true),
        label: Text(
          "Add receipt",
          style: TextStyle(color: widget.headerColor),
        ),
      ),
    );
  }

  List<Widget> _getActions() {
    TextEditingController _controller = TextEditingController();

    return [
      SearchBar(
          searchKey: _searchKey!,
          width: SizeHelper.getScreenWidth(context) * 0.5,
          color: widget.headerColor,
          filter: _filterData,
          searchIcon: Icons.search)
    ];
  }

  /// Footer
  Row _getRowsPerPageSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text('Rows per page:'),
        if (_perPages.isNotEmpty)
          DropdownButton<int>(
            iconEnabledColor: widget.headerColor,
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
          )
      ],
    );
  }

  Row _getCurrentPageSection() {
    _isFirstPage() {
      return _currentPage == 1;
    }

    _isLastPage() {
      return _currentPage + _currentPerPage! - 1 > _total;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("$_currentPage - $_currentPerPage of $_total"),
        IconButton(
          icon: _isFirstPage()
              ? _getIcon(Icons.arrow_back_ios_new_rounded, false)
              : _getIcon(Icons.arrow_back_ios_new_rounded, true),
          onPressed: _isFirstPage()
              ? null
              : () {
                  var _nextSet = _currentPage - _currentPerPage!;
                  setState(() {
                    _currentPage = _nextSet > 1 ? _nextSet : 1;
                    _resetData(start: _currentPage - 1);
                  });
                },
        ),
        IconButton(
          icon: _isLastPage()
              ? _getIcon(Icons.arrow_forward_ios_rounded, false)
              : _getIcon(Icons.arrow_forward_ios_rounded, true),
          onPressed: _isLastPage()
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
        )
      ],
    );
  }

  List<Widget> _getFooters() {
    return [
      _getRowsPerPageSection(),
      _getCurrentPageSection(),
    ];
  }

  /// Helper methods
  Icon _getIcon(IconData icon, bool isActive, {double? size}) {
    return Icon(
      icon,
      color:
          isActive ? widget.headerColor : widget.headerColor.withOpacity(0.5),
      size: size,
    );
  }
}

class SearchBar extends StatefulWidget {
  final String searchKey;
  final Function(String) filter;
  final IconData searchIcon;
  final Duration duration;
  final double width;
  final Color color;

  const SearchBar(
      {required this.searchKey,
      required this.color,
      required this.filter,
      required this.searchIcon,
      required this.width,
      this.duration = const Duration(milliseconds: 400)});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  bool _isForward = true;

  final FocusNode _inputFocusNode = FocusNode();

  final textController = TextEditingController();

  /// Animation stuff
  late Animation<double> widthAnimation;
  late AnimationController widthAnimationController;

  @override
  void initState() {
    super.initState();

    // Animation
    widthAnimationController =
        AnimationController(vsync: this, duration: widget.duration);

    final curvedAnimation = CurvedAnimation(
        parent: widthAnimationController, curve: Curves.fastOutSlowIn);

    widthAnimation =
        Tween<double>(begin: 0, end: widget.width).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final double borderRadius = widget.width * 0.09;

    final Color selectedColor = widget.color.withOpacity(0.75);

    const Icon selectedIcon = Icon(Icons.check, color: Colors.white);
    final Icon unselectedIcon = Icon(widget.searchIcon, color: widget.color);

    const Curve opacityCurve = Curves.linear;
    final Duration opacityDuration = widget.duration * 1;

    textController.addListener(() {
      setState(() {
        widget.filter(textController.text);
      });
    });

    return Row(
      children: [
        AnimatedOpacity(
          curve: opacityCurve,
          opacity: !_isForward ? 1 : 0,
          duration: opacityDuration,
          child: Container(
            width: widthAnimation.value,
            decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius))),
            child: Row(
              children: [
                Flexible(
                  child: IconButton(
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      textController.clear();
                    },
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    focusNode: _inputFocusNode,
                    cursorColor: Colors.white,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      _trigger();
                      widget.filter(value);
                    },
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeHelper.getFontSize(context,
                            size: FontSize.regularSmall)),
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        border: InputBorder.none,
                        hintText:
                            'Enter ${widget.searchKey.replaceAll(new RegExp('[\\W_]+'), ' ').toUpperCase()}'),
                  ),
                )
              ],
            ),
          ),
        ),
        Stack(
          children: [
            AnimatedOpacity(
              curve: opacityCurve,
              opacity: !_isForward ? 1 : 0,
              duration: opacityDuration,
              child: Container(
                decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(0),
                      topLeft: const Radius.circular(0),
                      bottomRight: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    )),
                child: IconButton(
                  icon: Icon(widget.searchIcon, color: Colors.transparent),
                  onPressed: () {},
                ),
              ),
            ),
            IconButton(
                icon: !_isForward ? selectedIcon : unselectedIcon,
                onPressed: _trigger)
          ],
        ),
      ],
    );
  }

  void _trigger() {
    if (_isForward) {
      widthAnimationController.forward();
      _isForward = false;
      FocusManager.instance.primaryFocus!.requestFocus(_inputFocusNode);
    } else {
      widthAnimationController.reverse();
      _isForward = true;
      FocusManager.instance.primaryFocus!.unfocus();
    }
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

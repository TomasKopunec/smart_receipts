import 'package:flutter/cupertino.dart';
import 'package:smart_receipts/helpers/filter_helper.dart';
import 'package:smart_receipts/helpers/requests/receipt_request_helper.dart';
import 'package:smart_receipts/models/receipt/receipt.dart';
import 'package:smart_receipts/helpers/shared_preferences_helper.dart';
import 'package:smart_receipts/providers/auth/auth_provider.dart';
import 'package:smart_receipts/providers/user_provider.dart';
import 'package:smart_receipts/screens/tabs/receive/listening_thread.dart';

import '../../widgets/control_header/sorting_selection_dropdown.dart';

class ReceiptsProvider with ChangeNotifier {
  ListeningThread? _listeningThread;

  List<Receipt> _receipts = [];

  List<Map<String, dynamic>> _source = [];

  bool _isSelecting = false;

  final Set<String> _selecteds = {}; // List of selected receipts (id)
  final Set<String> _favorites = {}; // List of favorite receipts (id)

  bool _isShowingFavorites = false;

  String _filterValue = '';

  ReceiptField _searchKey =
      ReceiptField.purchaseDateTime; // Refer to Receipt class

  SortStatus _sortStatus = SortStatus.desc;

  final ReceiptsRequestHelper _receiptsRequestHelper = ReceiptsRequestHelper();

  DateTime _start = DateTime(DateTime.now().year);
  DateTime _end = DateTime.now();

  /// Set the Receipts
  Future<dynamic> setReceipts(List<Receipt> receipts) async {
    _receipts = receipts;
    _updateSource();
  }

  Future<void> fetchAndSetReceipts(String token) async {
    final response = await _receiptsRequestHelper.getReceipts(token);
    setReceipts(response.status ? response.receipts! : []);
  }

  /// Update Source
  void _updateSource() async {
    // 1. Filter
    List<Receipt> newReceipts = await FilterHelper.filterReceipts(
      receipts: [..._receipts],
      value: _filterValue,
      favourites: _favorites,
      favouritesEnabled: _isShowingFavorites,
      start: _start,
      end: _end,
    );

    // 2. Sort
    newReceipts.sort((a, b) {
      if (_sortStatus == SortStatus.asc) {
        return a.getField(_searchKey).compareTo(b.getField(_searchKey));
      } else {
        return b.getField(_searchKey).compareTo(a.getField(_searchKey));
      }
    });

    // 3. Convert to JSON
    setSource(newReceipts.map((r) => r.toJson()).toList());
  }

  /// Sets the source of the Receipts list / table to list of JSONs
  void setSource(List<Map<String, dynamic>> newSource) {
    _source = newSource;
    notifyListeners();
  }

  /// Used to reset the source when the screen is opened again
  void resetSource() {
    _filterValue = '';
    _searchKey = ReceiptField.purchaseDateTime;
    _sortStatus = SortStatus.desc;
    _selecteds.clear();
    _isSelecting = false;
    _isShowingFavorites = false;
    _start = DateTime(DateTime.now().year);
    _end = DateTime.now();
    _updateSource();
  }

  /// FAVOURITES
  Future<Set<String>> fetchAndSetFavorites() async {
    final fetched = await SharedPreferencesHelper.getFavorites();
    _favorites.addAll(fetched);
    notifyListeners();
    return _favorites;
  }

  void toggleFavourites() {
    _isShowingFavorites = !_isShowingFavorites;
    _updateSource();
  }

  bool get isShowingFavorites {
    return _isShowingFavorites;
  }

  List<String> get favorites {
    return [..._favorites];
  }

  bool flipFavorite(String id) {
    bool isFavorite = false;
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
      isFavorite = true;
    }

    SharedPreferencesHelper.saveFavorites(_favorites.toList());
    notifyListeners();
    return isFavorite;
  }

  void flipFavorites(List<String> list) {
    for (final id in list) {
      flipFavorite(id);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

  /// SOURCE
  List<Map<String, dynamic>> get source {
    return _source;
  }

  ReceiptField get searchKey {
    return _searchKey;
  }

  int get receiptSize {
    return _receipts.length;
  }

  void setSearchKey(ReceiptField key) {
    if (key == _searchKey) {
      toggleSorting();
    }
    _searchKey = key;

    if (_searchKey == ReceiptField.status) {
      toggleSorting();
    }

    _updateSource();
  }

  Receipt getReceiptById(String id) {
    return _receipts.firstWhere((e) => e.receiptId == id);
  }

  List<Receipt> getMostRecentN([int n = 2]) {
    List<Receipt> copy = [..._receipts];
    copy.sort((a, b) => (b.getField(ReceiptField.purchaseDateTime) as DateTime)
        .compareTo(a.getField(ReceiptField.purchaseDateTime) as DateTime));
    return copy.take(n).toList();
  }

  Receipt getMostRecent() {
    return getMostRecentN(1).first;
  }

  // SORTING
  SortStatus get sortStatus {
    return _sortStatus;
  }

  void toggleSorting() {
    _sortStatus =
        _sortStatus == SortStatus.asc ? SortStatus.desc : SortStatus.asc;
    _updateSource();
  }

  // FILTERING
  String get filterValue {
    return _filterValue;
  }

  void setFilterValue(value) {
    _filterValue = value.trim();
    _updateSource();
  }

  /// SELECTION
  void selectAll() {
    for (var e in _receipts) {
      _selecteds.add(e.receiptId);
    }
    notifyListeners();
  }

  void clearSelecteds({bool notify = false}) {
    _selecteds.clear();
    if (notify) {
      notifyListeners();
    }
  }

  int get selectedsLen {
    return _selecteds.length;
  }

  void toggleSelecting() {
    _isSelecting = !_isSelecting;
    notifyListeners();
  }

  bool get isSelecting {
    return _isSelecting;
  }

  void addSelectedByID(String id) {
    _selecteds.add(id);
    notifyListeners();
  }

  void removeSelectedByID(String id) {
    _selecteds.remove(id);
    notifyListeners();
  }

  bool selectedContains(String id) {
    return _selecteds.contains(id);
  }

  List<String> get selecteds {
    return [..._selecteds];
  }

  /// LISTENING THREAD
  void startListening(
      BuildContext context, UserProvider users, AuthProvider auth) {
    _listeningThread = ListeningThread(
      context: context,
      users: users,
      auth: auth,
      onFinish: () => stopListening(),
    );
  }

  void stopListening() {
    if (_listeningThread != null) {
      _listeningThread = null;
    }
  }

  // DATE RANGE
  DateTime get startRangeDate {
    return _start;
  }

  DateTime get endRangeDate {
    return _end;
  }

  void setStartRangeDate(DateTime start) {
    _start = start;
    _updateSource();
  }

  void setEndRangeDate(DateTime end) {
    _end = end;
    _updateSource();
  }

  // Used during debugging
  // List<Receipt> _generateData({required int n}) {
  //   List<String> storeNames = [
  //     'H&M',
  //     'Zara',
  //     'McDonald\'s',
  //     'Lidl',
  //     'Gant',
  //     'Nike',
  //     'Dell',
  //     'Deli Store'
  //   ];

  //   final List<Receipt> generated = [];
  //   for (int i = 1; i <= n; i++) {
  //     final List<Product> products = [];

  //     final numberOfProducts = Random().nextInt(15) + 1;
  //     for (int x = 0; x <= numberOfProducts; x++) {
  //       products.add(Product(
  //           id: x,
  //           name: 'Item $x',
  //           price: x * 10,
  //           sku: '$x',
  //           category: 'Default Category'));
  //     }

  //     generated.add(Receipt(
  //         id: i,
  //         auto_delete_date_time: DateTime.now().add(const Duration(days: 365)),
  //         retailer_receipt_id: i,
  //         retailer_id: i,
  //         retailer_name: storeNames[Random().nextInt(storeNames.length)],
  //         customer_email: 'email$i@gmail.com',
  //         purchase_date_time: DateTime.now()
  //             .subtract(Duration(days: Random().nextInt(365 * 2))),
  //         purchase_location: 'London, UK',
  //         status: ReceiptStatus
  //             .values[Random().nextInt(ReceiptStatus.values.length)],
  //         expiration: DateTime.now()
  //             .subtract(Duration(days: i))
  //             .add(const Duration(days: 365)),
  //         price: (Random().nextDouble() * 200),
  //         currency: 'GBP',
  //         paymentMethod: 'Card',
  //         cardNumber: "1234 1234 1234 1234",
  //         products: products));
  //   }
  //   generated.shuffle();
  //   return generated;
  // }
}

import 'package:flutter/material.dart';

class StateManager extends ChangeNotifier {
  //for Bookings
  String searchDate;
  bool clearFilter = false;
  String balance = "xxxxxx";

  String searchDateTrans;
  bool clearFilterTrans = false;

  String getBalance() => balance;
  setBalance(String balance) {
    this.balance = balance;
    notifyListeners();
  }

  String getSearchDate() => searchDate;
  bool getClearFilter() => clearFilter;
  setSearchDate(String searchDate) {
    this.searchDate = searchDate;
    notifyListeners();
  }

  setClearFilter(bool clearFilter) {
    this.clearFilter = clearFilter;
    notifyListeners();
  }

  //for Transaction

  String getSearchDateTrans() => searchDateTrans;
  bool getClearFilterTrans() => clearFilterTrans;

  setSearchDateTrans(String searchDateTrans) {
    this.searchDateTrans = searchDateTrans;
    notifyListeners();
  }

  setClearFilterTrans(bool clearFilterTrans) {
    this.clearFilterTrans = clearFilterTrans;
    notifyListeners();
  }
}

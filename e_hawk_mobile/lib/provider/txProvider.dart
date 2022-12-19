import 'package:e_hawk_mobile/utilities/Global.dart';
import 'package:flutter/material.dart';

class TxProvider extends ChangeNotifier {
  bool get hasSelectedFilter => _hasSelectedFilter;

  List<bool> get isSelectedTxAmt => _isSelectedTxAmt;

  List<int> get defaultTerm => _defaultTerm;

  bool _hasSelectedFilter = false;

  List<int> _defaultTerm = [1, 3];

  List<bool> _isSelectedTxAmt = [];

  Map<String, bool> _selectedDateRange = {
    Global.l7d: false,
    Global.l30d: false,
    Global.l90d: false
  };

  Map<String, bool> _selectedTxStatus = {'0': false, '1': false};

  Map<String, bool> _selectedTxTerm = {};

  Map<String, dynamic> _selectedTx = {};

  Map<String, dynamic> get selectedTX => _selectedTx;

  Map<String, bool> get selectedTxStatus => _selectedTxStatus;

  Map<String, bool> get selectedDateRange => _selectedDateRange;

  Map<String, bool> get selectedTxTerm => _selectedTxTerm;

  void setSelectedTx(Map<String, dynamic> input) {
    _selectedTx = input;
    notifyListeners();
  }

  void toggleHasSelectedFilter(bool value) {
    _hasSelectedFilter = value;
    notifyListeners();
  }

  void initSelectedTxTerm() {
    for (var element in defaultTerm) {
      _selectedTxTerm.addAll({"$element": false});
    }
    notifyListeners();
  }

  void resetSelectedTxTerm() {
    _selectedTxTerm.updateAll((key, value) => false);
    notifyListeners();
  }

  void toggleSelectedTxTerm(String index) {
    _selectedTxTerm[index] = !_selectedTxTerm[index]!;
    notifyListeners();
  }

  void resetSelectedTxStatus() {
    _selectedTxStatus.updateAll((key, value) => false);
    notifyListeners();
  }

  void toggleSelectedTxStatus(String index) {
    _selectedTxStatus[index] = !_selectedTxStatus[index]!;
    notifyListeners();
  }

  void resetSelectedDateRange() {
    _selectedDateRange.updateAll((key, value) => false);
    notifyListeners();
  }

  void setSelectedDateRange(String index, bool value) {
    _selectedDateRange[index] = value;
    notifyListeners();
  }

  void initDefaultTerm(List<int> term) {
    _defaultTerm = term;
  }

  void setIsSelectedTxAmt(int index, bool value) {
    _isSelectedTxAmt[index] = value;
    notifyListeners();
  }

  void initIsSelected() {
    for (int element in _defaultTerm) {
      _isSelectedTxAmt.add(false);
    }
    //notifyListeners();
  }

  void resetIsSelected() {
    for (int i = 0; i < _isSelectedTxAmt.length; i++) {
      if (_isSelectedTxAmt[i]) {
        _isSelectedTxAmt[i] = false;
      }
    }
    notifyListeners();
  }
}

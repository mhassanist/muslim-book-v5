import 'package:flutter/material.dart';
import 'package:muslim_book/enums/view_state_enum.dart';

class ViewStateProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;
  bool _mounted = true;

  bool get mounted => _mounted;

  void setViewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  String _errorMessage = "";

  set errorMessage(val) {
    _errorMessage = val;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}

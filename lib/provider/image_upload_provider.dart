import 'package:astra/enum/view_state.dart';
import "package:flutter/material.dart";

class ImageUploadProvider with ChangeNotifier {
  ViewState _viewState = ViewState.NOT_LOADING;
  ViewState get getViewState => _viewState;

  void setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToNotLoading() {
    _viewState = ViewState.NOT_LOADING;
    notifyListeners();
  } 
}
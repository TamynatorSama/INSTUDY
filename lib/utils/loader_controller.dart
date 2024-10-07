import 'package:flutter/foundation.dart';

final LoaderController loaderController = LoaderController();

class LoaderController extends ChangeNotifier {
  bool isLoading = false;

  updateState({bool isLoading = false}) {
    bool update = isLoading != this.isLoading ;
    this.isLoading = isLoading;
    if (update) {
      notifyListeners();
    }
  }
}

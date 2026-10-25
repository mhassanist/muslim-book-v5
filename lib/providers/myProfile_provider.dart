import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/models/score_model.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';

class MyProfileProvider extends ViewStateProvider {
  MyProfileProvider() {
    getScore();
  }
  ScoreModelData? _scoreModelData;
  bool _isInternetConnected = true;

  get isInternetConnected => _isInternetConnected;
  ScoreModelData? get scoreModelData => _scoreModelData;
  @override
  void dispose() {
    notifyListeners();
    super.dispose();
  }

//  Future<File> get getUserProfileImage => _userSelectedImage;

//  set setUserProfileImage(Future<File> selectedImage) {
//    _userSelectedImage = selectedImage;
//    notifyListeners();
//  }

  bool loadFailed = false;

  Future getScore() async {
    // Refreshes after the first load happen without the full-page spinner.
    if (_scoreModelData == null) setViewState(ViewState.Loading);
    var res = await locator<ApiService>().getUserScore();
    if (res != null) {
      _scoreModelData = (res).data;
    }
    // Leave the loading state on failure too; the view shows a retry.
    loadFailed = _scoreModelData == null;
    setViewState(ViewState.Idle);
  }
}

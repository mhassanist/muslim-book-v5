import 'dart:io';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/models/score_model.dart';
import 'package:base_app/network_utils/api_service.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/utils/locator.dart';

class MyProfileProvider extends ViewStateProvider {
  MyProfileProvider() {
    getScore();
  }
  ScoreModelData _scoreModelData;
  bool _isInternetConnected = true;

  get isInternetConnected => _isInternetConnected;
  ScoreModelData get scoreModelData => _scoreModelData;
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

  Future getScore() async {
    setViewState(ViewState.Loading);
   var res = await locator<ApiService>().getUserScore();
   if (res != null) {
     _scoreModelData = (res as ScoreModel).data;
    setViewState(ViewState.Idle);
   }

    }

}

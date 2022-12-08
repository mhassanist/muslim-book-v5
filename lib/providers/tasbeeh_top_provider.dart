import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/models/score_model.dart';
import 'package:muslim_book/models/top_model.dart';
import 'package:muslim_book/models/user_score.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';

class TasbeehTopProvider extends ViewStateProvider {
  final UserProvider _userProvider;
  AudioCache _audioCache;

  TasbeehTopProvider(this._userProvider) {
    _audioCache = AudioCache(
        prefix: "audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
    getTasbeehTop();
  }

  List<TopModelData> _topList;
  List<CountryModel> _countries = [];
  CountryModel _userCountryModel;
  UserScoreModel _userScore;

  List<TopModelData> get topList => _topList == null ? [] : _topList;

  UserScoreModel get userScore => _userScore;

  CountryModel get userCountryModel => _userCountryModel;

  set userCountryModel(CountryModel val) {
    _userCountryModel = val;
    notifyListeners();
  }

  List<CountryModel> get countries => _countries;

  set countries(List<CountryModel> val) {
    _countries = val;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getTasbeehTop() async {
    if (_userProvider != null && _userProvider.isLoggedIn) {
      setViewState(ViewState.Loading);
      TopModel _apiResponseModel = await locator<ApiService>().getTasbeehTop();
      if (_apiResponseModel != null) {
        _topList = _apiResponseModel.data;
        _userScore = _apiResponseModel.userScoreModel;
        /*if (_userScore.points > 1000) {
          _audioCache.play("u_made_achievment.wav");
        }*/
      }
      setViewState(ViewState.Idle);
    }
  }
}

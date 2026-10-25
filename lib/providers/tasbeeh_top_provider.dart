// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/models/top_model.dart';
import 'package:muslim_book/models/user_score.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';

class TasbeehTopProvider extends ViewStateProvider {
  late final UserProvider? _userProvider;
  // late AudioCache _audioCache;
  final player = AudioPlayer();

  TasbeehTopProvider(this._userProvider) {
    // _audioCache = AudioCache(
    //     prefix: "audio/",
    //     fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),);
    getTasbeehTop();
  }

  List<TopModelData> _topList = [];
  List<CountryModel> _countries = [];
  CountryModel _userCountryModel = CountryModel();
  UserScoreModel _userScore = UserScoreModel();

  List<TopModelData> get topList => _topList;

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
    if (_userProvider != null && _userProvider!.isLoggedIn) {
      setViewState(ViewState.Loading);
      try {
        TopModel? _apiResponseModel =
            await locator<ApiService>().getTasbeehTop();
        if (_apiResponseModel != null) {
          _topList = _apiResponseModel.data;
          _userScore = _apiResponseModel.userScoreModel ?? UserScoreModel();
          if (_userScore.points > 1000) {
            // _audioCache.play("u_made_achievment.wav");
            await player
                .play(AssetSource('audio/u_made_achievment.wav'));
          }
        }
      } finally {
        setViewState(ViewState.Idle);
      }
    }
  }
}

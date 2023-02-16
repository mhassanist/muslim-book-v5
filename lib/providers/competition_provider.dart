import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/models/answer_model.dart' as answer;
import 'package:muslim_book/models/answer_result_model.dart';
import 'package:muslim_book/models/competitions_model.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/views/competition_view/competition_view_mobile_portrait/competition_mobile_portrait_ui.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class CompetitionProvider extends ViewStateProvider {
  late final UserProvider? _userProvider;
  late CompetitionUI ui;
  // AudioCache _audioPlayer = AudioCache();
  // AudioPlayer _audioPlayer = AudioPlayer();
  final player = AudioPlayer();
  int? _chosenPosition;
  int? _correctAnswerPosition;
  bool _isDisposed = false;
  bool _isDialogOpened = false;
  bool _isExiteOpened = false;
  List<QuestionModel> _questions = [];
  List<AnswerModel> _answers = [];
  AnswerResultModelData _answerResultModelData = AnswerResultModelData();
  Color? _color;
  bool _isAnsweredClicked = false;
  int _questionIndex = 0;
  int _answerId = 0;
  int _start = 60;
  int _current = 60;
  int _correctAnswerCounter = 0;
  bool _agreeToStart = false;
  CountdownTimer? _countDownTimer;
  bool _disablePickingAnswers = false;

  late answer.AnswerModelData _scoreModelData;

  CompetitionProvider(this._userProvider) {
    super.setViewState(ViewState.Loading);
  }

  answer.AnswerModelData get scoreModelData => _scoreModelData;

  set scoreModelData(answer.AnswerModelData val) {
    _scoreModelData = val;
    notifyListeners();
  }

  int _totalQuestions = 0;

  int get totalQuestions => _totalQuestions;

  set chosenPosition(position) {
    _chosenPosition = position;
    notifyListeners();
  }

  int? get chosenPosition => _chosenPosition;

  set isAnsweredClicked(position) {
    _isAnsweredClicked = position;
    notifyListeners();
  }

  set isExiteOpened(position) {
    _isExiteOpened = position;
    notifyListeners();
  }

  bool get isExiteOpened => _isExiteOpened;

  bool get isAnsweredClicked => _isAnsweredClicked;

  set correctAnswerPosition(position) {
    _correctAnswerPosition = position;
  }

  AnswerResultModelData get answerResultModelData => _answerResultModelData;

  bool get disablePickingAnswers => _disablePickingAnswers;

  bool get agreeToStart => _agreeToStart;

  int get current => _current;
  bool _questionDownloaded = false;

  List<QuestionModel> get questions => _questions;

  List<AnswerModel> get answers => _answers;

  int get questionIndex => _questionIndex;

  int get answerId => _answerId;

  Color? get color => _color;

  @override
  void dispose() {
    print("provider disposed");
    _isDisposed = true;
    if (_countDownTimer != null) {
      _countDownTimer!.cancel();
    }
    notifyListeners();
    super.dispose();
  }

  set setCurrent(int current) {
    this._current = current;
    notifyListeners();
  }

  set setAgreeToStart(bool agree) {
    this._agreeToStart = agree;
    notifyListeners();
  }

  set disablePickingAnswers(bool val) {
    _disablePickingAnswers = val;
    notifyListeners();
  }

  set setAnswerId(int index) {
    this._answerId = index;
    notifyListeners();
  }

  Future getQuestions() async {
    _questionDownloaded = true;
    setViewState(ViewState.Loading);
    var res = await locator<ApiService>().getQuestions();
    if (res is QuestionsModel) {
      if (res.data.isNotEmpty) {
        startCompetitionQuestions(res);
      } else {
        _questions = [];
      }
    }
    if (!_isDisposed) {
      setViewState(ViewState.Idle);
    }
  }

  void startCompetitionQuestions(QuestionsModel res) {
    _questions = res.data;
    _answers = _questions[_questionIndex].answers;
    _totalQuestions = res.meta.total;
    if (_questionIndex == 0) {
      openDialog();
    }
  }

  Future postAnswer() async {
    {
      //setViewState(ViewState.Loading);
      Map<String, dynamic> body = {
        "answer_id": _answerId.toString(),
        "question_id": _questions[_questionIndex].id.toString(),
      };
      if (questionIndex == _questions.length - 1) body["additional"] = "force";

      var res = await locator<ApiService>().postAnswer(body);
      if (res != null && res is answer.AnswerModelData) {
        _scoreModelData = res;
      }
      setViewState(ViewState.Idle);
    }
  }

  changeIndex() async {
    _disablePickingAnswers = false;
    _isAnsweredClicked = false;
    _correctAnswerPosition = null;
    _chosenPosition = null;
    _questionIndex++;
    _current = 60;
    notifyListeners();
//    if (questionIndex == questions.length - 1) {
//    } else {
//
//    }
  }

  startTimer() {
    _countDownTimer = CountdownTimer(
      Duration(seconds: _start),
      Duration(seconds: 1),
    );

    var sub = _countDownTimer!.listen(null);
    sub.onData((duration) {
      _current = _start - duration.elapsed.inSeconds;
      notifyListeners();
    });

    sub.onDone(() {
      if (questionIndex > 1 && questionIndex % 5 == 0 && questionIndex != 10) {
        openFaceBookAd();
      }
      if (questions.isNotEmpty) {
        if (_chosenPosition == null) chosenPosition = _correctAnswerPosition;
        if (_chosenPosition != null &&
            questions[questionIndex].answers[_chosenPosition!].result == 1 &&
            _isAnsweredClicked) {
          _correctAnswerCounter++;
          playCorrectAnswerVoice();
        } else if (_chosenPosition != null &&
            questions[questionIndex].answers[_chosenPosition!].result == 0 &&
            _isAnsweredClicked) {
          _correctAnswerCounter = 0;

          playWrongAnswerVoice();
        } else {
          _correctAnswerCounter = 0;

          playTryAgainVoice();
        }
        sub.cancel();
        notifyListeners();
      }
    });
  }

  stopTimer() {
    _current = 0;
    _countDownTimer?.cancel();
  }

  Future playCorrectAnswerVoice() async {
    // await _audioPlayer.play("audio/questions/correct.mp3");
    await player.play(AssetSource('audio/questions/correct.mp3'));
    await Future.delayed(Duration(seconds: 1));
    if (_correctAnswerCounter == 3) {
      // await _audioPlayer.play("audio/u_made_achievment.wav");
      await player.play(AssetSource('audio/u_made_achievment.wav'));
      _correctAnswerCounter = 0;
    }
  }

  Future playWrongAnswerVoice() async {
    // await _audioPlayer.play("audio/questions/wrong.mp3");
    await player.play(AssetSource('audio/questions/wrong.mp3'));
  }

  Future playTryAgainVoice() async {
    // await _audioPlayer.play("audio/questions/try_again.mp3");
    await player.play(AssetSource('audio/questions/try_again.mp3'));
  }

  Future playAllQuestionsEndVoice() async {
    // await _audioPlayer.play("audio/questions/share.mp3");
    await player.play(AssetSource('audio/questions/share.mp3'));
  }

  void openDialog() {
    if (!_isDisposed && !_isDialogOpened) {
      ui.startPopUp();
    }
  }

  void openFaceBookAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: locator<RemoteConfigService>().azanPopUpAdId,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED)
          FacebookInterstitialAd.showInterstitialAd();
      },
    );
  }
}

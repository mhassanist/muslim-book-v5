import 'package:base_app/core/dio_util.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/home_feature/domian/model/islamic_posts_model.dart';
import 'package:base_app/home_feature/domian/repository_home.dart';
import 'package:flutter/material.dart';

class IslamicPostDetailsBloc with ChangeNotifier{

  String errormessage;
  APIStatus _state = APIStatus.initial;
  PostsOfIslamic _postsOfIslamic = PostsOfIslamic();

  static IslamicPostDetailsBloc _islamicPostDetailsBloc = IslamicPostDetailsBloc._internal();
  factory IslamicPostDetailsBloc(){
    return _islamicPostDetailsBloc;
  }
  IslamicPostDetailsBloc._internal();
  APIStatus get state => _state;
  PostsOfIslamic get postsOfIslamic => _postsOfIslamic;

  void _setState(APIStatus state) {
    _state = state;
    notifyListeners();
  }

  getIslamicPostDetails(String postId) async{
    _setState(APIStatus.loading);
    await HomeRepository().getIslamicPostDetails(postId).then((value) {
      _setPost(value);
      _setState(APIStatus.loaded);
    }).catchError((e){
      _setState(APIStatus.error);
      errormessage= DioUtil.handleDioError(e);
    });
  }

  void _setPost(PostsOfIslamic value) {
    _postsOfIslamic = value;
    notifyListeners();
  }
}
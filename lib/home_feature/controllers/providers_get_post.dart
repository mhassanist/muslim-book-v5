// import 'package:azan_app/Screens/Home/domian/model/post_model.dart';
// import 'package:azan_app/Screens/Home/domian/repository_home.dart';
import 'package:base_app/core/dio_util.dart';
import 'package:base_app/home_feature/domian/model/Posts_model.dart';
import 'package:base_app/home_feature/domian/model/categories_model.dart';
import 'package:base_app/home_feature/domian/model/islamic_posts_model.dart';
import 'package:base_app/home_feature/domian/repository_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 final getPosts = ChangeNotifierProvider<PostsNotifier>(
  (_) => PostsNotifier(),
);

class PostsNotifier extends ChangeNotifier {
  HomeRepository homeRepository = HomeRepository();
  Posts posts = Posts();
  List<Categore> categories=[];
  List<PostsOfIslamic> islamicPosts = [];
  List<PostsOfIslamic> islamicCatPosts = [];
String message;
String errormessage;
String islamicCatItemsErrorMessage;
  bool isloading = true;
  bool isIslamicCatItemsLoading = true;
  bool isnews=false;
  bool isPosts = true;
  bool isPostListError = false;

  changeisPosts(bool value) {
    isPosts = value;
    notifyListeners();
  }
  changetabBar(bool val){
    isnews=val;
    notifyListeners();
  }



  getPosts(int pageIndex) async {
    try {
      posts = await homeRepository.getPosts(pageIndex);
      //posts=posts.reversed.toList();
      errormessage=null;
      isloading = false;
    } catch(e){
      isloading = false;
      errormessage= DioUtil.handleDioError(e);
      isPostListError = true;
    }
    notifyListeners();
  }

  getcategories() async {
    try {
      categories = await homeRepository.getCategories();
      errormessage=null;
      isloading = false;
    } catch(e){
      isloading = false;
      errormessage= DioUtil.handleDioError(e);
      print(errormessage);
    }
    notifyListeners();
  }

  getIslamicPosts(int pageIndex, int catId) async {
    try {
      islamicPosts = await homeRepository.getIslamicPosts(pageIndex, catId);
      errormessage=null;
      isloading = false;
    } catch(e){
      isloading = false;
      errormessage= DioUtil.handleDioError(e);
      print(errormessage);
    }
    notifyListeners();
  }

  getIslamicCategoryPosts(int pageIndex, int catId) async {
    try {
      islamicCatPosts = await homeRepository.getIslamicPosts(pageIndex, catId);
      islamicCatItemsErrorMessage=null;
      isIslamicCatItemsLoading = false;
    } catch(e){
      isIslamicCatItemsLoading = false;
      islamicCatItemsErrorMessage= DioUtil.handleDioError(e);
      print(islamicCatItemsErrorMessage);
    }
    notifyListeners();
  }

  createPost(String content, int pageIndex) async {
    message=await homeRepository.createPost(content);
    posts = await homeRepository.getPosts(pageIndex);
    //posts=posts.reversed.toList();
    isloading = true;
    notifyListeners();
  }
  likePost(int id)async{
    await homeRepository.likePost(id);
    notifyListeners();
  }
  unlikePost(int id)async{
    await homeRepository.unlikePost(id);
    notifyListeners();
  }

  likeCategoryPost(int id)async{
    await homeRepository.likeCategoryPost(id);
    notifyListeners();
  }
  unlikeCategoryPost(int id)async{
    await homeRepository.unlikeCategoryPost(id);
    notifyListeners();
  }

  likeIslamicPost(int id)async{
    await homeRepository.likeIslamicPost(id);
    notifyListeners();
  }
  unlikeIslamicPost(int id)async{
    await homeRepository.unlikeIslamicPost(id);
    notifyListeners();
  }

}

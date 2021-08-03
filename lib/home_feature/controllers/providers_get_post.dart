// import 'package:azan_app/Screens/Home/domian/model/post_model.dart';
// import 'package:azan_app/Screens/Home/domian/repository_home.dart';
import 'package:base_app/core/dio_util.dart';
import 'package:base_app/home_feature/domian/model/categories_model.dart';
import 'package:base_app/home_feature/domian/repository_home.dart';
import 'package:flutter/cupertino.dart';
 import 'package:base_app/home_feature/domian/model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 final getPosts = ChangeNotifierProvider<PostsNotifier>(
  (_) => PostsNotifier(),
);

class PostsNotifier extends ChangeNotifier {
  HomeRepository homeRepository = HomeRepository();
  List<Post> posts = [];
  List<Categore> categories=[];
String message;
String errormessage;
  bool isloading = true;
  bool isnews=false;
  bool isPosts = true;

  changeisPosts(bool value) {
    isPosts = value;
    notifyListeners();
  }
  changetabBar(bool val){
    isnews=val;
    notifyListeners();
  }



  getPosts() async {
    try {
      posts = await homeRepository.getPosts();
      posts=posts.reversed.toList();
      errormessage=null;
      isloading = false;
    } catch(e){

      errormessage= DioUtil.handleDioError(e);
      isloading = false;
    }
    notifyListeners();
  }

  getcategories() async {
    try {
      categories = await homeRepository.getCategories();
      errormessage=null;
      //print(categories[0].description);
      isloading = false;
    } catch(e){

      errormessage= DioUtil.handleDioError(e);
      print(errormessage);
      isloading = false;
    }
    notifyListeners();
  }

  createPost(String content) async {
    message=await homeRepository.createPost(content);
    posts = await homeRepository.getPosts();
    posts=posts.reversed.toList();
    isloading = true;
    notifyListeners();
  }
  likePost(int id)async{
    await homeRepository.likePost(id);
   //posts= await homeRepository.getPosts();
   // posts=posts.reversed.toList();
    notifyListeners();
  }
  unlikePost(int id)async{
    await homeRepository.unlikePost(id);
   // posts= await homeRepository.getPosts();
   // posts=posts.reversed.toList();
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

}

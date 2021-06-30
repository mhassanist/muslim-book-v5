// import 'package:azan_app/Screens/Home/domian/model/post_model.dart';
// import 'package:azan_app/Screens/Home/domian/repository_home.dart';
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
String message;
  bool isloading = true;
  bool isnews=false;

  changetabBar(bool val){
    isnews=val;
    notifyListeners();
  }

 

  getPosts() async {
    posts = await homeRepository.getPosts();
    posts=posts.reversed.toList();
    isloading = false;
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
   posts= await homeRepository.getPosts();
    posts=posts.reversed.toList();
    notifyListeners();
  }
  unlikePost(int id)async{
    await homeRepository.unlikePost(id);
    posts= await homeRepository.getPosts();
    posts=posts.reversed.toList();
    notifyListeners();
  }
}

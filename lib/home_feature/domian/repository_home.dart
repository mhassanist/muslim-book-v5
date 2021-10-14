
import 'package:base_app/core/dio_util.dart';
import 'package:base_app/home_feature/domian/model/categories_model.dart';
import 'package:base_app/home_feature/domian/model/create_post_model.dart';
import 'package:base_app/home_feature/domian/model/post_model.dart';
import 'package:base_app/home_feature/domian/model/Posts_model.dart';

import 'model/islamic_posts_model.dart';

class HomeRepository {

  Future<List<Post>> getPosts(int pageIndex) async {
    Posts posts = Posts();
    DioUtil.setDioAgain();
    final dio = DioUtil.dio;
    final response = await dio.get("posts?page=$pageIndex");
    //print(response.data);
    posts = Posts.fromJson(response.data);

    return posts.data;
  }
  Future<List<Categore>> getCategories() async {
    Categories categories = Categories();
    DioUtil.setDioAgain();
    final dio = DioUtil.dio;
    final response = await dio.get("islamics");
    categories = Categories.fromJson(response.data);

    return categories.data;
  }

  Future<List<PostsOfIslamic>> getIslamicPosts(int pageIndex) async {
    IslamicPosts islamicPosts = IslamicPosts();
    DioUtil.setDioAgain();
    final dio = DioUtil.dio;
    final response = await dio.get("islamics/category/8?page=$pageIndex");
    islamicPosts = IslamicPosts.fromJson(response.data);

    return islamicPosts.data.posts;
  }

  Future<String> createPost(String content) async {

    DioUtil.setDioAgain();
     final dio = DioUtil.dio;

    final response = await dio.post("posts", data: {
      "content": content,
    });
    print(response);


ResponseCreateModel responseCreateModel =ResponseCreateModel();
responseCreateModel=ResponseCreateModel.fromJson(response.data);
return responseCreateModel.message;

  }
  Future likePost(int id) async {
    final dio = DioUtil.dio;
    final response = await dio.post("posts/${id}/like", data: {
      "":""
    });
    print(response);
    DioUtil.setDioAgain();
  }


  Future unlikePost(int id) async {
    final dio = DioUtil.dio;
    final response = await dio.post("posts/${id}/unlike", data: {
      "":""
    });
    print(response);
    DioUtil.setDioAgain();
  }

  Future likeCategoryPost(int id) async {
    final dio = DioUtil.dio;
    final response = await dio.post("islamics/${id}/like", data: {
      "":""
    });
    print(response);
    DioUtil.setDioAgain();
  }

  Future unlikeCategoryPost(int id) async {
    final dio = DioUtil.dio;
    final response = await dio.post("islamics/${id}/unlike", data: {
      "":""
    });
    print(response);
    DioUtil.setDioAgain();
  }

}

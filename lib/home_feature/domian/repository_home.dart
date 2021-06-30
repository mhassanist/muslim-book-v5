
import 'package:base_app/core/dio_util.dart';
import 'package:base_app/home_feature/domian/model/create_post_model.dart';
import 'package:base_app/home_feature/domian/model/post_model.dart';
import 'package:base_app/home_feature/domian/model/Posts_model.dart';

class HomeRepository {
  Future<List<Post>> getPosts() async {
    Posts posts = Posts();
    DioUtil.setDioAgain();
    final dio = DioUtil.dio;
    final response = await dio.get("posts");
     posts = Posts.fromJson(response.data);

    return posts.data;
  }

  Future<String> createPost(String content) async {
     final dio = DioUtil.dio;
    final response = await dio.post("posts", data: {
      "content": content,
    });
    print(response);

    DioUtil.setDioAgain();
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

}

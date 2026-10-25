// import 'package:azan_app/Screens/Home/domian/model/post_model.dart';
// import 'package:azan_app/Screens/Home/domian/repository_home.dart';
import 'package:dio/dio.dart';
import 'package:muslim_book/core/dio_exception.dart';
import 'package:muslim_book/core/dio_util.dart';
import 'package:muslim_book/home_feature/domian/model/Posts_model.dart';
import 'package:muslim_book/home_feature/domian/model/categories_model.dart';
import 'package:muslim_book/home_feature/domian/model/islamic_posts_model.dart';
import 'package:muslim_book/home_feature/domian/repository_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getPosts = ChangeNotifierProvider<PostsNotifier>(
  (_) => PostsNotifier(),
);

class PostsNotifier extends ChangeNotifier {
  HomeRepository homeRepository = HomeRepository();
  Posts posts = Posts();
  List<Categore> categories = [];
  List<PostsOfIslamic> islamicPosts = [];
  List<PostsOfIslamic> islamicCatPosts = [];
  String? message;
  String? errormessage;
  String? islamicCatItemsErrorMessage;
  bool isloading = true;
  bool isIslamicCatItemsLoading = true;
  bool isnews = false;
  bool isPosts = true;
  bool isPostListError = false;
  bool _isFetching = false;

  /// Loads the home feed while [isloading] is set. Safe to call from build:
  /// only one fetch runs at a time, so rebuilds don't fire duplicate requests.
  Future<void> loadIfNeeded(int pageIndex, int islamicPageIndex) async {
    if (!isloading || _isFetching) return;
    _isFetching = true;
    await Future.wait([
      getPosts(pageIndex),
      getcategories(),
      getIslamicPosts(islamicPageIndex, 8),
    ]);
    _isFetching = false;
  }

  void retry() {
    errormessage = null;
    isPostListError = false;
    isloading = true;
    notifyListeners();
  }

  changeisPosts(bool value) {
    isPosts = value;
    notifyListeners();
  }

  changetabBar(bool val) {
    isnews = val;
    notifyListeners();
  }

  Future<void> getPosts(int pageIndex) async {
    try {
      posts = await homeRepository.getPosts(pageIndex);
      //posts=posts.reversed.toList();
      errormessage = null;
      isloading = false;
    } on DioError catch (e) {
      isloading = false;
      isPostListError = true;
      errormessage = DioExceptions.fromDioError(e).message;
    } catch (e) {
      isloading = false;
      errormessage = e.toString();
      isPostListError = true;
    }
    notifyListeners();
  }

  Future<void> getcategories() async {
    try {
      categories = await homeRepository.getCategories();
      errormessage = null;
      isloading = false;
    } on DioError catch (e) {
      isloading = false;
      errormessage = DioExceptions.fromDioError(e).message;
    } catch (e) {
      isloading = false;
      errormessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> getIslamicPosts(int pageIndex, int catId) async {
    try {
      islamicPosts = await homeRepository.getIslamicPosts(pageIndex, catId);
      errormessage = null;
      isloading = false;
    } on DioError catch (e) {
      isloading = false;
      errormessage = DioExceptions.fromDioError(e).message;
    } catch (e) {
      isloading = false;
      errormessage = e.toString();
    }
    notifyListeners();
  }

  getIslamicCategoryPosts(int pageIndex, int catId) async {
    try {
      islamicCatPosts = await homeRepository.getIslamicPosts(pageIndex, catId);
      islamicCatItemsErrorMessage = null;
      isIslamicCatItemsLoading = false;
    } on DioError catch (e) {
      isIslamicCatItemsLoading = false;
      islamicCatItemsErrorMessage = DioExceptions.fromDioError(e).message;
    } catch (e) {
      isIslamicCatItemsLoading = false;
      islamicCatItemsErrorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Returns false if the post could not be sent.
  Future<bool> createPost(String content, int pageIndex) async {
    try {
      message = await homeRepository.createPost(content);
    } catch (e) {
      debugPrint('createPost failed: $e');
      return false;
    }
    try {
      posts = await homeRepository.getPosts(pageIndex);
    } catch (e) {
      debugPrint('refreshing posts after createPost failed: $e');
    }
    //posts=posts.reversed.toList();
    isloading = true;
    notifyListeners();
    return true;
  }

  likePost(int id) async {
    try {
      await homeRepository.likePost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('likePost failed: $e');
    }
    notifyListeners();
  }

  unlikePost(int id) async {
    try {
      await homeRepository.unlikePost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('unlikePost failed: $e');
    }
    notifyListeners();
  }

  likeCategoryPost(int id) async {
    try {
      await homeRepository.likeCategoryPost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('likeCategoryPost failed: $e');
    }
    notifyListeners();
  }

  unlikeCategoryPost(int id) async {
    try {
      await homeRepository.unlikeCategoryPost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('unlikeCategoryPost failed: $e');
    }
    notifyListeners();
  }

  likeIslamicPost(int id) async {
    try {
      await homeRepository.likeIslamicPost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('likeIslamicPost failed: $e');
    }
    notifyListeners();
  }

  unlikeIslamicPost(int id) async {
    try {
      await homeRepository.unlikeIslamicPost(id);
    } catch (e) {
      // Likes are fire-and-forget; don't let a network error go uncaught.
      debugPrint('unlikeIslamicPost failed: $e');
    }
    notifyListeners();
  }
}

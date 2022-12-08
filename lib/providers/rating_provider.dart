// import 'dart:convert';
// import 'package:muslim_book/models/rating_model.dart';
// import 'package:muslim_book/network_utils/rating_apis.dart';
// import 'package:muslim_book/providers/view_state_provider.dart';
// import 'package:muslim_book/utils/Constants.dart';
// import 'package:muslim_book/widgets/loading_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:launch_review/launch_review.dart';
// import 'package:responsive_builder/responsive_builder.dart';

// class RatingProvider extends ViewStateProvider {
//   SizingInformation sizeConfig;
//  // String _comment = '';
//   int _stars =0;
//   String _responseMessage;
//   bool _isFormValidateOn = false;

//   String get getResponseMessage =>
//       _responseMessage == null ? '' : _responseMessage;
//  // String get getComment => _comment == null ? '' : _comment;
//   int get getStars => _stars == null ? 0 : _stars;
//   bool get isFormValidateOn => _isFormValidateOn;

//   @override
//   void dispose() {
//     notifyListeners();
//     super.dispose();
//   }

//   set setIsFormValidateOn(bool isFormValidateOn) {
//     _isFormValidateOn = isFormValidateOn;
//     notifyListeners();
//   }

//   // set setComment(String comment) {
//   //   this._comment = comment;
//   // }

//   set setStars(int stars) {
//     this._stars = stars;
//   }

//   checkRating(BuildContext context) async {

//     setIsLoading(context, true);

//     Map<String, dynamic> body = {
//       "comment":"",
//       "stars": _stars== 0? 1.toString() : _stars.toString(),
//     };

//     RatingModel _apiResponseModel = await RatingApis.postRating(body);
//     print(_apiResponseModel.data);
//     if (_apiResponseModel != null) {
//       if (_apiResponseModel.success == true) {
//         String loginModel = json.encode(_apiResponseModel.data);
//         print(loginModel);
//         bool isSaved = _apiResponseModel.success == true;
//         if (isSaved) {
//           setIsLoading(context, false);
//           if (_stars >= 4) {
//             LaunchReview.launch();
//           } else {
//             Constants.startViewPagePosition = 2;
//             Navigator.pushReplacementNamed(context, "/start_view");
//           }
//         } else {
//           _responseMessage = _apiResponseModel.message == null
//               ? 'rating is not valid'
//               : _apiResponseModel.message;
//           setIsLoading(context, false);
//           notifyListeners();
//         }
//       } else {
//         setIsLoading(context, false);
//       }
//       setIsLoading(context, false);
//     } else {
//       notifyListeners();
//     }
//   }
// }

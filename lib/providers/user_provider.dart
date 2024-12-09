import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/models/facebook_model.dart';
import 'package:muslim_book/models/user_model.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class UserProvider extends ViewStateProvider {
  UserProvider() {
    locator<ApiService>().userProvider = this;
  }

  int _selectedPage = 2;
  int get selectedPage => _selectedPage;
  set selectedPage(val) {
    _selectedPage = val;
    notifyListeners();
  }

  String _countryName = '';
  CountryModel _selectedCountry = CountryModel();
  List<CountryModel> _countries = [];
  List<CountryModel> get countries => _countries;

  set countries(List<CountryModel> val) {
    _countries = val;
    notifyListeners();
  }

  CountryModel get selectedCountry => _selectedCountry;

  set selectedCountry(CountryModel val) {
    _selectedCountry = val;
    notifyListeners();
  }

  String get countryName => _countryName;

  set countryName(String value) {
    _countryName = value;
    notifyListeners();
  }

  UserModel _user = UserModel();

  UserModel get user => _user;

  set user(UserModel model) {
    _user = model;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    var res = await locator<ApiService>()
        .login({"email": "$email", "password": "$password"});
    if (res is UserModel) {
      saveUser(res, Constants.LOGIN_WITH_Email, password: password);
      return true;
    } else {
      errorMessage = (res as Failure).message;
      return false;
    }
  }

  void saveUser(
    UserModel res,
    int loginType, {
    String password = '',
    String name = '',
    String id = '',
    String imageUrl = '',
  }) {
    locator<Prefs>().setEmail(res.email ?? '');
    locator<Prefs>().setEmail(res.email ?? '');
    locator<Prefs>().setPassword(password);
    locator<Prefs>().setLoginType(loginType);
    locator<Prefs>().setName(name);
    locator<Prefs>().setId(id);
    locator<Prefs>().setImageUrl(imageUrl);
    locator<Prefs>().setToken(res.apiToken);
    user = res;
  }

  Future<bool> register(Map<String, dynamic> map) async {
    var res = await locator<ApiService>().register(map);
    if (res is UserModel) {
      saveUser(res, Constants.LOGIN_WITH_Email, password: map["password"]);
      return true;
    } else {
      errorMessage = (res as Failure).message;
      return false;
    }
  }

  bool get isLoggedIn => _user.apiToken != null;

  Future checkLogin() async {
    if (locator<Prefs>().loginType == Constants.LOGIN_WITH_Email &&
        locator<Prefs>().getEmail().isNotEmpty &&
        locator<Prefs>().getPassword().isNotEmpty) {
      await login(locator<Prefs>().getEmail(), locator<Prefs>().getPassword());
    } else if (locator<Prefs>().getId().isNotEmpty &&
        locator<Prefs>().getName().isNotEmpty) {
      if (locator<Prefs>().loginType == Constants.LOGIN_WITH_GOOGLE) {
        await googleLogging(null,
            id: locator<Prefs>().getId(),
            name: locator<Prefs>().getName(),
            imageUrl: locator<Prefs>().getImageUrl(),
            email: locator<Prefs>().getEmail());
      } else if (locator<Prefs>().loginType == Constants.LOGIN_WITH_FACEBOOK)
        await faceBookLogging(null,
            id: locator<Prefs>().getId(),
            name: locator<Prefs>().getName(),
            imageUrl: locator<Prefs>().getImageUrl(),
            email: locator<Prefs>().getEmail());
    }
  }

  Future<bool> openGooglePickerDialog() async {
    try {
      GoogleSignInAccount? res = await GoogleSignIn().signIn();
      if (res == null) {
        return false;
      }
      return await googleLogging(res);
    } catch (error) {
      errorMessage = error.toString();
      print(errorMessage);
      return false;
    }
  }

  Future<bool> googleLogging(GoogleSignInAccount? res,
      {name, id, email, imageUrl}) async {
    var response = await locator<ApiService>().googleLogin({
      "email": res == null ? email : res.email,
      "name": res == null ? name : res.displayName,
      "id": res == null ? id : res.id,
      "image_url": res == null ? imageUrl : res.photoUrl
    });
    if (response is UserModel) {
      saveUser(
        response,
        Constants.LOGIN_WITH_GOOGLE,
        name: response.name ?? '',
        id: res == null ? locator<Prefs>().getId() : res.id,
        imageUrl: response.image ?? '',
      );
      return true;
    } else {
      errorMessage = (response as Failure).message;
      return false;
    }
  }

  Future<bool> faceBookLogging(FacebookModel? res,
      {name, id, email, imageUrl}) async {
    var response = await locator<ApiService>().faceBookLogging({
      "email": res == null ? email : res.email,
      "name": res == null ? name : res.name,
      "id": res == null ? id : res.id,
      "image_url": res == null ? imageUrl : res.image
    });
    // FlutterFlexibleToast.showToast(
    //     message: response.name + " login ...",
    //     toastLength: Toast.LENGTH_LONG,
    //     toastGravity: ToastGravity.BOTTOM,
    //     icon: ICON.LOADING,
    //     radius: 100,
    //     elevation: 10,
    //     imageSize: 35,
    //     textColor: Colors.white,
    //     backgroundColor: Colors.black,
    //     timeInSeconds: 2);
    Fluttertoast.showToast(
      msg: response.name + " login ...",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    if (response is UserModel) {
      saveUser(
        response,
        Constants.LOGIN_WITH_FACEBOOK,
        name: response.name ?? '',
        id: res == null ? locator<Prefs>().getId() : res.id ?? '',
        imageUrl: response.image ?? '',
      );
      return true;
    } else {
      errorMessage = (response as Failure).message;
      return false;
    }
  }

  void logOut() {
    locator<Prefs>().setEmail('');
    locator<Prefs>().setPassword('');
    locator<Prefs>().setLoginType(0);
    locator<Prefs>().setName('');
    locator<Prefs>().setId('');
    locator<Prefs>().setImageUrl('');
    user = UserModel();
  }

  Future<void> openFaceBookDialogPicker() async {
    try {
      /*FacebookLoginResult result =
          await facebookSignIn.logIn(['email', 'public_profile']);*/
      final LoginResult result = await FacebookAuth.instance
          .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken? accessToken = result.accessToken;
        if (accessToken != null) {
          // final facebookData = await locator<ApiService>().faceBookAccountDetails(accessToken.accessToken);
          // faceBookLogging(facebookData);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

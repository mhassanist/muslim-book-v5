import 'dart:convert';
import 'dart:io';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/locals_utils/language_constants.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/models/edit_profile_model.dart';
import 'package:muslim_book/models/user_model.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/network_utils/edit_profile_apis.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/NetworkServices.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class EditProfileProvider extends ViewStateProvider {
  List<CountryModel> _countries = [];
  late CountryModel _selectedCountry;
  String? _name;
  String? _fileExtension;
  UserProvider? _userProvider;
  String? _countryName;
  Future<File>? _userSelectedImage;
  String? _userPictureBase64;
  bool _isFormValidateOn = false;

  EditProfileProvider() {
    getCountries();
  }

  Future<File>? get getUserProfileImage => _userSelectedImage;

  set userProvider(UserProvider val) {
    _userProvider = val;
    notifyListeners();
  }

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

  bool get isFormValidateOn => _isFormValidateOn;

  set setIsFormValidateOn(bool isFormValidateOn) {
    _isFormValidateOn = isFormValidateOn;
    notifyListeners();
  }

  set setUserProfileImage(Future<File> selectedImage) {
    _userSelectedImage = selectedImage;
    notifyListeners();
  }

  String get getName => _name ?? '';

  String get countryName => _countryName ?? '';

  set countryName(String value) {
    this._countryName = value;
  }

  set setName(String name) {
    _name = name;
    notifyListeners();
  }

  _createBase64FromFile() async {
    if (_userSelectedImage != null) {
      File file = await _userSelectedImage!;
      _fileExtension = file.path.split("/").last.split(".").last;
      List<int> imageBytes = file.readAsBytesSync();
      return base64Encode(imageBytes);
    }
  }

  Future<bool> checkEdit(String name) async {
    String base = await _createBase64FromFile();
    Map<String, dynamic> body = {
      "email": _userProvider!.user.email,
      "name": name,
      "country_id": "${_selectedCountry.id}",
      "city_id": '1',
      "image": _userSelectedImage != null
          ? "data:image/$_fileExtension;base64,$base"
          : null,
    };
         var res = await locator<ApiService>().editProfile(body);
    if (res is UserModel) {
      _userProvider!.user = res;
      return true;
    } else {
      errorMessage = (res as Failure).message;
      return false;
    }
  }

  void getCountries() async {
    String code="ar";
    setViewState(ViewState.Loading);
    var local=await getLocale();
    code=local.languageCode;
    CountriesModel model = await locator<ApiService>().getCountries(code);
    if (model != null) {
      _countries = model.data;
      if (_userProvider!.user.countryId != 0) {
        _selectedCountry =
            countries.singleWhere((f) => f.id == _userProvider!.user.countryId);
        _countryName = countries
            .singleWhere((f) => f.id == _userProvider!.user.countryId)
            .name;
      }
    }
    setViewState(ViewState.Idle);
  }
}

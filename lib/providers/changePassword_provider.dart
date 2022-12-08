import 'package:muslim_book/providers/view_state_provider.dart';

class ChangePasswordProvider extends ViewStateProvider {
  //BuildContext _context;
  String? _email;
  String? _password;
  String? _phoneNo;
  String? _countryName;
  String? _pickedCountryName;

  @override
  void dispose() {   
     notifyListeners();
    super.dispose();
  }

  // set context(BuildContext value) {
  //   this._context = value;
  // }

  set setPhoneNo(String phoneNo) {
    this._phoneNo = phoneNo;
  }

  set setEmail(String email) {
    this._email = email;
  }

  set setPassowrd(String password) {
    this._password = password;
  }

  String get getEmail => _email ?? '';
  String get getPassword => _password ?? '';
  String get getPhoneNo => _phoneNo ?? '';

  set pickedCountryName(String s) {
    _pickedCountryName = s;
    // locator<Prefs>().setCountry(s);
    notifyListeners();
  }

  String get pickedCountryName => _pickedCountryName ?? '';
  String get countryName => _countryName ?? '';

  set countryName(String value) {
    this._countryName = value;
  }

}

import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/interceptors/connection_interceptor.dart';
import 'package:muslim_book/interceptors/error_interceptor.dart';
import 'package:muslim_book/ramadan/models/ramadan_cannon_model.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:dio/dio.dart';

class RamadanCannonAPI {
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      baseUrl: Constants.BASE_URL,
      headers: {"X-localization": locator<Prefs>().getLang(),
        "Authorization":"Bearer YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"}));

  RamadanCannonAPI() {
    _dio.interceptors.add(ConnectionInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Future requestRamadanCannon() async {
    var response = await _dio.get("ramadan/mp3/2");
    if (!(response.data is Failure)) {
      List<RamadanSoundsModel> model=List<RamadanSoundsModel>.from( response.data["data"].map((x) => RamadanSoundsModel.fromJson(x)));
      return model;
    } else {
      return response.data;
    }

  }

}
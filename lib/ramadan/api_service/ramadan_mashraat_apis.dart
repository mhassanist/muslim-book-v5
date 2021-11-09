
import 'package:base_app/exceptions/failure.dart';
import 'package:base_app/interceptors/connection_interceptor.dart';
import 'package:base_app/interceptors/error_interceptor.dart';
import 'package:base_app/ramadan/models/ramadan_cannon_model.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:dio/dio.dart';

class RamadanMashraatAAPI {
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: 1000 * 30,
      baseUrl: Constants.BASE_URL,
      headers: {"X-localization": "${locator<Prefs>().getLang()}",
        "Authorization":"Bearer YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"}));

  RamadanMashraatAAPI() {
    _dio.interceptors.add(ConnectionInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Future requestRamadanMashraat() async {
    var response = await _dio.get("ramadan/mp3/1");
    //print("requestRamadanMashraat " +response.data["data"].toString());
    if (!(response.data is Failure)) {
      List<RamadanSoundsModel> model=List<RamadanSoundsModel>.from( response.data["data"].map((x) => RamadanSoundsModel.fromJson(x)));
      return model;
    } else {
      return response.data;
    }
  }

}
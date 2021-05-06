class CountryCities {
  List<City> cities;

  CountryCities.fromMap(List listMap)
      : cities = listMap == null ? [] : _citiesParsing(listMap);

  static List<City> _citiesParsing(List citiesList) {
    List<City> citiesListToReturn = List<City>();
    citiesList.forEach((c) {
      citiesListToReturn.add(City.fromMap(c));
    });
    return citiesListToReturn;
  }
}

class City {
  String city;
  String countryCode;

  City({this.city, this.countryCode});

  City.fromMap(Map<String, dynamic> map)
      : city = map['region'],
        countryCode = map['country'];
}

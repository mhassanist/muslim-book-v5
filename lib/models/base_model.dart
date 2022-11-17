mixin Model {
  String stringFromJson(
    Map<String, dynamic>? json,
    String attribute, {
    String defaultValue = '',
  }) {
    try {
      return json != null
          ? json[attribute] != null
              ? json[attribute].toString()
              : defaultValue
          : defaultValue;
    } catch (e) {
      print('Error while parsing $attribute[$e]');
      return defaultValue;
    }
  }

  int intFromJson(
    Map<String, dynamic>? json,
    String attribute, {
    int defaultValue = 0,
  }) {
    try {
      if (json != null && json[attribute] != null) {
        if (json[attribute] is int) {
          return json[attribute] as int;
        }
        return int.parse(json[attribute] as String);
      }
      return defaultValue;
    } catch (e) {
      print('Error while parsing $attribute[${e.toString()}]');
      return defaultValue;
    }
  }

  double doubleFromJson(
    Map<String, dynamic>? json,
    String attribute, {
    int decimal = 2,
    double defaultValue = 0.0,
  }) {
    try {
      if (json != null && json[attribute] != null) {
        if (json[attribute] is double) {
          return double.parse(
            (json[attribute] as double).toStringAsFixed(decimal),
          );
        }
        if (json[attribute] is int) {
          return double.parse(
            (json[attribute] as int).toDouble().toStringAsFixed(decimal),
          );
        }
        return double.parse(
          double.tryParse(json[attribute] as String)!.toStringAsFixed(decimal),
        );
      }
      return double.parse(defaultValue.toStringAsFixed(decimal));
    } catch (e) {
      print('Error while parsing $attribute[${e.toString()}]');
      return defaultValue;
    }
  }

  bool boolFromJson(
    Map<String, dynamic>? json,
    String attribute, {
    bool defaultValue = false,
  }) {
    try {
      if (json != null && json[attribute] != null) {
        if (json[attribute] is bool) {
          return json[attribute] as bool;
        } else if ((json[attribute] is String) &&
            !['0', '', 'false'].contains(json[attribute])) {
          return true;
        } else if ((json[attribute] is int) &&
            ![0, -1].contains(json[attribute])) {
          return true;
        }
        return false;
      }
      return defaultValue;
    } catch (e) {
      print('Error while parsing $attribute[${e.toString()}]');
      return defaultValue;
    }
  }

  T objectFromJson<T>(
    Map<String, dynamic>? json,
    String attribute,
    T Function(Map<String, dynamic>) callback, {
    T? defaultValue,
  }) {
    try {
      if (json != null &&
          json[attribute] != null &&
          json[attribute] is Map<String, dynamic>) {
        return callback(json[attribute] as Map<String, dynamic>);
      }
      return defaultValue ?? T as T;
    } catch (e) {
      print('Error while parsing $attribute[${e.toString()}]');
      return defaultValue ?? T as T;
    }
  }

  List<T> listFromJson<T>(
    Map<String, dynamic>? json,
    String attribute,
    T Function(Map<String, dynamic>) callback,
  ) {
    final list = <T>[];
    try {
      if (json != null &&
          json[attribute] != null &&
          json[attribute] is List &&
          (json[attribute] as List).isNotEmpty) {
        for (final v in json[attribute] as List) {
          if (v is Map<String, dynamic>) {
            list.add(callback(v));
          }
        }
      }
      return list;
    } catch (e) {
      print('Error while parsing $attribute[${e.toString()}]');
      return list;
    }
  }
}

enum Abbreviated {
  ad('AD'),
  ah('AH');

  final String value;

  const Abbreviated(this.value);

  factory Abbreviated.fromStringValue(String value) {
    return value == 'AD' ? Abbreviated.ad : Abbreviated.ah;
  }
}

enum Expanded {
  annoDomini('Anno Domini'),
  annoHegirae('Anno Hegirae');

  final String value;

  const Expanded(this.value);

  factory Expanded.fromStringValue(String value) {
    return value == 'Anno Domini' ? Expanded.annoDomini : Expanded.annoHegirae;
  }
}

enum Format {
  DD_MM_YYYY('DD-MM-YYYY');

  final String value;

  const Format(this.value);

  factory Format.fromStringValue(String value) {
    return Format.DD_MM_YYYY;
  }
}

enum PurpleEn {
  APRIL('April');

  final String value;

  const PurpleEn(this.value);

  factory PurpleEn.fromStringValue(String value) {
    return PurpleEn.APRIL;
  }
}

enum Ar {
  empty('رَمَضان'),
  ar('شَعْبان');

  final String value;

  const Ar(this.value);

  factory Ar.fromStringValue(String value) {
    return value == 'رَمَضان' ? Ar.empty: Ar.ar;
  }
}

enum FluffyEn {
  shaBn('Shaʿbān'),
  ramadan('Ramaḍān');

  final String value;

  const FluffyEn(this.value);

  factory FluffyEn.fromStringValue(String value) {
    return value == 'Ramaḍān' ? FluffyEn.ramadan: FluffyEn.shaBn;
  }
}

enum LatitudeAdjustmentMethod {
  angleBased('ANGLE_BASED');

  final String value;

  const LatitudeAdjustmentMethod(this.value);

  factory LatitudeAdjustmentMethod.fromStringValue(String value) {
    return LatitudeAdjustmentMethod.angleBased;
  }
}

enum Name {
  egyptianGeneralAuthorityOfSurvey('Egyptian General Authority of Survey');

  final String value;

  const Name(this.value);

  factory Name.fromStringValue(String value) {
    return Name.egyptianGeneralAuthorityOfSurvey;
  }
}

enum MidnightMode {
  standard('STANDARD');

  final String value;

  const MidnightMode(this.value);

  factory MidnightMode.fromStringValue(String value) {
    return MidnightMode.standard;
  }
}

enum Timezone {
  africaCairo('Africa/Cairo');

  final String value;

  const Timezone(this.value);

  factory Timezone.fromStringValue(String value) {
    return Timezone.africaCairo;
  }
}

enum Asr {
  the1531EET('15:31 (EET)');

  final String value;

  const Asr(this.value);

  factory Asr.fromStringValue(String value) {
    return Asr.the1531EET;
  }
}

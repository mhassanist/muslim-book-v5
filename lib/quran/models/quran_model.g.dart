// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranModelAdapter extends TypeAdapter<QuranModel> {
  @override
  final int typeId = 0;

  @override
  QuranModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranModel(
      surahs: (fields[0] as List).cast<Surah>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuranModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.surahs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SurahAdapter extends TypeAdapter<Surah> {
  @override
  final int typeId = 1;

  @override
  Surah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Surah(
      number: fields[0] as int,
      name: fields[1] as String,
      englishName: fields[2] as String,
      englishNameTranslation: fields[3] as String,
      revelationType: fields[4] as String,
      ayahs: (fields[5] as List).cast<Ayah>(),
      progress: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Surah obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.englishName)
      ..writeByte(3)
      ..write(obj.englishNameTranslation)
      ..writeByte(4)
      ..write(obj.revelationType)
      ..writeByte(5)
      ..write(obj.ayahs)
      ..writeByte(6)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AyahAdapter extends TypeAdapter<Ayah> {
  @override
  final int typeId = 2;

  @override
  Ayah read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ayah(
      number: fields[0] as int?,
      text: fields[1] as String,
      numberInSurah: fields[2] as int,
      juz: fields[3] as int?,
      manzil: fields[4] as int?,
      page: fields[5] as int?,
      ruku: fields[6] as int?,
      hizbQuarter: fields[7] as int?,
      sajda: fields[8] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Ayah obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.numberInSurah)
      ..writeByte(3)
      ..write(obj.juz)
      ..writeByte(4)
      ..write(obj.manzil)
      ..writeByte(5)
      ..write(obj.page)
      ..writeByte(6)
      ..write(obj.ruku)
      ..writeByte(7)
      ..write(obj.hizbQuarter)
      ..writeByte(8)
      ..write(obj.sajda);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuranUserModelAdapter extends TypeAdapter<QuranUserModel> {
  @override
  final int typeId = 3;

  @override
  QuranUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranUserModel(
      lastReadAyahId: fields[1] as int?,
      lastReadSurahId: fields[0] as int?,
      selectedReciter: fields[2] as QuranTypeData?,
      allowTranslation: fields[3] as bool?,
      allowTransliteration: fields[4] as bool?,
    )
      ..selectedTranslation = fields[5] as String?
      ..selectedTransliteration = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, QuranUserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.lastReadSurahId)
      ..writeByte(1)
      ..write(obj.lastReadAyahId)
      ..writeByte(2)
      ..write(obj.selectedReciter)
      ..writeByte(3)
      ..write(obj.allowTranslation)
      ..writeByte(4)
      ..write(obj.allowTransliteration)
      ..writeByte(5)
      ..write(obj.selectedTranslation)
      ..writeByte(6)
      ..write(obj.selectedTransliteration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

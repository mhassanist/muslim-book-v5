// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reciters_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranTypeModelAdapter extends TypeAdapter<QuranTypeModel> {
  @override
  final int typeId = 4;

  @override
  QuranTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranTypeModel(
      data: (fields[0] as List)?.cast<QuranTypeData>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuranTypeModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuranTypeDataAdapter extends TypeAdapter<QuranTypeData> {
  @override
  final int typeId = 5;

  @override
  QuranTypeData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranTypeData(
      identifier: fields[0] as String,
      language: fields[1] as String,
      name: fields[2] as String,
      englishName: fields[3] as String,
      type: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuranTypeData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.identifier)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.englishName)
      ..writeByte(4)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranTypeDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penilaian.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PenilaianAdapter extends TypeAdapter<Penilaian> {
  @override
  final int typeId = 2;

  @override
  Penilaian read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Penilaian(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      rating: fields[2] as int,
      category: fields[3] as String,
      feedback: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Penilaian obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.feedback);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PenilaianAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

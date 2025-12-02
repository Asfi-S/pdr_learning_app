// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 10;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      username: fields[0] as String,
      xp: fields[1] as int,
      level: fields[2] as int,
      testsPassed: fields[3] as int,
      correctAnswers: fields[4] as int,
      wrongAnswers: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.xp)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.testsPassed)
      ..writeByte(4)
      ..write(obj.correctAnswers)
      ..writeByte(5)
      ..write(obj.wrongAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

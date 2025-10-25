// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      phone: fields[3] as String,
      themes: (fields[5] as List?)?.cast<EspTheme>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.themes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SdcardAdapter extends TypeAdapter<Sdcard> {
  @override
  final int typeId = 2;

  @override
  Sdcard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sdcard(
      token: fields[0] as String?,
      user: fields[1] as User?,
      sleepValue: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sdcard obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.sleepValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SdcardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentItemAdapter extends TypeAdapter<ContentItem> {
  @override
  final int typeId = 4;

  @override
  ContentItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentItem(
      s: fields[0] as int,
      e: fields[1] as int,
      m: fields[2] as int,
      sp: fields[3] as int,
      c: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ContentItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.s)
      ..writeByte(1)
      ..write(obj.e)
      ..writeByte(2)
      ..write(obj.m)
      ..writeByte(3)
      ..write(obj.sp)
      ..writeByte(4)
      ..write(obj.c);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EspThemeAdapter extends TypeAdapter<EspTheme> {
  @override
  final int typeId = 3;

  @override
  EspTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EspTheme(
      id: fields[0] as int,
      name: fields[1] as String,
      content: (fields[2] as List).cast<ContentItem>(),
      description: fields[3] as String,
      image_url: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EspTheme obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.image_url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EspThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

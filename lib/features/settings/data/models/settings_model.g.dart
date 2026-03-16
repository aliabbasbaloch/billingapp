// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      shopName: fields[0] as String,
      addressLine1: fields[1] as String,
      addressLine2: fields[2] as String,
      phoneNumber: fields[3] as String,
      receiptFooter: fields[4] as String,
      easyPaisaTitle: fields[5] as String?,
      easyPaisaNumber: fields[6] as String?,
      jazzCashTitle: fields[7] as String?,
      jazzCashNumber: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.addressLine1)
      ..writeByte(2)
      ..write(obj.addressLine2)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.receiptFooter)
      ..writeByte(5)
      ..write(obj.easyPaisaTitle)
      ..writeByte(6)
      ..write(obj.easyPaisaNumber)
      ..writeByte(7)
      ..write(obj.jazzCashTitle)
      ..writeByte(8)
      ..write(obj.jazzCashNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

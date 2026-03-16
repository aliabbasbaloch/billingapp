import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  String shopName;

  @HiveField(1)
  String addressLine1;

  @HiveField(2)
  String addressLine2;

  @HiveField(3)
  String phoneNumber;

  @HiveField(4)
  String receiptFooter;

  @HiveField(5)
  String? easyPaisaTitle;

  @HiveField(6)
  String? easyPaisaNumber;

  @HiveField(7)
  String? jazzCashTitle;

  @HiveField(8)
  String? jazzCashNumber;

  SettingsModel({
    required this.shopName,
    required this.addressLine1,
    required this.addressLine2,
    required this.phoneNumber,
    required this.receiptFooter,
    this.easyPaisaTitle,
    this.easyPaisaNumber,
    this.jazzCashTitle,
    this.jazzCashNumber,
  });

  SettingsModel copyWith({
    String? shopName,
    String? addressLine1,
    String? addressLine2,
    String? phoneNumber,
    String? receiptFooter,
    String? easyPaisaTitle,
    String? easyPaisaNumber,
    String? jazzCashTitle,
    String? jazzCashNumber,
  }) {
    return SettingsModel(
      shopName: shopName ?? this.shopName,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      easyPaisaTitle: easyPaisaTitle ?? this.easyPaisaTitle,
      easyPaisaNumber: easyPaisaNumber ?? this.easyPaisaNumber,
      jazzCashTitle: jazzCashTitle ?? this.jazzCashTitle,
      jazzCashNumber: jazzCashNumber ?? this.jazzCashNumber,
    );
  }
}

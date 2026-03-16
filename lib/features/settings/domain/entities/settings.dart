import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final String shopName;
  final String addressLine1;
  final String addressLine2;
  final String phoneNumber;
  final String receiptFooter;
  final String? easyPaisaTitle;
  final String? easyPaisaNumber;
  final String? jazzCashTitle;
  final String? jazzCashNumber;

  const Settings({
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

  @override
  List<Object?> get props => [
        shopName,
        addressLine1,
        addressLine2,
        phoneNumber,
        receiptFooter,
        easyPaisaTitle,
        easyPaisaNumber,
        jazzCashTitle,
        jazzCashNumber,
      ];
}

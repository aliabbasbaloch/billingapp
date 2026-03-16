import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String productName;
  final double unitPrice;
  final String barcode;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.barcode,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? productId,
    String? productName,
    double? unitPrice,
    String? barcode,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props =>
      [productId, productName, unitPrice, barcode, quantity];
}

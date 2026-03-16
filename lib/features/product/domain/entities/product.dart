import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String barcode;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.barcode,
  });

  @override
  List<Object?> get props => [id, name, price, barcode];
}

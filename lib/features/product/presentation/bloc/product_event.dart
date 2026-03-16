part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class AddProductEvent extends ProductEvent {
  final String name;
  final double price;
  final String barcode;

  const AddProductEvent({
    required this.name,
    required this.price,
    required this.barcode,
  });

  @override
  List<Object?> get props => [name, price, barcode];
}

class UpdateProductEvent extends ProductEvent {
  final ProductModel product;

  const UpdateProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends ProductEvent {
  final String id;

  const DeleteProductEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchProducts extends ProductEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

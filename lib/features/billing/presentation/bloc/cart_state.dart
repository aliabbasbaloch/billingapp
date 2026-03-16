part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get grandTotal => items.fold(0, (sum, i) => sum + i.totalPrice);
  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billingapp/features/billing/domain/entities/cart_item.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQty>(_onUpdateQty);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.product.id);
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(quantity: items[idx].quantity + 1);
    } else {
      items.add(CartItem(
        productId: event.product.id,
        productName: event.product.name,
        unitPrice: event.product.price,
        barcode: event.product.barcode,
      ));
    }
    emit(state.copyWith(items: items));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final items = state.items
        .where((i) => i.productId != event.productId)
        .toList();
    emit(state.copyWith(items: items));
  }

  void _onUpdateQty(UpdateCartItemQty event, Emitter<CartState> emit) {
    final items = List<CartItem>.from(state.items);
    final idx = items.indexWhere((i) => i.productId == event.productId);
    if (idx >= 0) {
      if (event.quantity <= 0) {
        items.removeAt(idx);
      } else {
        items[idx] = items[idx].copyWith(quantity: event.quantity);
      }
    }
    emit(state.copyWith(items: items));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}

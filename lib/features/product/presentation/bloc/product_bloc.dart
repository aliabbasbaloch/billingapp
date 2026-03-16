import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:billingapp/core/usecase/usecase.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/features/product/domain/usecases/product_usecases.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductByBarcode getProductByBarcode;
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getProducts,
    required this.getProductByBarcode,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
    on<SearchProducts>(_onSearchProducts);
  }

  List<ProductModel> _allProducts = [];

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        _allProducts = products;
        emit(ProductLoaded(products));
      },
    );
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    final product = ProductModel(
      id: const Uuid().v4(),
      name: event.name,
      price: event.price,
      barcode: event.barcode,
    );
    final result = await addProduct(product);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => add(LoadProducts()),
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    final result = await updateProduct(event.product);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => add(LoadProducts()),
    );
  }

  Future<void> _onDeleteProduct(
      DeleteProductEvent event, Emitter<ProductState> emit) async {
    final result = await deleteProduct(event.id);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (_) => add(LoadProducts()),
    );
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (event.query.isEmpty) {
      emit(ProductLoaded(_allProducts));
      return;
    }
    final filtered = _allProducts
        .where((p) =>
            p.name.toLowerCase().contains(event.query.toLowerCase()) ||
            p.barcode.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(ProductLoaded(filtered));
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/core/usecase/usecase.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/features/product/domain/repositories/product_repository.dart';

class GetProducts implements UseCase<List<ProductModel>, NoParams> {
  final ProductRepository repository;
  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<ProductModel>>> call(NoParams params) {
    return repository.getProducts();
  }
}

class GetProductByBarcode implements UseCase<ProductModel?, String> {
  final ProductRepository repository;
  GetProductByBarcode(this.repository);

  @override
  Future<Either<Failure, ProductModel?>> call(String barcode) {
    return repository.getProductByBarcode(barcode);
  }
}

class AddProduct implements UseCase<void, ProductModel> {
  final ProductRepository repository;
  AddProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(ProductModel product) {
    return repository.addProduct(product);
  }
}

class UpdateProduct implements UseCase<void, ProductModel> {
  final ProductRepository repository;
  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(ProductModel product) {
    return repository.updateProduct(product);
  }
}

class DeleteProduct implements UseCase<void, String> {
  final ProductRepository repository;
  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.deleteProduct(id);
  }
}

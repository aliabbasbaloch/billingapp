import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/data/hive_database.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final box = HiveDatabase.productsStore;
      return Right(box.values.toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductModel?>> getProductByBarcode(
      String barcode) async {
    try {
      final box = HiveDatabase.productsStore;
      final product = box.values.cast<ProductModel?>().firstWhere(
            (p) => p?.barcode == barcode,
            orElse: () => null,
          );
      return Right(product);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductModel product) async {
    try {
      final box = HiveDatabase.productsStore;
      await box.put(product.id, product);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      final box = HiveDatabase.productsStore;
      await box.put(product.id, product);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      final box = HiveDatabase.productsStore;
      await box.delete(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

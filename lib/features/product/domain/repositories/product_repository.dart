import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/features/product/domain/entities/product.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, ProductModel?>> getProductByBarcode(String barcode);
  Future<Either<Failure, void>> addProduct(ProductModel product);
  Future<Either<Failure, void>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct(String id);
}

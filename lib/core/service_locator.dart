import 'package:get_it/get_it.dart';
import 'package:billingapp/features/product/data/repositories/product_repository_impl.dart';
import 'package:billingapp/features/product/domain/repositories/product_repository.dart';
import 'package:billingapp/features/product/domain/usecases/product_usecases.dart';
import 'package:billingapp/features/product/presentation/bloc/product_bloc.dart';
import 'package:billingapp/features/billing/presentation/bloc/cart_bloc.dart';
import 'package:billingapp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:billingapp/features/settings/domain/repositories/settings_repository.dart';
import 'package:billingapp/features/settings/domain/usecases/settings_usecases.dart';
import 'package:billingapp/features/settings/presentation/bloc/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProductByBarcode(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));

  // BLoCs - registered as lazy singletons so state persists across navigation
  sl.registerLazySingleton(
    () => ProductBloc(
      getProducts: sl(),
      getProductByBarcode: sl(),
      addProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
    ),
  );
  sl.registerLazySingleton(() => CartBloc());
  sl.registerLazySingleton(
    () => SettingsBloc(
      getSettings: sl(),
      saveSettings: sl(),
    ),
  );
}

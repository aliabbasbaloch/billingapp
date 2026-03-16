import 'package:hive_flutter/hive_flutter.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';

class HiveDatabase {
  static const String productsBox = 'products';
  static const String settingsBox = 'settings';
  static const String invoiceCounterBox = 'invoice_counter';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(SettingsModelAdapter());

    // Open boxes
    await Hive.openBox<ProductModel>(productsBox);
    await Hive.openBox<SettingsModel>(settingsBox);
    await Hive.openBox<int>(invoiceCounterBox);
  }

  static Box<ProductModel> get productsStore =>
      Hive.box<ProductModel>(productsBox);

  static Box<SettingsModel> get settingsStore =>
      Hive.box<SettingsModel>(settingsBox);

  static Box<int> get invoiceCounterStore =>
      Hive.box<int>(invoiceCounterBox);
}

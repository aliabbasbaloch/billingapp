import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:billingapp/core/service_locator.dart';
import 'package:billingapp/core/data/hive_database.dart';
import 'package:billingapp/config/routes/app_routes.dart';
import 'package:billingapp/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDatabase.init();
  await setupServiceLocator();
  runApp(const BillingApp());
}

class BillingApp extends StatelessWidget {
  const BillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Billing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRoutes.router,
    );
  }
}

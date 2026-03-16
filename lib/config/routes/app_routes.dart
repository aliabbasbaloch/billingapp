import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billingapp/core/service_locator.dart';
import 'package:billingapp/features/billing/presentation/bloc/cart_bloc.dart';
import 'package:billingapp/features/product/presentation/bloc/product_bloc.dart';
import 'package:billingapp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:billingapp/features/billing/presentation/pages/home_page.dart';
import 'package:billingapp/features/billing/presentation/pages/scanner_page.dart';
import 'package:billingapp/features/billing/presentation/pages/checkout_page.dart';
import 'package:billingapp/features/invoice/presentation/pages/invoice_preview_page.dart';
import 'package:billingapp/features/product/presentation/pages/product_list_page.dart';
import 'package:billingapp/features/product/presentation/pages/add_product_page.dart';
import 'package:billingapp/features/product/presentation/pages/edit_product_page.dart';
import 'package:billingapp/features/settings/presentation/pages/settings_page.dart';
import 'package:billingapp/features/product/data/models/product_model.dart';
import 'package:billingapp/features/billing/domain/entities/cart_item.dart';

class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: sl<CartBloc>()),
              BlocProvider.value(value: sl<ProductBloc>()..add(LoadProducts())),
              BlocProvider.value(
                  value: sl<SettingsBloc>()..add(LoadSettings())),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
            routes: [
              GoRoute(
                path: 'scanner',
                builder: (context, state) => const ScannerPage(),
              ),
              GoRoute(
                path: 'checkout',
                builder: (context, state) => const CheckoutPage(),
              ),
              GoRoute(
                path: 'invoice',
                builder: (context, state) {
                  final cartItems = state.extra as List<CartItem>;
                  return InvoicePreviewPage(cartItems: cartItems);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductListPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddProductPage(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final product = state.extra as ProductModel;
                  return EditProductPage(product: product);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

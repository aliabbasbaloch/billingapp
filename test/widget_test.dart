import 'package:flutter_test/flutter_test.dart';
import 'package:billingapp/features/billing/domain/entities/cart_item.dart';
import 'package:billingapp/core/utils/currency_formatter.dart';

void main() {
  group('CartItem', () {
    test('calculates totalPrice correctly', () {
      const item = CartItem(
        productId: '1',
        productName: 'Test Product',
        unitPrice: 100.0,
        barcode: '123456',
        quantity: 3,
      );
      expect(item.totalPrice, 300.0);
    });

    test('copyWith creates new item with updated fields', () {
      const item = CartItem(
        productId: '1',
        productName: 'Test Product',
        unitPrice: 100.0,
        barcode: '123456',
        quantity: 1,
      );
      final updated = item.copyWith(quantity: 5);
      expect(updated.quantity, 5);
      expect(updated.productName, 'Test Product');
    });
  });

  group('CurrencyFormatter', () {
    test('formats currency correctly', () {
      final formatted = CurrencyFormatter.format(1500.50);
      expect(formatted, contains('PKR'));
      expect(formatted, contains('1,500.50'));
    });
  });
}

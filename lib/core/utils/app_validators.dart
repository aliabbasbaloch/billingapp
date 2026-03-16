class AppValidators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Enter a valid price';
    }
    return null;
  }

  static String? validateBarcode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Barcode/SKU is required';
    }
    return null;
  }
}

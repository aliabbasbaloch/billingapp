import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:billingapp/core/utils/app_validators.dart';
import 'package:billingapp/core/widgets/input_label.dart';
import 'package:billingapp/core/widgets/primary_button.dart';
import 'package:billingapp/features/product/presentation/bloc/product_bloc.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _barcodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProductBloc>().add(
          AddProductEvent(
            name: _nameController.text.trim(),
            price: double.parse(_priceController.text.trim()),
            barcode: _barcodeController.text.trim(),
          ),
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InputLabel(label: 'Product Name', required: true),
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: 'e.g. Surf Excel 500g'),
                validator: (v) => AppValidators.validateRequired(v, 'Name'),
              ),
              const SizedBox(height: 20),
              const InputLabel(label: 'Price (PKR)', required: true),
              TextFormField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                    hintText: 'e.g. 250', prefixText: 'PKR '),
                validator: AppValidators.validatePrice,
              ),
              const SizedBox(height: 20),
              const InputLabel(label: 'Barcode / SKU', required: true),
              TextFormField(
                controller: _barcodeController,
                decoration:
                    const InputDecoration(hintText: 'e.g. 8901234567890'),
                validator: AppValidators.validateBarcode,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Add Product',
                icon: Icons.add,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

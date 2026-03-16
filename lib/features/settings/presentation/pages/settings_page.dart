import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billingapp/core/widgets/input_label.dart';
import 'package:billingapp/core/widgets/primary_button.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';
import 'package:billingapp/features/settings/presentation/bloc/settings_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _shopNameCtrl;
  late final TextEditingController _addr1Ctrl;
  late final TextEditingController _addr2Ctrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _footerCtrl;
  late final TextEditingController _epTitleCtrl;
  late final TextEditingController _epNumberCtrl;
  late final TextEditingController _jcTitleCtrl;
  late final TextEditingController _jcNumberCtrl;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _shopNameCtrl = TextEditingController();
    _addr1Ctrl = TextEditingController();
    _addr2Ctrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _footerCtrl = TextEditingController(text: 'Thank you, visit again!');
    _epTitleCtrl = TextEditingController();
    _epNumberCtrl = TextEditingController();
    _jcTitleCtrl = TextEditingController();
    _jcNumberCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _shopNameCtrl.dispose();
    _addr1Ctrl.dispose();
    _addr2Ctrl.dispose();
    _phoneCtrl.dispose();
    _footerCtrl.dispose();
    _epTitleCtrl.dispose();
    _epNumberCtrl.dispose();
    _jcTitleCtrl.dispose();
    _jcNumberCtrl.dispose();
    super.dispose();
  }

  void _populateFromSettings(SettingsModel settings) {
    _shopNameCtrl.text = settings.shopName;
    _addr1Ctrl.text = settings.addressLine1;
    _addr2Ctrl.text = settings.addressLine2;
    _phoneCtrl.text = settings.phoneNumber;
    _footerCtrl.text = settings.receiptFooter;
    _epTitleCtrl.text = settings.easyPaisaTitle ?? '';
    _epNumberCtrl.text = settings.easyPaisaNumber ?? '';
    _jcTitleCtrl.text = settings.jazzCashTitle ?? '';
    _jcNumberCtrl.text = settings.jazzCashNumber ?? '';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final model = SettingsModel(
      shopName: _shopNameCtrl.text.trim(),
      addressLine1: _addr1Ctrl.text.trim(),
      addressLine2: _addr2Ctrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      receiptFooter: _footerCtrl.text.trim(),
      easyPaisaTitle: _epTitleCtrl.text.trim().isNotEmpty
          ? _epTitleCtrl.text.trim()
          : null,
      easyPaisaNumber: _epNumberCtrl.text.trim().isNotEmpty
          ? _epNumberCtrl.text.trim()
          : null,
      jazzCashTitle: _jcTitleCtrl.text.trim().isNotEmpty
          ? _jcTitleCtrl.text.trim()
          : null,
      jazzCashNumber: _jcNumberCtrl.text.trim().isNotEmpty
          ? _jcNumberCtrl.text.trim()
          : null,
    );
    context.read<SettingsBloc>().add(SaveSettingsEvent(model));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded && state.settings != null && !_initialized) {
            _populateFromSettings(state.settings!);
            _initialized = true;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('🏪 Shop Details'),
                  const SizedBox(height: 12),
                  const InputLabel(label: 'Shop Name', required: true),
                  TextFormField(
                    controller: _shopNameCtrl,
                    decoration:
                        const InputDecoration(hintText: 'e.g. Ali Electronics'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Shop name is required'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const InputLabel(label: 'Address Line 1'),
                  TextFormField(
                    controller: _addr1Ctrl,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Shop #5, Main Bazaar'),
                  ),
                  const SizedBox(height: 16),
                  const InputLabel(label: 'Address Line 2 (Optional)'),
                  TextFormField(
                    controller: _addr2Ctrl,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Karachi, Sindh'),
                  ),
                  const SizedBox(height: 16),
                  const InputLabel(label: 'Phone Number'),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration:
                        const InputDecoration(hintText: 'e.g. 03001234567'),
                  ),
                  const SizedBox(height: 16),
                  const InputLabel(label: 'Receipt Footer Text'),
                  TextFormField(
                    controller: _footerCtrl,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Thank you, visit again!'),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('💳 Payment Details'),
                  const SizedBox(height: 4),
                  const Text(
                    'Payment details will appear at the bottom of the invoice.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _paymentSection(
                    title: 'Easypaisa',
                    color: const Color(0xFF00A651),
                    titleCtrl: _epTitleCtrl,
                    numberCtrl: _epNumberCtrl,
                  ),
                  const SizedBox(height: 16),
                  _paymentSection(
                    title: 'JazzCash',
                    color: const Color(0xFFD71920),
                    titleCtrl: _jcTitleCtrl,
                    numberCtrl: _jcNumberCtrl,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Save Settings',
                    icon: Icons.save,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _paymentSection({
    required String title,
    required Color color,
    required TextEditingController titleCtrl,
    required TextEditingController numberCtrl,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const InputLabel(label: 'Account Title'),
            TextFormField(
              controller: titleCtrl,
              decoration:
                  const InputDecoration(hintText: 'Name on account'),
            ),
            const SizedBox(height: 12),
            const InputLabel(label: 'Account Number'),
            TextFormField(
              controller: numberCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  hintText: 'Mobile number linked to account'),
            ),
          ],
        ),
      ),
    );
  }
}

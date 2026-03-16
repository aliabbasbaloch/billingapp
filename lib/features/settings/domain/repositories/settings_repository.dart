import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, SettingsModel?>> getSettings();
  Future<Either<Failure, void>> saveSettings(SettingsModel settings);
}

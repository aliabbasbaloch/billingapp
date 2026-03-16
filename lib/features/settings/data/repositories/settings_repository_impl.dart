import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/data/hive_database.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';
import 'package:billingapp/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _key = 'app_settings';

  @override
  Future<Either<Failure, SettingsModel?>> getSettings() async {
    try {
      final box = HiveDatabase.settingsStore;
      return Right(box.get(_key));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(SettingsModel settings) async {
    try {
      final box = HiveDatabase.settingsStore;
      await box.put(_key, settings);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

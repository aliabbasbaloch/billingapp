import 'package:fpdart/fpdart.dart';
import 'package:billingapp/core/error/failure.dart';
import 'package:billingapp/core/usecase/usecase.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';
import 'package:billingapp/features/settings/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<SettingsModel?, NoParams> {
  final SettingsRepository repository;
  GetSettings(this.repository);

  @override
  Future<Either<Failure, SettingsModel?>> call(NoParams params) {
    return repository.getSettings();
  }
}

class SaveSettings implements UseCase<void, SettingsModel> {
  final SettingsRepository repository;
  SaveSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(SettingsModel settings) {
    return repository.saveSettings(settings);
  }
}

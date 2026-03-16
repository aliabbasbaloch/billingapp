import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:billingapp/core/usecase/usecase.dart';
import 'package:billingapp/features/settings/data/models/settings_model.dart';
import 'package:billingapp/features/settings/domain/usecases/settings_usecases.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final SaveSettings saveSettings;

  SettingsBloc({required this.getSettings, required this.saveSettings})
      : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<SaveSettingsEvent>(_onSaveSettings);
  }

  Future<void> _onLoadSettings(
      LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    final result = await getSettings(NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onSaveSettings(
      SaveSettingsEvent event, Emitter<SettingsState> emit) async {
    final result = await saveSettings(event.settings);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(SettingsLoaded(event.settings)),
    );
  }
}

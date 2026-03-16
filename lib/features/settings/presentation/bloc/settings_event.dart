part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SaveSettingsEvent extends SettingsEvent {
  final SettingsModel settings;

  const SaveSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

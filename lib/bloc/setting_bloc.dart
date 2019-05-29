import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_setting.dart';
import '../model/constant.dart';

enum SettingAction { getSettings, setSettings }

class SettingEvent {
  final SettingAction action;
  final UserSetting settings;
  SettingEvent({
    this.action,
    this.settings,
  });
}

enum SettingStatus {
  appLoaded,
  isNotInitialized,
  isInitialized,
}

class SettingData {
  final SettingStatus status;
  final UserSetting settings;
  final int _hashCode = DateTime.now().millisecondsSinceEpoch;

  SettingData({
    this.settings,
    this.status,
  });

  SettingData copyWith({
    UserSetting settings,
    SettingStatus status,
  }) =>
      SettingData(
        settings: settings ?? this.settings,
        status: status ?? this.status,
      );
  @override
  bool operator ==(other) =>
      other is SettingData &&
      this._hashCode == other.hashCode &&
      this.status == other.status &&
      this.settings == other.settings;

  @override
  int get hashCode => _hashCode;
}

class SettingBloc extends Bloc<SettingEvent, SettingData> {
  @override
  SettingData get initialState => SettingData(
        status: SettingStatus.appLoaded,
        settings: UserSetting(),
      );

  @override
  Stream<SettingData> mapEventToState(SettingEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (event.action) {
      case SettingAction.getSettings:
        bool initialized = (prefs.getBool(initializedKey) ?? false);

        if (initialized) {
          String settingsJson = prefs.getString(settingsKey);
          bool isInitialized = true;
          UserSetting setting = UserSetting.fromJson(
            jsonDecode(settingsJson),
          );
          if (setting.endMinute == null ||
              setting.startMinute == null ||
              setting.jobNum == null) isInitialized = false;
          yield SettingData(
            status: isInitialized
                ? SettingStatus.isInitialized
                : SettingStatus.isNotInitialized,
            settings: setting,
          );
        } else {
          yield currentState.copyWith(
            status: SettingStatus.isNotInitialized,
          );
        }
        break;
      case SettingAction.setSettings:
        String json = jsonEncode(event.settings);
        prefs.setString(settingsKey, json);
        prefs.setBool(initializedKey, true);
        bool isInitialized = true;
        if (event.settings.endMinute == null ||
            event.settings.startMinute == null ||
            event.settings.jobNum == null) isInitialized = false;
        yield SettingData(
          status: isInitialized
              ? SettingStatus.isInitialized
              : SettingStatus.isNotInitialized,
          settings: event.settings,
        );
        break;
    }
  }

  UserSetting get userSettings => currentState.settings;
}

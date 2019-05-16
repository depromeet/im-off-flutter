import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_setting.dart';

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

  @override
  bool operator ==(other) =>
      other is SettingData &&
      this._hashCode == other.hashCode &&
      this.status == other.status &&
      this.settings == other.settings;

  @override
  int get hashCode => _hashCode;
}

const initializedKey = 'initialized';
const settingsKey = 'settings';

class SettingBloc extends Bloc<SettingEvent, SettingData> {
  SharedPreferences prefs;

  @override
  SettingData get initialState => SettingData(status: SettingStatus.appLoaded);

  @override
  Stream<SettingData> mapEventToState(SettingEvent event) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (event.action) {
      case SettingAction.getSettings:
        bool initialized = (prefs.getBool(initializedKey) ?? false);

        if (initialized) {
          String settingsJson = prefs.getString(settingsKey);
          yield SettingData(
            status: SettingStatus.isInitialized,
            settings: UserSetting.fromJson(
              jsonDecode(settingsJson),
            ),
          );
        } else {
          yield SettingData(
            status: SettingStatus.isNotInitialized,
          );
        }
        break;
      case SettingAction.setSettings:
        String json = jsonEncode(event.settings);
        prefs.setString(settingsKey, json);
        prefs.setBool(initializedKey, true);
        yield SettingData(
          status: SettingStatus.isInitialized,
          settings: event.settings,
        );
        break;
    }
  }

  UserSetting get userSettings => currentState.settings;
}

import 'package:biznex/src/core/database/app_database/app_state_database.dart';
import 'package:biznex/src/core/database/url_database/url_database.dart';
import 'package:biznex/src/core/model/app_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<BuildContext?> mainContextProvider = StateProvider<BuildContext?>((ref) => null);
final StateProvider<bool> serverAppProvider = StateProvider<bool>((ref) => false);

final appStateProvider = FutureProvider((ref) async {
  AppStateDatabase stateDatabase = AppStateDatabase();
  AppModel initialState = await stateDatabase.getApp();
  UrlDatabase urlDatabase = UrlDatabase();
  final baseUrl = await urlDatabase.get();
  initialState.baseUrl = "$baseUrl";
  ref.read(serverAppProvider.notifier).update((state) => initialState.isServerApp);
  await stateDatabase.updateApp(initialState);
  return initialState;
});

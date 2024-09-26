import 'dart:convert';

import 'package:simon_ai/core/common/store/secure_storage_cached_source.dart';
import 'package:simon_ai/core/model/player.dart';
import 'package:simon_ai/core/source/common/local_shared_preferences_storage.dart';
import 'package:stock/stock.dart';

class AuthLocalSource {
  static const _storageAuthPrefix = 'AuthLocalSource';
  static const _keyToken = '$_storageAuthPrefix.token';
  static const _keyCurrentPlayer = '$_storageAuthPrefix.player';

  late SourceOfTruth<String, String> _userTokenStorage;
  late SourceOfTruth<String, Player> _userStorage;

  AuthLocalSource(LocalSharedPreferencesStorage storage) {
    final secureStorage = SharedPreferencesSourceOfTruth(storage);
    _userTokenStorage = secureStorage;
    _userStorage = secureStorage.mapToUsingMapper(PlayerStockTypeMapper());
  }

  Stream<String?> getUserToken() => _userTokenStorage.reader(_keyToken);

  Stream<Player?> getCurrentPlayer() => _userStorage.reader(_keyCurrentPlayer);

  Future<void> saveUserToken(String? token) =>
      _userTokenStorage.write(_keyToken, token);

  Future<void> saveCurrentPlayer(Player? user) =>
      _userStorage.write(_keyCurrentPlayer, user);
}

class PlayerStockTypeMapper implements StockTypeMapper<String, Player> {
  @override
  Player fromInput(String value) => Player.fromJson(json.decode(value));

  @override
  String fromOutput(Player value) => json.encode(value.toJson());
}

import 'package:simon_ai/core/common/store/secure_storage_cached_source.dart';
import 'package:simon_ai/core/model/hand_classifier_method.dart';
import 'package:simon_ai/core/source/common/local_shared_preferences_storage.dart';
import 'package:stock/stock.dart';

class SettingsLocalSource {
  static const _storageAuthPrefix = 'SettingsLocalSource';
  static const _keyHandClassifierMethod =
      '$_storageAuthPrefix.hand_classifier_method';

  late SourceOfTruth<String, HandClassifierMethod> _handClassifierMethodStorage;

  SettingsLocalSource(LocalSharedPreferencesStorage storage) {
    final secureStorage = SharedPreferencesSourceOfTruth(storage);
    _handClassifierMethodStorage =
        secureStorage.mapToUsingMapper(HandClassifierMethodStockTypeMapper());
  }

  Stream<HandClassifierMethod?> getHandClassifierMethod() =>
      _handClassifierMethodStorage.reader(_keyHandClassifierMethod);

  Future<void> saveHandClassifierMethod(HandClassifierMethod? user) =>
      _handClassifierMethodStorage.write(_keyHandClassifierMethod, user);
}

class HandClassifierMethodStockTypeMapper
    implements StockTypeMapper<String, HandClassifierMethod> {
  @override
  HandClassifierMethod fromInput(String value) => HandClassifierMethod.values
      .firstWhere((element) => element.name == value);

  @override
  String fromOutput(HandClassifierMethod value) => value.name;
}

abstract interface class DbInterface<T> {
  Future<void> init();
  Future<void> insert(String collection, T data);
  Future<List<T>?> getAllData(String collection);
  Future<T?> getData(String collection, String id);
  Future<void> delete(String collection, String id);
  Future<void> update(String collection, String id, T data);
  Future<void> close();
}

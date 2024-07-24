abstract interface class DbInterface<T> {
  Future<void> init();
  Future<void> insert(String id, T data);
  Future<List<T>?> getAllData();
  Future<T?> getData(String id);
  Future<void> delete(String id);
  Future<void> update(String id, T data);
  Future<void> close();
}

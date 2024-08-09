abstract interface class DbInterface<T> {
  Future<void> insert({required String id, required T data});

  Future<List<T>?> getAllData();

  Future<T?> getData(String id);

  Future<void> delete(String id);

  Future<void> update({required String id, required T data});

  Future<void> close();
}

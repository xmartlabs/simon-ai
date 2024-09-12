abstract interface class DbInterface<T> {
  Future<void> insert({
    required String id,
    required T data,
    required String createdBy,
  });

  Future<List<T>?> getAllData(String createdBy);

  Future<T?> getData(String id);

  Future<void> delete(String id);

  Future<void> update({
    required String id,
    required T data,
    required String createdBy,
  });

  Future<void> close();
}

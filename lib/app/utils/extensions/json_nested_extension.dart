extension JsonNestedExtension on Map<String, dynamic> {
  T nested<T>(String key, T Function(Map<String, dynamic>) fromMap) {
    final nestedMap = this[key] as Map<String, dynamic>?;
    if (nestedMap == null) {
      throw Exception('Chave $key não encontrada ou é nula no JSON.');
    }
    return fromMap(nestedMap);
  }

  T nestedField<T>(String key, String field) {
    final nestedMap = this[key] as Map<String, dynamic>?;
    if (nestedMap == null || !nestedMap.containsKey(field)) {
      throw Exception('Campo $field não encontrado dentro de $key no JSON.');
    }
    return nestedMap[field] as T;
  }
}

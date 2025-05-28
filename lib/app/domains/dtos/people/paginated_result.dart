class PaginatedResult<T> {
  PaginatedResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });
  final List<T> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
}

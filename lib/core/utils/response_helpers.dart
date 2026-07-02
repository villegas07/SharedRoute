/// Extracts a [List] from an API response payload.
///
/// Handles two common API shapes:
/// - Direct list: `["item1", "item2"]`
/// - Paginated envelope: `{ "items": [...], "entries": [...], "total": 10, ... }`
List<dynamic> extractList(dynamic data, {String itemsKey = 'items'}) {
  if (data is List) return data;
  if (data is Map<String, dynamic>) {
    final inner = data[itemsKey];
    if (inner is List) return inner;
    // Try common alternative keys used by different API endpoints
    for (final key in ['entries', 'data', 'results', 'records', 'items']) {
      if (data[key] is List) return data[key] as List;
    }
  }
  return [];
}

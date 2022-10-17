class Cache {
  Cache({
    required this.view,
    required this.script,
  });

  // 试图
  final Map view;
  // js脚本
  final String script;
}

class CacheManage {
  final Map<String, Cache> _cache = {};

  // 添加缓存
  void add(String key, Cache data) {
    _cache[key] = data;
  }

  // 移除
  void remove(String key) {
    _cache.remove(key);
  }

  // 是否存在
  bool isExist(String key) {
    return _cache.containsKey(key);
  }
}

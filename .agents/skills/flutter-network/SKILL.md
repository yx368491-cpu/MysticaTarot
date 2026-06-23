---
name: flutter-network
description: Flutter 网络通信与数据持久化：HTTP 请求、REST API、本地存储、错误处理
metadata:
  category: data
  priority: medium
---

# Flutter Networking & Storage

## HTTP 网络请求

### 使用 Dio（推荐）
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 10),
  receiveTimeout: Duration(seconds: 10),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
));

// 拦截器
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    // 添加 Token
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  },
  onError: (error, handler) {
    // 统一错误处理
    handler.next(error);
  },
));
```

### REST API 调用模式
```dart
class ApiService {
  final Dio _dio;
  
  ApiService(this._dio);
  
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get('/users');
      return (response.data as List).map((e) => User.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
```

## 错误处理模式

### 统一异常类
```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  ApiException(this.message, {this.statusCode});
  
  factory ApiException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('连接超时');
      case DioExceptionType.receiveTimeout:
        return ApiException('响应超时');
      case DioExceptionType.badResponse:
        return ApiException('服务端错误: ${e.response?.statusCode}');
      default:
        return ApiException('网络错误');
    }
  }
}
```

## 本地存储方案

| 方案 | 适用场景 | 备注 |
|------|----------|------|
| **SharedPreferences** | 小数据（用户偏好、Token） | 异步、键值对 |
| **Hive** | 中等数据量 | 快速 NoSQL，无需原生依赖 |
| **sqflite** | 结构化关系数据 | SQLite 封装 |
| **Drift** | 复杂关系型数据 | 编译期安全的 SQLite ORM |
| **Isar** | 高性能场景 | 2025年后推荐替代 Hive |

### 选择指南
- 简单配置 → `SharedPreferences`
- 缓存 API 数据 → `Hive` 或 `Isar`
- 本地数据库 → `sqflite` 或 `Drift`
- 复杂离线优先 → `Drift`

## JSON 序列化

### 手动序列化（小项目）
```dart
class User {
  final int id;
  final String name;
  
  User({required this.id, required this.name});
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
  );
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### 自动生成（推荐）
```dart
// 使用 json_serializable 包
@JsonSerializable()
class User {
  final int id;
  final String name;
  
  User({required this.id, required this.name});
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

## 离线优先策略
1. 先从本地缓存读取 → 展示
2. 发起网络请求 → 更新缓存 → 刷新 UI
3. 网络不可用时 → 使用缓存数据
4. 使用 `ConnectivityPlus` 检测网络状态

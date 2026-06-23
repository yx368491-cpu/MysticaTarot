---
name: dart-language
description: Dart 语言最佳实践：类型系统、空安全、异步编程、Lint 规则、常用语法
metadata:
  category: language
  priority: medium
---

# Dart Language Best Practices

## 类型系统

### 空安全（Null Safety）
```dart
// 不可空（默认）
String name = 'Alice';       // 非空
String? nullableName;        // 可空
late String lateName;        // 延迟初始化

// 空值处理
final length = name?.length ?? 0;   // 安全访问 + 默认值
final display = nullableName!;       // 强制解包（谨慎使用）
```

### 类型推断
```dart
var name = 'Alice';          // 类型推断为 String
final id = 123;              // 类型推断为 int
const pi = 3.14159;          // 编译期常量

// 明确类型（推荐用于复杂场景）
List<String> names = [];     
Map<String, dynamic> json = {};
```

## 异步编程

### async/await
```dart
Future<String> fetchData() async {
  final response = await http.get(Uri.parse(url));
  return response.body;
}

// 并发执行
Future<void> loadAll() async {
  final results = await Future.wait([
    fetchUsers(),
    fetchPosts(),
    fetchComments(),
  ]);
}
```

### Stream
```dart
Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}

// 监听
await for (final value in countStream(5)) {
  print(value);
}
```

## 集合操作
```dart
final numbers = [1, 2, 3, 4, 5];

// 常用操作
numbers.map((n) => n * 2);           // [2, 4, 6, 8, 10]
numbers.where((n) => n.isEven);      // [2, 4]
numbers.fold(0, (a, b) => a + b);    // 15
numbers.any((n) => n > 3);           // true
numbers.every((n) => n > 0);         // true

// 集合字面量
final list = [1, 2, 3];              // List<int>
final set = {1, 2, 3};               // Set<int>
final map = {'a': 1, 'b': 2};        // Map<String, int>
```

## 类和扩展

### 记录（Records）- Dart 3 新特性
```dart
// 匿名记录
final pair = (name: 'Alice', age: 25);
print(pair.name);  // Alice

// 解构
final (name, age) = (name: 'Bob', age: 30);
```

### 扩展方法
```dart
extension StringExtension on String {
  String get capitalize => 
    this.isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  
  bool get isValidEmail => 
    RegExp(r'^[\w-\.]+@([\w-])+\.\w{2,4}$').hasMatch(this);
}

// 使用
'hello'.capitalize;      // 'Hello'
'test@email.com'.isValidEmail;  // true
```

### Pattern Matching - Dart 3
```dart
switch (value) {
  case 0 => print('零');
  case 1 || 2 => print('小数字');
  case >= 10 => print('大数字');
  default => print('其他');
}

// Sealed class
sealed class Result {}
class Success<T> extends Result { final T data; ... }
class Error extends Result { final String message; ... }
```

## Lint 规则推荐

```yaml
# analysis_options.yaml
linter:
  rules:
    - prefer_const_constructors
    - prefer_final_locals
    - avoid_print
    - prefer_single_quotes
    - sort_constructors_first
    - unawaited_futures
    - use_super_parameters
```

## 常用代码模式

### 单例
```dart
class ApiClient {
  ApiClient._();
  static final instance = ApiClient._();
}
```

### 工厂构造
```dart
class Shape {
  factory Shape.fromType(String type) {
    switch (type) {
      case 'circle': return Circle();
      case 'square': return Square();
      default: throw ArgumentError('Unknown type: $type');
    }
  }
}
```

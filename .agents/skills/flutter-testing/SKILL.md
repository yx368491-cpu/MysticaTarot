---
name: flutter-testing
description: Flutter 测试策略：Unit Test、Widget Test、Integration Test 编写规范与最佳实践
metadata:
  category: testing
  priority: medium
---

# Flutter Testing

## 测试金字塔

```
        /\
       /  \          Integration Test (E2E)
      /    \
     /------\
    /        \       Widget Test (组件测试)
   /          \
  /------------\
 /              \   Unit Test (单元测试)
/________________\
```

- **Unit Test**: 多而快 — 测试单个函数/类（毫秒级）
- **Widget Test**: 适中 — 测试单个 widget 的渲染和交互（秒级）
- **Integration Test**: 少而慢 — 测试完整用户流程（分钟级）

## Unit Test

### 测试文件结构
```
test/
├── unit/
│   ├── models/
│   │   └── user_test.dart
│   ├── services/
│   │   └── api_service_test.dart
│   └── providers/
│       └── auth_provider_test.dart
```

### 示例
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/models/user.dart';

void main() {
  group('User Model', () {
    test('fromJson creates User correctly', () {
      final json = {'id': 1, 'name': 'Alice'};
      final user = User.fromJson(json);
      
      expect(user.id, 1);
      expect(user.name, 'Alice');
    });

    test('toJson returns correct map', () {
      final user = User(id: 1, name: 'Alice');
      
      expect(user.toJson(), {'id': 1, 'name': 'Alice'});
    });
  });
}
```

### Mock 依赖
```dart
// 使用 mockito 或 mocktail
class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  
  setUp(() {
    mockApiService = MockApiService();
  });
}
```

## Widget Test

### 示例
```dart
testWidgets('LoginForm shows validation error on empty email', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginForm()));
  
  // 找到并点击登录按钮
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // 验证错误提示显示
  expect(find.text('请输入邮箱'), findsOneWidget);
});
```

### Widget Test 最佳实践
- 使用 `pump()` 只重建，`pumpAndSettle()` 等待所有动画完成
- 使用 `find.byType()`、`find.text()`、`find.byKey()` 定位 widget
- 为重要 widget 添加 `Key` 方便测试定位

## Integration Test

### 设置
```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

### 测试文件
```dart
// test_driver/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    
    await tester.enterText(find.byType(TextField).at(0), 'user@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    
    expect(find.text('欢迎回来'), findsOneWidget);
  });
}
```

### E2E 测试工具
- **Patrol**: 2025-2026 年推荐的 E2E 框架，支持 AI 辅助测试生成
- 运行：`flutter test integration_test/`

## 测试覆盖率
```bash
flutter test --coverage
# 生成 coverage/lcov.info
# 使用 lcov 或 genhtml 生成 HTML 报告
```

## 关键原则
1. **测试行为，而非实现**：测试外部表现而非内部细节
2. **隔离测试**：每个测试独立运行，不依赖共享状态
3. **Arrange-Act-Assert**：准备 → 执行 → 验证
4. **优先测试关键路径**：用户最常使用的功能优先

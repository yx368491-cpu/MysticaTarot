---
name: flutter-architecture
description: Flutter 项目架构：Clean Architecture、Feature-First 结构、依赖注入、模块化设计
metadata:
  category: architecture
  priority: medium
---

# Flutter Project Architecture

## 推荐架构：Feature-First + MVVM

### 目录结构
```
lib/
├── main.dart                      # 应用入口
├── app.dart                       # MaterialApp 配置
├── core/                          # 全局基础设施
│   ├── constants/                 # 常量定义
│   ├── theme/                     # 主题配置
│   ├── network/                   # 网络层（Dio 客户端、拦截器）
│   ├── router/                    # 路由配置
│   ├── di/                        # 依赖注入容器
│   └── utils/                     # 工具函数
├── features/                      # 功能模块（按功能分组）
│   └── auth/                      # 示例：认证功能
│       ├── presentation/          # UI 层（Views, ViewModels）
│       │   ├── pages/             # 页面
│       │   ├── widgets/           # 组件
│       │   └── providers/         # 状态管理
│       ├── domain/                # 业务逻辑层
│       │   ├── entities/          # 实体
│       │   └── repositories/      # 仓库接口
│       └── data/                  # 数据层
│           ├── models/            # 数据模型 (DTO)
│           ├── repositories/      # 仓库实现
│           └── datasources/       # 数据源 (API, DB)
└── shared/                        # 共享组件
    └── widgets/                   # 通用 UI 组件
```

## 架构分层原则

### 依赖方向
```
UI (Widgets) → ViewModel (Provider/Notifier) → Repository (接口) → DataSource
```

- 依赖始终向内指向
- 各层通过抽象接口（Repository 接口）解耦
- 业务逻辑不应依赖于具体的数据源实现

### 各层职责

| 层 | 职责 | 不允许 |
|----|------|--------|
| **Presentation** | 纯声明式 UI，展示状态、转发用户操作 | ✅ 无业务逻辑 |
| **ViewModel** | 管理 UI 状态，处理交互逻辑 | ✅ 不直接访问 API |
| **Repository** | 数据协调、缓存策略、错误处理 | ✅ 不持有 UI 状态 |
| **DataSource** | 封装外部数据源（API、本地 DB） | ❌ 仅做数据存取 |

## 依赖注入

### 使用 Riverpod 作为 DI 容器
```dart
// 定义 Provider
final apiClientProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: 'https://api.example.com'));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(apiClientProvider));
});

// 在 Widget 中使用
class LoginPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    // ...
  }
}
```

## 状态管理（按复杂度选择）

| 场景 | 方案 |
|------|------|
| 简单局部状态 | `setState()` |
| 中等复杂度 | `Riverpod` + `StateNotifier` |
| 大型企业应用 | `Bloc` / `Riverpod` + 领域层 |

## 路由架构

- 小项目：`Navigator.pushNamed()`
- 中大型项目：**go_router**（推荐）
  - 声明式路由定义
  - 类型安全的参数传递
  - 深度链接支持
  - 重定向保护

## 文件命名规范
```
snake_case:    user_model.dart, auth_service.dart
PascalCase:    类名（UserModel, AuthService）
camelCase:     变量和方法名（userName, fetchUsers()）
```

## 不要过度工程化
- 对于简单页面不需要 Domain/UseCase 层
- 只在出现重复代码或极端复杂性时添加高级层
- 保持简单直到需要复杂化时再重构

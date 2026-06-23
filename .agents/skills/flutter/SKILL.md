---
name: flutter
description: Flutter 核心开发最佳实践：Widget 构建、状态管理、路由、动画、性能优化
metadata:
  category: mobile
  priority: high
---

# Flutter Core Development

## Widget 最佳实践

### 使用 const 构造函数
- 尽可能使用 `const` 构造函数，允许 Flutter 跳过不必要的重建
- ✅ `const Text('Hello')` 
- ✅ `const Padding(padding: EdgeInsets.all(8.0), child: ...)`
- ❌ 避免在 build 方法中反复创建无变化的 widget

### Widget 拆分原则
- 将大 widget 拆分为小的、专注的 widget
- 不要在 widget 树的高层调用 `setState()`，局部更新防止不必要的子树重建
- 使用 `Builder`、`ValueListenableBuilder` 等减少重建范围

### 避免 saveLayer()
- `saveLayer()` 是昂贵的 GPU 操作
- 如第三方包使用了，考虑联系作者或寻找替代方案

## 状态管理建议

### 初学者路径
1. `setState` - 用于简单的组件内部状态（复选框、文本框等）
2. **Riverpod** - 现代应用的首选，无需 BuildContext，编译期安全
3. **Bloc** - 适合大型团队，强制架构规范

### 关键原则
- Widget 不应包含业务逻辑
- 状态提升到需要它的最小共同祖先
- 使用 `ValueNotifier` / `ChangeNotifier` 或专门的解决方案

## Asset 管理

- **使用 WebP 格式**：替换 PNG/JPEG，减少约 30% 体积
- **内存缓存**：使用 `cached_network_image`，配置 `memCacheWidth/Height` 防止加载全分辨率图片到 RAM
- 使用 `flutter_gen` 实现类型安全的资源引用

## 性能优化

### Isolate 使用
- 永远不要在 UI 线程上执行 CPU 密集型任务（JSON 解析大文件、图片处理等）
- 使用 `compute()` 函数或自定义 `Isolate` 处理

### 测试模式
- 始终在 **Profile 模式** 下测试：`flutter run --profile`
- Debug 模式有额外开销，会掩盖性能瓶颈
- 使用 **Flutter DevTools** 跟踪 widget 重建和布局

## 路由管理
- 小项目：使用 `Navigator` 和命名路由
- 中大型项目：考虑 `go_router` 或 `auto_route`
- 声明式路由类型安全，支持深度链接

## 常用命令速查
```bash
flutter create my_app                    # 创建项目
flutter run                              # 运行
flutter run --profile                    # 性能分析模式
flutter build apk --split-per-abi        # 构建 APK
flutter build appbundle                  # 构建 AAB
flutter test                             # 运行测试
flutter analyze                          # 静态分析
```

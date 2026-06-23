---
name: flutter-ui-ux
description: Flutter UI/UX 设计：Material Design 3、响应式布局、主题系统、动画交互、组件设计
metadata:
  category: ui
  priority: medium
---

# Flutter UI/UX Design

## Material Design 3 (Material You)

### 启用 Material 3
```dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,  // 启用 M3
    colorSchemeSeed: Colors.blue,  // 自动生成配色方案
  ),
)
```

### 配色系统
```dart
Theme.of(context).colorScheme.primary
Theme.of(context).colorScheme.onPrimary
Theme.of(context).colorScheme.surface
Theme.of(context).colorScheme.outline
```

## 主题系统

### 定义全局主题
```dart
class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.light,
    fontFamily: 'NotoSansSC',  // 中文字体支持
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.dark,
    fontFamily: 'NotoSansSC',
  );
}
```

## 响应式布局

### 断点参考
```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  
  static bool isMobile(BuildContext context) => 
    MediaQuery.of(context).size.width < mobile;
  static bool isTablet(BuildContext context) => 
    MediaQuery.of(context).size.width >= mobile && 
    MediaQuery.of(context).size.width < tablet;
}
```

### 布局适配
```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return _MobileLayout();
    } else {
      return _TabletLayout();
    }
  },
)
```

## 动画与交互

### 常用动画类型
```dart
// 隐式动画（推荐用于简单场景）
AnimatedContainer(duration: Duration(milliseconds: 300))
AnimatedOpacity(duration: Duration(milliseconds: 300))
AnimatedPadding(duration: Duration(milliseconds: 200))

// 显式动画（复杂场景）
AnimationController(vsync: this, duration: Duration(milliseconds: 500))
```

### 微交互原则
- 反馈：每次用户操作应有视觉反馈
- 持续时间：100-300ms 最为自然
- 缓动曲线：使用 `Curves.easeInOut` 而非线性动画

## UI 组件设计原则

| 原则 | 说明 |
|------|------|
| **一致性** | 统一的间距、颜色、字体系统 |
| **层次结构** | 使用大小、颜色、间距表达内容层级 |
| **可访问性** | 最小触控区域 48x48，对比度 ≥ 4.5:1 |
| **简洁性** | 每屏只聚焦一个主要操作 |

## 常用组件速查

```dart
// 卡片容器
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(...),
  ),
)

// 列表
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (_, __) => Divider(),
  itemBuilder: (context, index) => ListTile(
    leading: Icon(Icons.star),
    title: Text(items[index]),
    trailing: Icon(Icons.chevron_right),
  ),
)

// 加载状态
Center(child: CircularProgressIndicator())

// 空状态
Center(child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.inbox_outlined, size: 64),
    SizedBox(height: 16),
    Text('暂无数据'),
  ],
))
```

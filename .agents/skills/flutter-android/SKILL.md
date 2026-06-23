---
name: flutter-android
description: Flutter Android 平台专项：AndroidManifest 配置、权限、打包 APK/AAB、Google Play 发布
metadata:
  category: mobile
  priority: high
---

# Flutter Android Development

## Android 配置

### build.gradle (app 级别)
```gradle
android {
    compileSdkFlutter 35  // 2025年起新应用必须 targetSdk 35
    
    defaultConfig {
        applicationId "com.example.app"
        minSdk 21
        targetSdk 35
        versionCode 1
        versionName "1.0.0"
    }
}
```

### AndroidManifest.xml 配置
- 仅声明你实际使用的权限
- ❌ 不要请求 `ACCESS_FINE_LOCATION` 如果只需要 `ACCESS_COARSE_LOCATION`
- 所有权限必须在清单中明确声明

## 打包构建

### 签名配置
```gradle
android {
    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 构建命令
```bash
flutter build apk --split-per-abi                    # 分离 APK（arm64-v8a, armeabi-v7a, x86_64）
flutter build appbundle                               # AAB 格式（Google Play 必须）
flutter build apk --target-platform android-arm64     # 仅 arm64
```

### 版本号管理
- `versionCode`: 正整数，每次提交递增
- `versionName`: 用户可见的版本号，如 "1.2.0"

## Google Play 发布

### 2026 年必须要求
| 要求 | 说明 |
|------|------|
| **AAB 格式** | APK 不再被 Play Store 接受 |
| **targetSdk 35** | 新应用必须 |
| **Play Integrity API** | 替换已弃用的 SafetyNet |
| **隐私政策** | 必须是托管 URL（非 PDF） |
| **数据安全表单** | 必须准确披露数据收集情况 |

### ProGuard/R8 混淆
```gradle
buildTypes {
    release {
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

## 常见问题
- **64 位要求**：自 2019 年 8 月起，Google Play 要求应用支持 64 位架构
- **权限审核**：定期审查第三方插件申请的权限
- **Android X**：确保使用 AndroidX（1.0 以上版本默认启用）

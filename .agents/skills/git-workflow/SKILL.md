---
name: git-workflow
description: Git 工作流：分支管理、Commit 规范、Code Review、版本发布
metadata:
  category: devops
  priority: low
---

# Git Workflow

## 分支策略：Git Flow 精简版

### 分支类型
```
main          ← 生产环境代码
├── develop   ← 开发主分支
│   ├── feature/auth     ← 功能分支
│   ├── feature/profile
│   └── fix/login-bug    ← 修复分支
├── release/1.0.0        ← 发布候选
└── hotfix/1.0.1         ← 紧急修复
```

### 工作流程
```bash
# 开始新功能
git checkout develop
git checkout -b feature/my-feature
# ... 开发 ...
git commit -m "feat: 添加用户登录功能"
git push -u origin feature/my-feature

# 合并回 develop（通过 PR）
# 在远程仓库创建 Pull Request → Code Review → Merge

# 发布
git checkout develop
git checkout -b release/1.0.0
# 测试、修复 bug
git checkout main
git merge release/1.0.0
git tag v1.0.0
git checkout develop
git merge release/1.0.0
```

## Commit 规范

### Conventional Commits
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 类型速查
| Type | 用途 | 示例 |
|------|------|------|
| **feat** | 新功能 | `feat(auth): 添加手机号登录` |
| **fix** | Bug 修复 | `fix(cart): 修复数量计算错误` |
| **refactor** | 重构 | `refactor: 提取通用 HTTP 客户端` |
| **docs** | 文档 | `docs: 更新 API 文档` |
| **style** | 格式 | `style: 格式化代码` |
| **test** | 测试 | `test: 添加用户模型单元测试` |
| **chore** | 杂项 | `chore: 升级 Flutter 版本` |

### Commit 原则
1. **小粒度提交**：每个提交只做一件事
2. **原子性**：提交可单独回退且不影响整体功能
3. **描述清晰**：用中文或英文写明"做了什么"和"为什么做"

## 合并策略

| 策略 | 适用场景 |
|------|----------|
| **Merge** | 合并长期分支时保留历史 |
| **Squash** | 功能分支合并，保持历史整洁 |
| **Rebase** | 在 PR 审查后更新分支 |

## 标签与版本号

### 语义化版本
```bash
# v主版本.次版本.修订号
# v1.0.0 - 初始正式发布
# v1.2.0 - 新增功能
# v1.2.1 - Bug 修复

git tag v1.0.0
git push origin v1.0.0
```

## .gitignore 推荐 (Flutter)
```
/build/
.dart_tool/
.packages
.pub/
.flutter-plugins*
*.iml
.idea/
.vscode/
*.lock
*.log
```

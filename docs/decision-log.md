# MysticaTarot 关键决策日志

> 项目: MysticaTarot — 占卜塔罗牌 Android APP
> 此文件记录架构变更、技术选型等关键决策及其理由。

---

## Decision #1: RWS 塔罗牌图片来源选型

**日期**: 2026-06-23
**决策者**: AI Agent

### 背景
需要为 78 张塔罗牌选择开源、高质量的图片来源。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| Wikimedia Commons Geldard 版 | 命名统一、色彩还原好、Public Domain | 需逐个下载，有 API 速率限制 |
| Wikipedia 标准版 | 可免费使用 | 画质参差不齐，命名不一致 |
| 自行生成 SVG | 完全自定义 | 工作量大，缺乏专业度 |

### 最终选择
选择了 Wikimedia Commons (Geldard) 版。

### 理由
1. 78 张卡片的命名格式完全统一：`[Card Name] (Rider-Waite Smith tarot deck).png`
2. Public Domain 无需额外授权
3. 色彩经过数字修复，质量较好

### 影响范围
- 所有塔罗牌功能页面的图片引用路径
- 命名需从 Commons 格式转换为 `Ace_of_Wands.png` 格式

---

## Decision #2: 字体渲染策略

**日期**: 2026-06-23
**决策者**: AI Agent

### 背景
需要使用 Playfair Display（英/Tagalog）和 Noto Serif SC（中文）两种字体。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| 可变字体（Variable Font） | 单个文件包含所有字重，减小 APK | 文件体积仍较大（Noto SC 11MB） |
| 静态字体文件（TTF） | 可按需选择字重 | 多个文件管理复杂 |
| Google Fonts 动态加载 | 不增加 APK 体积 | 需要网络，违反离线要求 |

### 最终选择
使用可变字体。

### 理由
1. Playfair Display 可变字体仅 300KB，包含 Regular~Bold 所有字重
2. Noto Serif SC 黑度轴可变字体 11MB，稍大但可接受
3. 完全离线运行，不依赖网络加载

---

## Decision #3: JSON 数据本地路径

**日期**: 2026-06-23
**决策者**: AI Agent

### 背景
塔罗牌内容、占星数据等需要存储在项目中并加载到内存。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| JSON 文件 + AssetBundle 加载 | 数据与代码分离、易于替换 | 需异步加载 |
| Dart const Map 硬编码 | 编译时即用，无需加载 | 文件巨大，难以维护 |
| Hive Box 预填充 | 查询方便 | 首次启动需预填充 |

### 最终选择
JSON 文件通过 AssetBundle 加载，运行时解析到内存 Model。

### 理由
1. 数据与代码分离，方便后续多语言内容更新
2. JSON 结构清晰，可直接映射到 Dart Model
3. AssetBundle 加载是 Flutter 标准做法

---

## Decision #4: 占位音效文件的合成方式

**日期**: 2026-06-23
**决策者**: AI Agent

### 背景
`assets/sounds/*.wav` 是上一阶段留下的 44 字节 RIFF 头占位文件。用户验证时听不到任何实际音效。本决策解决"用什么内容填充这 4 个文件"——是关于资产 supply 的决策，不是实现细节。

### 可选方案
| 方案 | 优点 | 缺点 |
|------|------|------|
| **A. Freesound CC0 下载** | 现场实录音，声音自然 | 依赖代理、不易复现、license 库维护费时、跨机器字节不一致（git diff 噪音）|
| **B. Flutter SystemSound / HapticFeedback** | 零设置、原生低沉 | 仅 click，不能满足"洗牌、翻牌、扇牌、和弦警"的 4 种语义区分 |
| **C. 仅移除（disable 音效调用点）** | 简单 | spec §7.4 明列音效是必要的、动效同步需要，声音能提升 APP 体感，为了节省资产质量而割裂产品定位得不偿失 |
| **D. Python stdlib 程序化合成 + 提交产物** | 纯数学、跨机一致、可 git diff、零网络依赖、无 license 问题 | 声音偏合成质感，需调参；高频泛音可能不如真实录音 |
| **E. 自己录音（audacity + 手机麦）** | 调性最贴自定义产品气质 | 个人项目、迭代成本高于方案 D、录音环境难控制、跨机器不可复现 |

### 最终选择
选择 **方案 D**。

### 理由
1. **可复现性**：项目一贯偏好"脚本生成 + 产物提交"模式（参 Phase 1.5 `tools/generate_json_data.py`）。Freesound 不同机器、不同 time-of-day 取到的 bytes 会不同，产生 git diff 噪音。
2. **代理/网络安全**：上一阶段执行 Clash Verge TUN 代理才能拉到 FreeSound。Phase 1.5 GitHub Push Protection 教训为鉴，重复出现网络依赖代理的不愉快想避免。
3. **license 清晰**：所有产物均在仓库主仓版本控制下，无第三方 license 追踪负担。
4. **调参可执行**：听感不佳只需改包络参数（`sin^2`、`exp(-30t)` 等），不必重新下载。
5. **零 Dart 变动**：本次只换资产文件，`SoundUtils.playXxx()` API 与 `pubspec.yaml` `assets/sounds/` 声明都不动，避免 Dart 代码回归风险。

### 影响范围
- `tools/generate_sounds.py` 是一键服务：`_SEED = 20260623` 为 module-level 常数，重新运行产出字节级一致的 WAV（git 二次 diff 不会有噪音）。
- 4 个 `assets/sounds/*.wav` 是中段原料，未来 Phase 9 调参只需重跑脚本。

### 后续验证
- [ ] Phase 9 手机上跑 `flutter run -d <device>`：原生听感是否贴合产品"梦幻魔法"调性。如不满意用 `math.exp` / `math.sin^2` 参数调校，不会动 Dart 代码。
- [ ] 如未来需要高保真实录音频，可重启"方案 E"流程录制并替换 4 个 WAV 文件，本决策可平替反转。

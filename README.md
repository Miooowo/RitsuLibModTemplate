# RitsuLibModTemplate

语言 / Languages：中文 | [English](README.en.md)

这是一个可复制、可构建的 RitsuLib Mod 模板，保留通用 Godot/C# 工程结构、示例内容和静态占位资源。

## 使用 NuGet 模板

### 命令行安装与创建

安装模板：

```powershell
dotnet new install STS2.RitsuLib.ModTemplate
```

创建新 Mod：

```powershell
dotnet new ritsulibmod -n MyMod
```

这会生成名为 `MyMod` 的工程，并把模板中的 `RitsuLibModTemplate`、示例内容类名、示例资源文件名、资源目录、manifest 名称、namespace 和本地化 id 替换成新名称。

卸载模板：

```powershell
dotnet new uninstall STS2.RitsuLib.ModTemplate
```

### 在 Rider 中创建项目

完成一次 `dotnet new install STS2.RitsuLib.ModTemplate` 后，Rider 会自动识别这个模板，可以直接通过新建解决方案向导创建：

1. 打开 Rider，选择 `File` → `New Solution`（或欢迎界面的 `New Solution`）。
2. 在左侧模板列表向下滚动，在 `Custom Templates`（或 `More Templates`）分类中选择 `RitsuLib Mod Template`（短名 `ritsulibmod`）。
3. 在右侧填入 `Solution name`（即新 Mod 名，例如 `MyMod`）和保存位置，点击 `Create`。

Rider 会在背后调用 `dotnet new ritsulibmod -n <Solution name>` 完成模板替换，效果与命令行一致；也可以直接在 Rider 内置终端里运行相同的命令。如果模板没有出现在列表里，先确认 `dotnet new install` 成功，然后在 Rider 的 `New Solution` 对话框点击刷新或重启 Rider。

## RitsuLib 和教程

- [STS2-RitsuLib](https://github.com/BAKAOLC/STS2-RitsuLib)：Slay the Spire 2 Mod 的共享框架库，本模板基于它提供内容注册、角色脚手架和 Godot 资源接入能力。
- [RitsuLib GitHub 教程目录](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/RitsuLib)：适合按文件阅读教程和示例。
- [Slay the Spire 2 Modding Tutorials 网页版](https://glitchedreme.github.io/SlayTheSpire2ModdingTutorials/index.html)：适合浏览完整教程站点。
- 教程 Wiki： [中文首页](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home) | [English Home](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home-EN)
- 这套 Wiki 以 Rider 为主线，先跑通模板，再逐步理解 RitsuLib 的注册与内容模型。

## RitsuLib 版本选择和兼容性

模板默认使用主线 RitsuLib，并在 `.csproj` 中保留最新可用版本配置。主线维护版本现在是 STS2 `0.105.0` 及以上：

```xml
<PackageReference Include="STS2.RitsuLib" Version="*" />
```

这里的 `Version="*"` 只表示编译时 NuGet 包可以解析到当前可用版本；真正随 Mod 分发并由游戏加载器检查的是 manifest 里的 `dependencies`。发布前，请确认 `RitsuLibModTemplate.json` 里的 `STS2-RitsuLib` 版本与实际编译、测试的 RitsuLib 版本一致。若想保守地锁运行时下限，可以继续把 manifest 写成最低支持版本，但 README 或发布说明中要明确这是运行时下限，不是当前编译使用的精确版本。

项目还默认引用 `Nothing.STS2RitsuLib.ModAnalyzers`。这是一个 AI 编写的辅助分析器，用于在开发时提示 RitsuLib Mod 模板中常见的 manifest 和资源配置问题。

三个 RitsuLib 包一次只能启用一个。如果仍针对 STS2 `0.104.0` 的代码构建，请注释主线包并启用 `0.104.0` 兼容包：

```xml
<PackageReference Include="STS2.RitsuLib.Compat.0.104.0" Version="*" />
```

如果需要针对 STS2 `0.103.2` 分支构建，请启用 `0.103.2` 兼容包：

```xml
<PackageReference Include="STS2.RitsuLib.Compat.0.103.2" Version="*" />
```

`0.104.0` 和 `0.103.2` 现在都按兼容分支维护，维护级别相同。兼容包只是选择对应游戏分支，并不会恢复所有旧 API；部分老 Mod 仍然需要修改并重新编译。

升级到 STS2 `0.105.0` / RitsuLib 主线时，请特别检查这些变化：

- 版本条件编译改为累积分间隔宏 `STS2_AT_LEAST_<ver>`；传统单目标宏 `STS2_V_<ver>` 不再推荐使用。
- AnyPlayer 和 AnyAny 目标逻辑已有调整，旧卡牌目标、基础构造函数签名和注册逻辑需要按新主线 API 检查。
- 卡牌右下角支持额外图标数量标签，并处理与原版 UI 的冲突；自定义 UI 或图标补丁需要确认显示层级和位置。
- 保留/flush 相关 hook 和 event 有替换、移除或 `[Obsolete]` 标记；旧代码中使用 `CardRetainedEvent`、`CardsFlushedEvent` 或旧 `Hook.*` 入口时需要迁移。
- Badge、BadgeRuntimeTemplate、BadgePool.CreateAll 和 ModBadgeTemplate 构造签名随上游变化调整；旧的注册模组死亡界面 Badge 代码可能需要更新以避免 `MissingMethodException`。

模板包含：

- 一个 `[ModInitializer]` 入口。
- 一个最小自定义角色、角色卡池、遗物池和药水池。
- 四张初始打击、四张初始防御和一个初始遗物示例。
- 最小 Godot 静态占位场景，用于角色战斗模型、能量表盘、角色选择背景、商店和火堆。
- 从原版资源复制并改成模板命名的占位 PNG，复制模板后可以直接替换。
- 中英文基础本地化文件。
- Godot 项目、导出配置、manifest 和构建脚本。

## 目录结构

```text
RitsuLibModTemplate/
├── RitsuLibModTemplateCode/   # C# 源码
├── RitsuLibModTemplate/       # Godot 资源、本地化和占位场景
├── RitsuLibModTemplate.csproj
├── RitsuLibModTemplate.json
├── project.godot
└── local.props.template
```

`res://RitsuLibModTemplate/...` 是 Godot/PCK 内的资源路径，对应仓库里的 `RitsuLibModTemplate/` 资源目录，不是 C# namespace。通过 NuGet 模板创建项目时，这些目录名、文件名和 namespace 会按新 Mod 名同步替换。

## Manifest 格式

`RitsuLibModTemplate.json` 使用新的依赖声明格式：

```json
{
  "min_game_version": "0.105.1",
  "dependencies": [
    {
      "id": "STS2-RitsuLib",
      "version": "0.2.29"
    }
  ]
}
```

复制模板后，`id` 仍需要和 `Entry.ModId` 保持一致；`dependencies` 现在是数组，每个依赖项使用 `id` 和 `version` 声明，不再使用旧的单对象 `min_version` 写法。

模板当前示例声明 `STS2-RitsuLib` 为 `0.2.29`。如果 `.csproj` 中的 `PackageReference` 使用 `Version="*"` 解析到了更新版本，或你手动升级了 RitsuLib 包，发布前请同步检查 manifest；它应该等于实际使用、测试的版本，或明确作为最低运行时依赖下限。

## 配置本机路径

复制：

```powershell
Copy-Item .\local.props.template .\local.props
```

然后在 `local.props` 中设置或按需覆盖：

- `Sts2Dir`：Slay the Spire 2 安装目录。
- `Sts2DataDir`：游戏 dll 目录，通常是 `$(Sts2Dir)/data_sts2_windows_x86_64`。
- `GodotExe`：用于导出 pck 的 MegaDot/Godot 可执行文件。
- `RitsuLibDeployDir`：RitsuLib 本机部署目录，默认是 `$(Sts2Dir)/mods/STS2-RitsuLib`。它用于 RitsuLib 包/构建逻辑把 RitsuLib 复制到游戏 mods 目录，不是当前 Mod 自身的输出目录。

`local.props` 已加入 `.gitignore`，不要提交。

## 构建

只验证 C# 编译，并跳过 `CopyMod` 和 `ExportPCK`：

```powershell
dotnet build .\RitsuLibModTemplate.csproj /p:RunPckExport=false /p:CopyModOnBuild=false
```

正常构建会在 `Build` 后运行两个 MSBuild target：

- `CopyMod`：复制 dll 和 manifest 到游戏的 `mods/RitsuLibModTemplate` 目录。
- `ExportPCK`：调用 `GodotExe` 导出 pck 到同一个 Mod 目录。

`RitsuLibDeployDir` 单独控制 RitsuLib 框架自身的本机部署位置；当前 Mod 的 dll、manifest 和 pck 仍由 `ModOutputDir` 控制。

```powershell
dotnet build .\RitsuLibModTemplate.csproj
```

也可以只跳过其中一个 target：

```powershell
dotnet build .\RitsuLibModTemplate.csproj /p:CopyModOnBuild=false
dotnet build .\RitsuLibModTemplate.csproj /p:RunPckExport=false
```

构建成功后，dll、manifest 和 pck 会复制到游戏的 `mods/RitsuLibModTemplate` 目录。


## 示例内容

示例角色：

- 类型：`RitsuLibModTemplateCharacter`
- 预期 id：`RITSU_LIB_MOD_TEMPLATE_CHARACTER_RITSU_LIB_MOD_TEMPLATE_CHARACTER`
- starter：4 张 `RitsuLibModTemplateStrike`、4 张 `RitsuLibModTemplateDefend`、1 个 `RitsuLibModTemplateRelic`
- 角色资源通过 `CharacterAssetProfile` 配置。模板只指定已经复制的静态占位资源，未指定的音频、拖尾、转场等字段继续从 `PlaceholderCharacterId` 回退。

示例卡牌：

- `RitsuLibModTemplateStrike`：攻击牌，角色卡池，预期 id `RITSU_LIB_MOD_TEMPLATE_CARD_RITSU_LIB_MOD_TEMPLATE_STRIKE`
- `RitsuLibModTemplateDefend`：技能牌，角色卡池，预期 id `RITSU_LIB_MOD_TEMPLATE_CARD_RITSU_LIB_MOD_TEMPLATE_DEFEND`

示例遗物：

- 类型：`RitsuLibModTemplateRelic`
- 遗物池：`RitsuLibModTemplateRelicPool`
- 预期 id：`RITSU_LIB_MOD_TEMPLATE_RELIC_RITSU_LIB_MOD_TEMPLATE_RELIC`

## 静态占位资源

模板内置的图片资源已经放在 `res://RitsuLibModTemplate/images/...`：

- `images/cards/RitsuLibModTemplateStrike.png`、`images/cards/RitsuLibModTemplateDefend.png`：示例卡图。
- `images/relics/RitsuLibModTemplateRelic.png`：示例遗物图标。
- `images/characters/RitsuLibModTemplate_character_*.png`：角色头像、角色选择图、地图标记和能量图标。

模板内置的场景资源已经放在 `res://RitsuLibModTemplate/scenes/characters/...`：

- `RitsuLibModTemplate_character.tscn`：静态战斗人物，占位结构包含 `%Visuals`、`%Bounds`、`%IntentPos`、`%CenterPos`、`%TalkPos`。
- `RitsuLibModTemplate_energy_counter.tscn`：静态能量表盘，占位结构包含 `%EnergyVfxBack`、`%Layers`、`%RotationLayers`、`%EnergyVfxFront`、`Label`。
- `RitsuLibModTemplate_merchant.tscn`：静态商店人物。
- `RitsuLibModTemplate_rest_site.tscn`：静态火堆人物，占位结构包含 `%ControlRoot`、`%SelectionReticle`、`%Hitbox`、`%ThoughtBubbleRight`、`%ThoughtBubbleLeft`。
- `RitsuLibModTemplate_character_select_bg.tscn`：角色选择背景。

这些资源只用于保证模板可见、可替换，不追求原版动画效果。复制模板后，把同名 PNG 或场景替换成自己的素材即可；如果路径改变，也同步更新对应 `AssetProfile`。

## 教程提示

- 新内容优先写 `AssetProfile`，单个历史兼容字段才考虑覆写 `Custom...Path`。
- 某个角色资源字段没写时，RitsuLib 会从 `PlaceholderCharacterId` 对应的原版角色配置里补齐。
- 资源路径要以 `res://` 开头，并确认 PCK 内目录名和大小写正确。
- 如果是 `.tscn`，确认场景已经打包进 Mod 资源；需要绑定脚本时，优先写本地包装类并在 `Entry.Initialize()` 调用 `EnsureGodotScriptsRegistered(...)`。

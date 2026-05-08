# RitsuLibModTemplate

语言 / Languages：中文 | [English](README.en.md)

这是一个可复制、可构建的 RitsuLib Mod 模板，保留通用 Godot/C# 工程结构、示例内容和静态占位资源。


## RitsuLib 和教程

- [STS2-RitsuLib](https://github.com/BAKAOLC/STS2-RitsuLib)：Slay the Spire 2 Mod 的共享框架库，本模板基于它提供内容注册、角色脚手架和 Godot 资源接入能力。
- [RitsuLib GitHub 教程目录](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/RitsuLib)：适合按文件阅读教程和示例。
- [Slay the Spire 2 Modding Tutorials 网页版](https://glitchedreme.github.io/SlayTheSpire2ModdingTutorials/index.html)：适合浏览完整教程站点。
- 教程 Wiki： [中文首页](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home) | [English Home](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home-EN)
- 这套 Wiki 以 Rider 为主线，先跑通模板，再逐步理解 RitsuLib 的注册与内容模型。

## RitsuLib 版本选择和兼容性

模板默认使用主线 RitsuLib，并在 `.csproj` 中保留最新可用版本配置：

```xml
<PackageReference Include="STS2.RitsuLib" Version="*" />
```

主线版本主要支持游戏 `0.104.0` 及以上版本。由于上游 API 签名变化，针对 `0.99.1` 的大部分兼容处理已经移除；`Keyword`、`Pile` 等 API 已改为统一 ID 生成规则，部分旧的特定参数不再保留。

如果需要针对游戏 `0.103.2` 分支构建，可以在 `.csproj` 中注释默认包，并启用模板里预留的兼容包配置：

```xml
<PackageReference Include="STS2.RitsuLib.Compat.0.103.2" Version="0.2.19" />
```

兼容包只是用于分包支持旧版本分支，并没有重新引入旧的特定兼容性处理。部分老 Mod 仍然需要修改并重新编译；当游戏将 beta 分支合并到正式版时，也需要主动针对新版本 API 调整代码。

模板包含：

- 一个 `[ModInitializer]` 入口。
- 一个最小自定义角色、角色卡池、遗物池和药水池。
- 四张初始打击、一张初始防御和一个初始遗物示例。
- 最小 Godot 静态占位场景，用于角色战斗模型、能量表盘、角色选择背景、商店和火堆。
- 从原版资源复制并改成模板命名的占位 PNG，复制模板后可以直接替换。
- 中英文基础本地化文件。
- Godot 项目、导出配置、manifest 和构建脚本。

## 使用 NuGet 模板

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

## 手动复制模板

1. 复制整个目录并改成你的 Mod 名称。
2. 修改 `RitsuLibModTemplate.json` 里的 `id`、`name`、`author`、`description`。
3. 修改 `RitsuLibModTemplateCode/Entry.cs` 里的 `ModId`。
4. 如需彻底改名，同时修改 `.csproj`、`.sln`、`project.godot` 的项目名和命名空间。
5. 把资源目录 `RitsuLibModTemplate/` 改成你的 `ModId`，并同步更新代码中的 `Entry.ResPath` 相关路径。

`res://RitsuLibModTemplate/...` 是 Godot/PCK 内的资源路径，对应仓库里的 `RitsuLibModTemplate/` 资源目录，不是 C# namespace。

## 配置本机路径

复制：

```powershell
Copy-Item .\local.props.template .\local.props
```

然后在 `local.props` 中设置：

- `Sts2Dir`：Slay the Spire 2 安装目录。
- `Sts2DataDir`：游戏 dll 目录，通常是 `$(Sts2Dir)/data_sts2_windows_x86_64`。
- `GodotExe`：用于导出 pck 的 MegaDot/Godot 可执行文件。

`local.props` 已加入 `.gitignore`，不要提交。

## 构建

只验证 C# 编译，并跳过 `CopyMod` 和 `ExportPCK`：

```powershell
dotnet build .\RitsuLibModTemplate.csproj /p:RunPckExport=false /p:CopyModOnBuild=false
```

正常构建会在 `Build` 后运行两个 MSBuild target：

- `CopyMod`：复制 dll 和 manifest 到游戏的 `mods/RitsuLibModTemplate` 目录。
- `ExportPCK`：调用 `GodotExe` 导出 pck 到同一个 Mod 目录。

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

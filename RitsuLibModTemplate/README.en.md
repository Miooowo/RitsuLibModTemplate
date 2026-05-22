# RitsuLibModTemplate

Languages: [中文](README.md) | English

RitsuLibModTemplate is a copyable and buildable RitsuLib mod template. It keeps a general Godot/C# project layout, sample content, and static placeholder assets.

## RitsuLib and Tutorials

- [STS2-RitsuLib](https://github.com/BAKAOLC/STS2-RitsuLib): the shared framework library for Slay the Spire 2 mods. This template uses it for content registration, character scaffolding, and Godot resource integration.
- [RitsuLib tutorials on GitHub](https://github.com/GlitchedReme/SlayTheSpire2ModdingTutorials/tree/master/RitsuLib): useful for reading tutorials and examples by file.
- [Slay the Spire 2 Modding Tutorials site](https://glitchedreme.github.io/SlayTheSpire2ModdingTutorials/index.html): useful for browsing the full tutorial site.
- Tutorial Wiki: [Chinese Home](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home) | [English Home](https://github.com/alkaid616/RitsuLibModTemplate/wiki/Home-EN)
- This wiki is Rider-first: get the template running first, then learn how RitsuLib registers and builds content.

## RitsuLib Version Selection and Compatibility

### Current Version Snapshot (As of 2026-05-22)

- Current game version: `0.106.0`
- Current RitsuLib version: `0.3.0`
- The template's `RitsuLibModTemplate.json` (both `min_game_version` and `dependencies[STS2-RitsuLib].version`) is aligned with these two versions. Re-verify against the versions you actually build and test with before publishing — see the checklist below.

The template uses mainline RitsuLib by default and keeps the latest available NuGet version in the `.csproj`. The maintained mainline now targets STS2 `0.105.0` and newer:

```xml
<PackageReference Include="STS2.RitsuLib" Version="*" />
```

Here, `Version="*"` only lets NuGet resolve the compile-time package to the currently available version. The manifest `dependencies` entry is what ships with the mod and what the game loader checks at runtime. Before publishing, keep the `STS2-RitsuLib` version in `RitsuLibModTemplate.json` aligned with the RitsuLib version you actually build and test against. If you intentionally keep the manifest conservative as a runtime floor, document that it is a minimum supported version, not the exact compile-time package.

The project also references `Nothing.STS2RitsuLib.ModAnalyzers` by default. This is an AI-written helper analyzer that reports common manifest and resource configuration issues in RitsuLib mod templates during development.

Only enable one RitsuLib package at a time. If your code still targets STS2 `0.104.0`, comment out the mainline package and enable the `0.104.0` compatibility package:

```xml
<PackageReference Include="STS2.RitsuLib.Compat.0.104.0" Version="*" />
```

If you need to build against STS2 `0.103.2`, enable the `0.103.2` compatibility package:

```xml
<PackageReference Include="STS2.RitsuLib.Compat.0.103.2" Version="*" />
```

STS2 `0.104.0` and `0.103.2` are both compatibility branches with the same maintenance level. Compatibility packages select the matching game branch; they do not restore every old API. Some older mods still need code changes and recompilation.

When upgrading to STS2 `0.105.0` / mainline RitsuLib, check these areas:

- Version conditional compilation now uses cumulative interval macros such as `STS2_AT_LEAST_<ver>`; the old single-target `STS2_V_<ver>` macros are no longer recommended.
- AnyPlayer and AnyAny target logic changed, so old card targets, base constructor signatures, and registration flows should be checked against the new mainline API.
- Cards now support extra icon count labels in the lower-right corner and include conflict handling with vanilla UI; custom UI or icon patches should verify display order and placement.
- Retain/flush hooks and events have replacements, removals, or `[Obsolete]` markers; migrate old uses of `CardRetainedEvent`, `CardsFlushedEvent`, or legacy `Hook.*` entry points.
- Badge, BadgeRuntimeTemplate, BadgePool.CreateAll, and ModBadgeTemplate constructor signatures changed with upstream APIs; old registered-mod death screen badge code may need updates to avoid `MissingMethodException`.

The template includes:

- A `[ModInitializer]` entry point.
- A minimal custom character, card pool, relic pool, and potion pool.
- Four starter strikes, four starter defends, and one starter relic sample.
- Minimal static Godot placeholder scenes for the combat character, energy counter, character select background, merchant, and rest site.
- Placeholder PNG files copied from vanilla resources and renamed for the template. You can replace them after copying the template.
- Basic English and Simplified Chinese localization files.
- A Godot project, export preset, manifest, and build script.

## Using the NuGet Template

Install the template:

```powershell
dotnet new install STS2.RitsuLib.ModTemplate
```

Create a new mod:

```powershell
dotnet new ritsulibmod -n MyMod
```

This creates a project named `MyMod` and replaces `RitsuLibModTemplate`, sample content class names, sample resource file names, resource folders, manifest names, namespaces, and localization IDs with the new name.

Uninstall the template:

```powershell
dotnet new uninstall STS2.RitsuLib.ModTemplate
```

## Directory Layout

```text
RitsuLibModTemplate/
├── RitsuLibModTemplateCode/   # C# source
├── RitsuLibModTemplate/       # Godot resources, localization, and placeholder scenes
├── RitsuLibModTemplate.csproj
├── RitsuLibModTemplate.json
├── project.godot
└── local.props.template
```

## Manual Copy

1. Copy the whole directory and rename it to your mod name.
2. Edit `RitsuLibModTemplate.json` and update `id`, `name`, `author`, and `description`.
3. Edit `RitsuLibModTemplateCode/Entry.cs` and update `ModId`.
4. For a full rename, also update the project name and namespace in `.csproj`, `.sln`, and `project.godot`.
5. Rename the resource directory `RitsuLibModTemplate/` to your `ModId`, then update the related `Entry.ResPath` paths in code.

`res://RitsuLibModTemplate/...` is the Godot/PCK resource path. It maps to the repository resource directory `RitsuLibModTemplate/`, not to the C# namespace.

## Manifest Format

`RitsuLibModTemplate.json` is the mod manifest. The game loader reads it at startup to identify the mod, check dependencies, and decide whether to load it. The full schema:

```json
{
  "id": "RitsuLibModTemplate",
  "name": "RitsuLibModTemplate",
  "pck_name": "RitsuLibModTemplate",
  "author": "Author",
  "description": "A starter Slay the Spire 2 mod template built on RitsuLib.",
  "version": "0.0.0",
  "has_pck": true,
  "has_dll": true,
  "affects_gameplay": true,
  "min_game_version": "0.106.0",
  "dependencies": [
    {
      "id": "STS2-RitsuLib",
      "version": "0.3.0"
    }
  ]
}
```

### Field reference

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique mod identifier. **Must match `Entry.ModId` exactly**, and should also match the `mods/<id>` directory name. In-game dependency lookups, localization key prefixes, and resource paths all depend on this value. When renaming, update every place that uses `ModId`. |
| `name` | string | Display name shown in the mod list. May contain spaces and non-ASCII characters. |
| `pck_name` | string | Name of the `.pck` file the game must load (without extension). **Must match the actual PCK file produced by `.csproj`**, otherwise resources will not load even with `has_pck=true`. In the template it equals `MSBuildProjectName`. |
| `author` | string | Display-only author name. No validation. |
| `description` | string | Short description shown in the mod list. |
| `version` | string | Version of this mod itself. SemVer-style `MAJOR.MINOR.PATCH` is recommended. Bump it on every release. |
| `has_pck` | bool | Whether the mod ships a `.pck` resource pack. Template default `true`; code-only mods can set `false` and skip `ExportPCK`. |
| `has_dll` | bool | Whether the mod ships a `.dll`. Template default `true`; resource-only mods can set `false`. |
| `affects_gameplay` | bool | Whether the mod affects gameplay. When enabled, the game flags relevant systems (saves, achievements, etc.). Only purely cosmetic / localization mods that cannot change combat outcomes should set this to `false`. |
| `min_game_version` | string | Minimum compatible STS2 game version. Older games refuse to load the mod. **Must align with the game branch targeted by the RitsuLib package selected in `.csproj`** (mainline ≥ `0.105.0`, compatibility branches `0.104.0` / `0.103.2`). |
| `dependencies` | array | Other mods this mod depends on. Each entry uses `id` + `version`. **The legacy single-object `min_version` form is no longer supported.** |
| `dependencies[].id` | string | The depended-on mod's `id`. RitsuLib itself uses `STS2-RitsuLib`. |
| `dependencies[].version` | string | The depended-on mod's version, used as the minimum runtime version. The game loader compares it against the installed version and refuses to load if the installed copy is older. |

### **Important: the RitsuLib version in `dependencies` must match the RitsuLib version your `.csproj` actually compiles against**

This is the single most common pre-release mistake — please double-check it.

- `PackageReference Include="STS2.RitsuLib" Version="*"` in `.csproj` only controls **compile-time** NuGet resolution; `*` resolves to whatever the latest version was at restore time.
- `dependencies[STS2-RitsuLib].version` in `RitsuLibModTemplate.json` controls **the runtime version requirement** the game loader sees, and it ships with the mod.
- The two are **independent and never auto-synced.** If you build against a new RitsuLib but forget to bump the manifest, players with an old RitsuLib will pass the manifest check and then crash at runtime due to missing APIs or signature drift. Conversely, an over-tight manifest version will reject players who could otherwise have run the mod.
- The fixed pre-release checklist:
  1. Confirm the actual `STS2.RitsuLib` version that `dotnet restore` resolved (look in `obj/project.assets.json` or your IDE's NuGet view).
  2. Write that version into `dependencies[STS2-RitsuLib].version` in `RitsuLibModTemplate.json`.
  3. When you switch to a compatibility package (`STS2.RitsuLib.Compat.0.104.0` / `Compat.0.103.2`), also adjust `min_game_version` to the corresponding branch. Keep the `dependencies` entry's `id` as `STS2-RitsuLib` (compatibility packages expose the same mod id to the loader).
- If you intentionally want the manifest version to act as a **runtime floor** rather than the compile-time version (for example, declaring "`0.3.0+` works"), document this clearly in your README or release notes and verify that the mod still runs against the declared floor.

The current template example declares `STS2-RitsuLib` as `0.3.0`. After copying the template, run through the checklist above before publishing.

## Local Path Configuration

Copy:

```powershell
Copy-Item .\local.props.template .\local.props
```

Then set or override these values in `local.props`:

- `Sts2Dir`: the Slay the Spire 2 install directory.
- `Sts2DataDir`: the game DLL directory, usually `$(Sts2Dir)/data_sts2_windows_x86_64`.
- `GodotExe`: the MegaDot/Godot executable used to export the PCK.
- `RitsuLibDeployDir`: the local RitsuLib deployment directory, defaulting to `$(Sts2Dir)/mods/STS2-RitsuLib`. RitsuLib package/build logic uses it to copy RitsuLib into the game's mods directory; it is not this mod's output directory.

`local.props` is already listed in `.gitignore`; do not commit it.

## Build

To validate only C# compilation and skip `CopyMod` and `ExportPCK`:

```powershell
dotnet build .\RitsuLibModTemplate.csproj /p:RunPckExport=false /p:CopyModOnBuild=false
```

A normal build runs two MSBuild targets after `Build`:

- `CopyMod`: copies the DLL and manifest to the game's `mods/RitsuLibModTemplate` directory.
- `ExportPCK`: calls `GodotExe` and exports the PCK to the same mod directory.

`RitsuLibDeployDir` separately controls where the RitsuLib framework itself is deployed locally. This mod's DLL, manifest, and PCK are still controlled by `ModOutputDir`.

```powershell
dotnet build .\RitsuLibModTemplate.csproj
```

You can also skip only one target:

```powershell
dotnet build .\RitsuLibModTemplate.csproj /p:CopyModOnBuild=false
dotnet build .\RitsuLibModTemplate.csproj /p:RunPckExport=false
```

After a successful full build, the DLL, manifest, and PCK are copied to the game's `mods/RitsuLibModTemplate` directory.

## Sample Content

Sample character:

- Type: `RitsuLibModTemplateCharacter`
- Expected ID: `RITSU_LIB_MOD_TEMPLATE_CHARACTER_RITSU_LIB_MOD_TEMPLATE_CHARACTER`
- Starter deck: four `RitsuLibModTemplateStrike`, four `RitsuLibModTemplateDefend`, and one `RitsuLibModTemplateRelic`
- Character assets are configured through `CharacterAssetProfile`. The template only specifies copied static placeholder assets; unspecified audio, trail, transition, and similar fields fall back through `PlaceholderCharacterId`.

Sample cards:

- `RitsuLibModTemplateStrike`: attack card, character card pool, expected ID `RITSU_LIB_MOD_TEMPLATE_CARD_RITSU_LIB_MOD_TEMPLATE_STRIKE`
- `RitsuLibModTemplateDefend`: skill card, character card pool, expected ID `RITSU_LIB_MOD_TEMPLATE_CARD_RITSU_LIB_MOD_TEMPLATE_DEFEND`

Sample relic:

- Type: `RitsuLibModTemplateRelic`
- Relic pool: `RitsuLibModTemplateRelicPool`
- Expected ID: `RITSU_LIB_MOD_TEMPLATE_RELIC_RITSU_LIB_MOD_TEMPLATE_RELIC`

## Static Placeholder Assets

Built-in image resources are placed under `res://RitsuLibModTemplate/images/...`:

- `images/cards/RitsuLibModTemplateStrike.png` and `images/cards/RitsuLibModTemplateDefend.png`: sample card art.
- `images/relics/RitsuLibModTemplateRelic.png`: sample relic icon.
- `images/characters/RitsuLibModTemplate_character_*.png`: character icons, select art, map marker, and energy icons.

Built-in scene resources are placed under `res://RitsuLibModTemplate/scenes/characters/...`:

- `RitsuLibModTemplate_character.tscn`: static combat character. Placeholder structure includes `%Visuals`, `%Bounds`, `%IntentPos`, `%CenterPos`, and `%TalkPos`.
- `RitsuLibModTemplate_energy_counter.tscn`: static energy counter. Placeholder structure includes `%EnergyVfxBack`, `%Layers`, `%RotationLayers`, `%EnergyVfxFront`, and `Label`.
- `RitsuLibModTemplate_merchant.tscn`: static merchant character.
- `RitsuLibModTemplate_rest_site.tscn`: static rest site character. Placeholder structure includes `%ControlRoot`, `%SelectionReticle`, `%Hitbox`, `%ThoughtBubbleRight`, and `%ThoughtBubbleLeft`.
- `RitsuLibModTemplate_character_select_bg.tscn`: character select background.

These resources are only meant to make the template visible and replaceable. They do not try to reproduce vanilla animation quality. After copying the template, replace the PNG files or scenes with your own assets; if you change paths, update the related `AssetProfile` fields too.

## Tutorial Tips

- Prefer `AssetProfile` for new content. Only override legacy `Custom...Path` fields for individual compatibility cases.
- If a character resource field is not specified, RitsuLib fills it from the vanilla character config referenced by `PlaceholderCharacterId`.
- Resource paths should start with `res://`; make sure the directory name and casing inside the PCK are correct.
- For `.tscn` files, make sure the scene is included in the mod resources. If it needs a script, prefer a local wrapper class and call `EnsureGodotScriptsRegistered(...)` from `Entry.Initialize()`.

# Electric Editor

**Runtime electric VFX recolor tool for Tekken 8 — full Mishima cast.**

Electric Editor lets you recolor and adjust the brightness of the Mishima-style electric effects (EWGF and related moves) live, in-game, per character and per move. Change the main bolt, glow, and outline colors independently, hit apply, and see it instantly.

> Originally built for Kazuya by request from the Tekken community. Now supports the **entire** Mishima cast — including the three characters long considered impossible to do.

<img width="543" height="478" alt="be591b627dcbdd92-543x478" src="https://github.com/user-attachments/assets/cdbe2b4f-b359-45da-a01f-68826203d99c" />


## Supported characters

- Kazuya
- Reina (electric + kick electric, adjustable separately)
- Kuma
- Heihachi
- Jin
- Devil Jin

## Features

- Per-character, per-move color control (main bolt / glow / outline)
- Independent brightness/intensity sliders for each layer
- Standalone UI — no reliance on the in-game UE4SS menu, avoiding its compatibility issues
- Config-based: settings persist and can be shared

## Requires

- [Tekken 8 UE4SS](https://tekkenmods.com/mod/3761/ue4ss-v3-0-1-for-tekken-8) (follow their install instructions)

## Installation

1. Install Tekken 8 UE4SS using the link above.
2. Drag everything **inside** the mod's `win64` folder into the game's `win64` folder at:
   `/common/TEKKEN 8/Polaris/Binaries/Win64`

## Usage

1. Launch the standalone Electric Editor UI.
2. Pick a character tab, choose your colors and intensities for each layer.
3. Hit **Save Config**, and the changes apply in-game.

## How it works

Tekken 8's electric effects are driven by Niagara particle systems. Rather than repacking game assets, Electric Editor locates the relevant `NiagaraDataInterfaceColorCurve` objects for each character's effect and overwrites their shader color values (`ShaderLUT`) directly at runtime. The patch is reapplied on battle init, so your colors persist across every match.

The tool is split into two parts:
- A **standalone C++/ImGui editor** that writes a config file.
- A **Lua patcher** (running under UE4SS) that reads the config and applies the colors in-game.

This separation is deliberate — it sidesteps the compatibility problems that come from driving everything through the UE4SS menu.

## Download

The ready-to-use mod is available on TekkenMods:
**https://tekkenmods.com/mod/7301/electric-editor-mishima-update**

## Credits

Created by MonkeyTFS.<img width="543" height="478" alt="be591b627dcbdd92-543x478" src="https://github.com/user-attachments/assets/7153aec9-39c0-4b2c-8f42-926db07c106b" />


This project isn't affiliated with or endorsed by BANDAI NAMCO Entertainment. All trademarks are the property of their respective owners.

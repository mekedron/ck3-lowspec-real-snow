# Real Snow Without Advanced Shaders (CK3)

Gives the map its real snow when the graphics option **Advanced Shaders** is off.
Vanilla low spec draws snow as a flat procedural blotch pattern; this mod runs the
same snow *material* the high spec path uses - a proper snow cover with its own
height blend, normal map, roughness and a frost layer - inside the low spec shader.

<img src="thumbnail.png" alt="The Baltic in January with Advanced Shaders off: patchy procedural snow in vanilla, a real snow cover with this mod" width="360">

It is a superset of
[Sharp Terrain Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-terrain-fix):
the snow material needs the per pixel detail height and material that only the sharp
terrain path has, so both live in the same `gfx/FX/pdxterrain.shader`. Use one mod or
the other, not both.

## Cause

With Advanced Shaders off the terrain pixel shader calls `ApplyDynamicMasksDiffuse()`
→ `ApplySnowDiffuse()` in `game/gfx/FX/dynamic_masks.fxh`: three taps of the snow
diffuse at different scales overlaid into a mask, thresholded by the province's winter
severity and lerped into the ground colour. No height blend, no normals, no roughness
change, no frost - just paint. With the option on, the shader calls
`ApplySnowMaterialTerrain()` instead, which blends a snow material into the detail
textures the same way the ground's own materials blend into each other.

The expensive path was never gated on anything the low spec shader lacks. It needs
the detail height (`DetailDiffuse.a`), the detail normal and the detail material -
exactly what the sharp terrain path already computes per pixel and vanilla low spec
throws away.

## Fix

`gfx/FX/pdxterrain.shader` is the Sharp Terrain file with one change in
`PixelShaderLowSpecSharp`, behind `#define TERRAINOPT_SNOW_MATERIAL`:

    #ifdef TERRAINOPT_SNOW_MATERIAL
        ApplySnowMaterialTerrain( DetailDiffuseHeight, DetailNormal, DetailMaterial, Normal, ... , SnowHighlight );
        DetailDiffuse = DetailDiffuseHeight.rgb;
    #else
        DetailDiffuse = ApplyDynamicMasksDiffuse( DetailDiffuse, Normal, ColorMapCoords );
    #endif

The snow material writes into the detail normal and material as well, and the sharp
path feeds both into lighting (`ReorientNormal`, roughness), so snow gets its own
relief and sheen. `SnowHighlight` now carries the real snow mask into the white
highlight compensation, as in high spec.

Comment the define out, re-run `./install.sh`, restart the game to get the Sharp
Terrain look back.

## Cost

Measured on an RTX 3050 Ti Laptop (4 GB) at 5120x1440, January, the Baltic: about
**4 ms of frame time** where snow is possible - up to eight extra texture taps per
pixel (two of them anti tiling gradient pairs) and a heightmap read. Where the snow
mask says "never snow" (the south), the shader exits after one tap. On this machine
the low spec 60 FPS held with V-Sync on.

## What is not changed

* Everything Sharp Terrain does is kept as is (per pixel details, the hidden-terrain
  early out, no shadows, no clouds, no province effects, low spec sun lighting).
* Trees. With Map Objects on, leaves keep whatever snow their tree shader gives them
  (vanilla: the full material; Faster Trees: the cheap one), which can differ a little
  from the ground.
* Nothing with Advanced Shaders on - the high spec effects are untouched.

## Layout

    descriptor.mod              mod metadata
    thumbnail.png               Workshop preview, must sit in the mod root
    gfx/FX/pdxterrain.shader    overrides game/gfx/FX/pdxterrain.shader
    install.sh                  copies the mod into the Proton prefix
    tools/check_log.sh          mount + shader error check after a game start
    tools/compile_check.py      offline compile check with DXC (see below)
    tools/diff_vanilla.sh       re-diff against the Steam file after a patch
    steam-workshop/             listing texts and the thumbnail generator

## Installing

Run `./install.sh`. It copies the mod into the CK3 mod directory **inside the Proton
prefix** (`~/.local/share/Steam/steamapps/compatdata/1158310/pfx/drive_c/users/steamuser/Documents/Paradox Interactive/Crusader Kings III/mod/`),
which is what the game and the launcher use under Proton. Close the launcher before
installing, then enable "Real Snow Without Advanced Shaders" in the playset and
disable "Sharp Terrain Without Advanced Shaders" if it is there.

Keep **Advanced Shaders off**; with it on the game uses the high spec effect and this
file changes nothing. The first map load is slower while the shader compiles.

## Verifying without starting the game

    tools/compile_check.py --dxc <dir with bin/dxc and lib/libdxcompiler.so>

takes the vanilla entries of `PdxTerrain` and `PdxTerrainLowSpec` from the game's
shader cache (expanded HLSL), swaps in this file's code blocks and compiles them with
DXC, the compiler the game uses for Vulkan.

## Game version

Built against 1.19.0.6 (Scribe). Shader overrides replace the vanilla file wholesale,
so after a patch run `tools/diff_vanilla.sh` and re-apply the two banners at the top
of the shader onto the new vanilla copy.

## Multiplayer / achievements

Shader files are not checksummed content, but the launcher still marks any mod as a
mod. Treat it like any other graphics mod.

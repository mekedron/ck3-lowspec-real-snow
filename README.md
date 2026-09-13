# Real Snow Without Advanced Shaders (CK3)

An add-on for [Sharp Terrain Without Advanced Shaders](https://github.com/mekedron/ck3-lowspec-terrain-fix)
that gives the map its real snow when the graphics option **Advanced Shaders** is off.
Vanilla low spec draws snow as a flat procedural blotch pattern; with this add-on the
terrain shader runs the same snow *material* the high spec path uses - a proper snow
cover with its own height blend, normal map, roughness and a frost layer.

<img src="thumbnail.png" alt="The Baltic in January with Advanced Shaders off: patchy procedural snow in vanilla, a real snow cover with this mod" width="360">

## How it works

The whole mod is one file, `gfx/FX/sharp_terrain_options.fxh`, containing

    #define TERRAINOPT_SNOW_MATERIAL

Sharp Terrain's `pdxterrain.shader` includes a file of that name first and carries the
snow material code behind that define, switched off in the base mod. The game resolves
includes by path across every enabled mod and the lowest mod in the load order wins, so
this copy replaces the base mod's options file and the option comes on. No shader is
duplicated, and the base mod can be updated independently.

Requires Sharp Terrain Without Advanced Shaders **above** this mod in the load order.
On its own this file is never read and the mod does nothing.

On the map of **A Game of Thrones** Sharp Terrain needs
[Sharp Terrain & Better Water: A Game of Thrones Patch](https://github.com/mekedron/ck3-lowspec-agot-patch) below both;
the patch's terrain shader includes the same options file, so this add-on works there
unchanged.

## What the option does

With Advanced Shaders off the terrain pixel shader normally calls
`ApplyDynamicMasksDiffuse()` → `ApplySnowDiffuse()` (`game/gfx/FX/dynamic_masks.fxh`):
three taps of the snow diffuse overlaid into a mask, thresholded by the province's
winter severity and painted over the ground. With the option on, Sharp Terrain calls
`ApplySnowMaterialTerrain()` instead - the high spec path - which blends a snow material
into the per pixel detail height, normal and material, so snow gets its own relief and
sheen, plus a frost layer at the edges.

## Cost

About **4 ms of frame time** where snow is possible, measured on an RTX 3050 Ti Laptop
(4 GB) at 5120x1440 in January. Where the snow mask says "never snow" the shader exits
after one tap. On that machine the low spec 60 FPS held with V-Sync on.

## Layout

    descriptor.mod                        mod metadata
    thumbnail.png                         Workshop preview, must sit in the mod root
    gfx/FX/sharp_terrain_options.fxh      the mod
    install.sh                            copies the mod into the Proton prefix
    tools/check_log.sh                    mount check after a game start
    steam-workshop/                       listing texts and the thumbnail generator

## Installing

Run `./install.sh`. It copies the mod into the CK3 mod directory inside the Proton
prefix. Then, in the launcher playset, enable it **below** Sharp Terrain Without
Advanced Shaders and keep Advanced Shaders off in the game. The first map load is
slower while the shader recompiles.

## Game version

Built against 1.19.0.6 (Scribe) and Sharp Terrain 1.1. The file has no vanilla
counterpart, so game patches do not touch it; only a Sharp Terrain release that renames
the option would.

## Multiplayer / achievements

Shader options are not checksummed content, but the launcher still marks any mod as a
mod. Treat it like any other graphics mod.

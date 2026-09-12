# Real Snow Without Advanced Shaders.
#
# This is the whole mod: a copy of gfx/FX/sharp_terrain_options.fxh from Sharp Terrain
# Without Advanced Shaders with the snow option switched on. The shader includes this
# file first; with this mod placed BELOW Sharp Terrain in the load order the game
# resolves the include to this copy, and the terrain shader draws the high spec snow
# material (ApplySnowMaterialTerrain: height blend, normal map, roughness, frost layer)
# instead of the flat procedural low spec snow.
#
# Requires Sharp Terrain Without Advanced Shaders; on its own this file is never read.

Code
[[
	#define TERRAINOPT_SNOW_MATERIAL
]]

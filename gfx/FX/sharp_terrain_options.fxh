# Real Snow Without Advanced Shaders.
#
# This is the whole mod: a copy of gfx/FX/sharp_terrain_options.fxh from Sharp Terrain
# Without Advanced Shaders with the snow option switched on. The shader includes this
# file first; with this mod placed BELOW Sharp Terrain in the load order the game
# resolves the include to this copy, and the terrain shader draws the snow material
# (height blend, normal map, roughness, frost layer) instead of the flat procedural
# low spec snow - the cheap version, ApplySnowMaterialTerrainCheap in Sharp Terrain:
# vanilla's material with every no-tile lookup replaced by one plain texture read.
#
# Requires Sharp Terrain Without Advanced Shaders 1.2 or later; on its own this file
# is never read.

Code
[[
	#define TERRAINOPT_SNOW_MATERIAL

	// Vanilla's own ApplySnowMaterialTerrain instead of the cheap one: the no-tile
	// scrambling of the snow texture back, at about twice the texture reads plus the
	// noise math. Uncomment for comparing, or if your GPU does not care.
	//#define TERRAINOPT_SNOW_MATERIAL_VANILLA
]]

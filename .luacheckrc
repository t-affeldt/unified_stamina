
std = "luajit+minetest+sprint_mods"
ignore = { "212" }

files[".luacheckrc"].std = "min+luacheck"

stds.luacheck = {}
stds.luacheck.globals = {
    "files",
    "ignore",
    "std",
    "stds"
}

stds.minetest = {}
stds.minetest.read_globals = {
    "DIR_DELIM",
    "minetest",
    "dump",
    "vector",
    "VoxelManip",
    "VoxelArea",
    "PseudoRandom",
    "PcgRandom",
    "ItemStack",
    "Settings",
    "unpack",
    "assert",
    "S",
    table = { fields = { "copy", "indexof" } },
    math = { fields = { "sign" } }
}

stds.sprint_mods = {}
stds.sprint_mods.globals = {
    "unified_stamina"
}
stds.sprint_mods.read_globals = {
    "mcl_sprint",
    "hb",
    "minetest_wadsprint",
    "sprint_lite",
    "real_stamina",
    "cmo"
}

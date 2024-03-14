---@diagnostic disable: deprecated
-- STAR WARS BATTLEFRONT CLASSIC COLLECTION - Old Mod Patcher
-- Greetings from Kenny

__scriptName__ = "[CCPatch: addme.script]: "

funcs = {
	ReadDataFile,
	ScriptCB_IsFileExist,
	ScriptCB_DoFile
}

-- We need this stuff twice. Once for the shell, once for mission states.
patchDir = "..\\..\\addon2\\0\\patch_ingame"
if ScriptCB_IsFileExist(patchDir .. ".lvl") == 1 then
	ReadDataFile(patchDir .. ".lvl")
	ScriptCB_DoFile("patch_ingame")
    patch_ingame()
end

md MUNGED 
del /Y MUNGED\*
:: currently no textures are used.
::..\ToolsFL\bin\pc_TextureMunge.exe -inputfile $*.tga  -checkdate -continue -platform PC -sourcedir src\textures -outputdir MUNGED 

..\ToolsFL\bin\ScriptMunge.exe -inputfile *.lua   -continue -platform PC -sourcedir  src\scripts -outputdir MUNGED  

:: currently no config files are used.
::..\ToolsFL\bin\ConfigMunge.exe -inputfile $*.mcfg -continue -platform PC -sourcedir src\config -outputdir MUNGED -hashstrings 

..\ToolsFL\bin\levelpack.exe -inputfile patch_ingame.req -writefiles MUNGED\patch_ingame.files -continue -platform PC -sourcedir  src -inputdir MUNGED\ -outputdir . 

move *.log MUNGED

md "0"
del  "0/*"
copy patch_ingame.lvl "0\"
copy MUNGED\addme.script "0\"

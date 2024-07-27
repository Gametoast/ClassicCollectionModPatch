

:: Building the patch/mod/thing
:: This folder should be under your BF2_ModTools Folder.
:: Run this munge.bat file to build the addme and 'patch_ingame.lvl''.

md MUNGED 
del /Q MUNGED\*
:: currently no textures are used.
..\ToolsFL\bin\pc_TextureMunge.exe -inputfile $*.tga  -continue -platform PC -sourcedir  src\textures -outputdir MUNGED 

..\ToolsFL\bin\ScriptMunge.exe     -inputfile $*.lua  -continue -platform PC -sourcedir  src\scripts  -outputdir MUNGED  

..\ToolsFL\bin\configmunge.exe     -inputfile $*.fx   -continue -platform PC -sourcedir  src\effects  -outputdir MUNGED

:: currently no config files are used.
::..\ToolsFL\bin\ConfigMunge.exe -inputfile $*.mcfg -continue -platform PC -sourcedir src\config -outputdir MUNGED -hashstrings 

..\ToolsFL\bin\levelpack.exe -inputfile addme.req -writefiles MUNGED\addme.files -continue -platform PC -sourcedir  src -inputdir MUNGED\ -outputdir . 

..\ToolsFL\bin\levelpack.exe -inputfile patch_ingame.req -writefiles MUNGED\patch_ingame.files -continue -platform PC -sourcedir  src -inputdir MUNGED\ -outputdir . 

..\ToolsFL\bin\levelpack.exe -inputfile patch_shell.req -writefiles MUNGED\patch_shell.files -continue -platform PC -sourcedir  src -inputdir MUNGED\ -outputdir . 

move *.log MUNGED

md "0"
del  "0/*"
copy /Y MUNGED\globals.script "0\patch_scripts\"
copy /Y MUNGED\patch_paths.script "0\patch_scripts\"
copy /Y patch_shell.lvl "0\patch_scripts\"
copy /Y patch_ingame.lvl "0\patch_scripts\patch_ingame.lvl"
copy /Y MUNGED\user_script_*.script "0\in-game-options\"
copy /Y deploy_lvl\*.lvl "0\in-game-options\"
copy /Y .\addme.lvl "0\addme.script"

copy /y readme.md "0\readme.txt"
time /t 
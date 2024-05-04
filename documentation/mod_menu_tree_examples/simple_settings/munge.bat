md MUNGED 
del /Q MUNGED\*
::C:\BF2_ModTools\ToolsFL\bin\pc_TextureMunge.exe -inputfile $*.tga  -checkdate -continue -platform PC -sourcedir . -outputdir MUNGED 

C:\BF2_ModTools\ToolsFL\bin\ScriptMunge.exe -inputfile *.lua   -continue -platform PC -sourcedir  . -outputdir MUNGED  

::C:\BF2_ModTools\ToolsFL\bin\ConfigMunge.exe -inputfile $*.mcfg -continue -platform PC -sourcedir . -outputdir MUNGED -hashstrings 

::C:\BF2_ModTools\ToolsFL\bin\levelpack.exe -inputfile addme.req -writefiles MUNGED\addme.files -continue -platform PC -sourcedir  . -inputdir MUNGED\ -outputdir . 

move /Y MUNGED\*.script .
move *.log MUNGED


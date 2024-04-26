
** Note Process in this file is for targeting BF2 Classic Collection. A similar process could be used for the
   base game, but the hud filename '0xDC27B03D.hud_' won't work for the base game (unless replacing manually 
   through the LVLTool GUI).

The pattern for delivering a hud for BF2 Classic Collection is to deliver a well-named-folder
with the following files:
   preview_images         -- Include a few preview images so that users can see why your hud is so nice.
   0xDC27B03D.hud_        -- The munged Hud file. Special build instructions below.
   apply_hud.bat          -- Should be ok to just copy one from the default aspyr hud folder since your 
                             hud folder is to be deployed next to all the other huds (inside '0\hud-options\')
   hud_texture_pack.lvl   -- If you don't use any special textures just copy the one from the default aspyr 
                             folder and deploy it with your hud.

You can use the munge_hud.bat file in this folder to munge your .hud file.
(BF2 Modtools required, adjust batch file if your modtools aren't stored at C:\BF2_ModTools\)

============================ String hashing special-ness  ============================ 
The BF2 build often runs a special hash operation on filenames (and other strings) to compress strings into 4 bytes.

We don't know the real filename for the Aspyr 1 player Hud.
The name was translated to the hash '0xdc27b03d'
Which has a matching un-hash of 'zri6jc'; surely Not the name aspyr chose, 
but since the hash matches it'll work.

After you've crafted a beautiful hud and tested with the ModTools debugger (or whatever your process is),
name your HUD file 'zri6jc.hud'
Then run the included batch file.

The output file in the MUNGED folder will/may be named 'zri6jc.config'; re-name it to '0xdc27b03d.hud_' 
to get it to replace the existing one using the apply_hud.bat (which uses LVLTool).

-- user_script_cc_music_fix.lua 
-- Fixes the music in mod levels due to the addition of sound\\music.lvl (Aspyr patch 3)
-- author: BAD-AL 

--    OpenAudioStream("sound\\global.lvl",  "cw_music")
--    OpenAudioStream("sound\\global.lvl",  "gcw_music")

--    OpenAudioStream("sound\\music.lvl","cw_music")
--    OpenAudioStream("sound\\music.lvl","gcw_music")

if( ScriptCB_IsFileExist("sound\\music.lvl") == 1) then
	print("info: sound/music.lvl exists, define special fix")

	local oldOpenAudioStream = OpenAudioStream
	OpenAudioStream = function(...)
		
		if( table.getn(arg) > 1 
		    and string.find(string.lower(arg[1]), "^sound[\\/]global.lvl") ~= nil ) 
		    and (arg[2] == "cw_music" or arg[2] == "gcw_music"                      ) then
			print("info: (g)cw_music global.lvl -> music.lvl ")
			arg[1] = "sound\\music.lvl"
		end
		
		return oldOpenAudioStream(unpack(arg))
	end
else
	print("info: sound/music.lvl does not exist, no special fix")
end
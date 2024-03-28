For finding preview movies we'll follow 2 conventions.
 1. Priority is given to the 'UOP' way where movieName and path to the movie is attached to an entry in the  'sp_missionselect_listbox_contents'
    
    local entry = {
      mapluafile =  "ABC%s_%s",
      movieFile = "..\..\addon\ABC\data\_LVL_PC\Movies\abc",
	    movieName =  "preview",
      era_c= 1, 
      mode_con_c= 1
    }
 2. Look in the following location for the movie file:
      addon2\0\movies\FLY\ABCfly.mvs

Get the map fly-through video as follows:
prefix of 'mapluafile' + 'fly.mvs'
(The inner movie of the .mvs file needs to be named 'preview')

Example:
    Corsaunt Jedi Temple has a missionlist entry of:
        { mapluafile = "cor1%s_%s", era_g = 1, era_c = 1, mode_con_c = 1, mode_con_g = 1, mode_ctf_c = 1, mode_ctf_g = 1,},

    mapluafile = "cor1%s_%s"

    prefix = "cor1"

    movieFileName = "cor1fly.mvs"

We will look in the following location for the movie files (if not otherwise specified with movieFile and movieName ):
    addon2\0\movies\FLY\

Note:
To Convert .mp4 movies to XBOX format (.xmv) you can use the package found at:
 https://github.com/BAD-AL/SWBF2_Xbox_mod_effort/tree/master/XBOX/XBOX_Video_Converter    

To convert .mp4 to .bik you can use the 'Rad Video' tools
  https://www.radgametools.com/bnkdown.htm
  
============================================================================================================
Making a preview movie:
1. Record your short preview movie, convert it to the appropiate format (recommend 3-4 shots [about 4 seconds each shot]).
2. Be sure to name it according to the convension mentioned above (i.e.  'ABCfly.bik')
3. Place the movie in the 'movies' folder.
4. Run the 'munge_movies.bat' file

Note 2:
  Check over the 'munge_movies.bat' batch file to ensure the modtools folder is referenced correctly for your box and
  make sure it's using the correct file extension for the platform you are targeting.

Note 3:
  The included 'fly.mcfg' and 'fly.lvl' include the definitions for the 'preview' and 'preview-loop' movie definitions. 
  
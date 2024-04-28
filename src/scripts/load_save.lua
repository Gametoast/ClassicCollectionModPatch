------------------------------------------------------------------

-- SWBF 2 Remaster by Anakin (<-- original author)
-- sourced from: https://github.com/Gametoast/data_Remaster/blob/main/CustomLVL/scripts/interface/load_save.lua
-- modified by (BAD_AL) for zero patch settings
------------------------------------------------------------------

-- Note: 'ifs_saveop' binary equal in GOG game 
-- CC ifs_saveop.ifs_saveop_SaveProfileDone, ifs_saveop.ifs_saveop_StartPromptSave are gutted 

local remaIOfilename = "RemasterGlobalSettings"
local remaInstFilename = "RemasterInstOpt"
rema_database = {}
------------------------------------------------------------------
-- wrap AddIFScreen
-- install backdoor in ifs_saveop.Exit
local remaIO_AddIFScreen = AddIFScreen
AddIFScreen = function(table, name,...)
		
	-- instal backdoor to avoid errors
	if name == "ifs_saveop" then
					
		-- backup old function
		local remaIO_saveopExit = ifs_saveop.Exit
		
		-- wrap ifs_saveop.Exit
		ifs_saveop.Exit = function(this, bFwd)
			
			--rema_pauseHook = false
			--rema_SaveSettingState()
			
			-- instal backdoor
			if this.beSneaky then
			
				local b1 = this.NoPromptSave
				local b2 = this.profile1
				local b3 = this.profile2
				local b4 = this.profile3
				local b5 = this.profile4
				local b6 = this.filename1	
				local b7 = this.bFromCancel
				local b8 = this.FromOverwrite
				local b9 = this.ForceSaveFailedMessage
				local b10 = this.saveProfileNum
				local b11 = this.saveName
				local b12 = this.OnSuccess
				local b13 = this.OnCancel
				local b14 = this.doOp
				
				-- let the original function happen..
				local remaIO_return = {remaIO_saveopExit(this, bFwd)}
			
				this.NoPromptSave = b1
				this.profile1 = b2
				this.profile2 = b3
				this.profile3 = b4
				this.profile4 = b5
				this.filename1 = b6		
				this.bFromCancel = b7
				this.FromOverwrite = b8
				this.ForceSaveFailedMessage = b9
				this.saveProfileNum = b10
				this.saveName = b11
				this.OnSuccess = b12
				this.OnCancel = b13
				this.doOp = b14
				
				-- ..but restore the data before return
				return unpack(remaIO_return)
			end
			
			-- let the original function happen
			return remaIO_saveopExit(this, bFwd)
		end
		
		-- overwrite ifs_saveop_StartPromptMetagameOverwrite()
		function ifs_saveop_StartPromptMetagameOverwrite()

			local this = ifs_saveop
			
			-- is there a current metagame filename?
			local metagame_exist = nil
			if( this.filename1 ) then
				metagame_exist = ScriptCB_DoesMetagameExistOnCard(this.filename1)
			end
				
			if( (not this.filename1) or (not metagame_exist) or ifs_saveop.beSneaky) then
				-- nope, just skip the confirmation
				ifs_saveop_MetagameOverwritePromptDone(1)
				return		
			end
			
			-- show the yes/no popup
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_saveop_MetagameOverwritePromptDone
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, ifs_saveop.PlatformBaseStr .. ".save25")
		end
	end

	-- let the original function happen
	return remaIO_AddIFScreen(table, name, unpack(arg))
end

------------------------------------------------------------------
-- wrap ScriptCB_PushScreen
-- load settings before ifs_boot
-- refresh instant options 
local remaIO_PushScreen = ScriptCB_PushScreen
ScriptCB_PushScreen = function(name,...)

	if name == "ifs_boot" then
		print("info: Start Load process")
		swbf2Remaster_settingsManager("load",
			function(failure)
				swbf2Remaster_dataIntegrityTest(failure)
				print("remaster load_save: tried to load settings got message: " .. tostring(failure))
				--if( failure ~= nil) then 
				--	SaveSettings()
				--end
				remaIO_PushScreen("ifs_boot")
				end)
	else
		remaIO_PushScreen(name, unpack(arg))
	end
end


------------------------------------------------------------------
-- wrap SetState
-- put database on the pipe
if SetState then
	
	local remaIO_setState = SetState
		
		SetState = function(...)
		
			-- we only need this data
			local lite_databse = {
				isRemaDatabase = true,
				data = rema_database.data,
			}
			
			if ScriptCB_IsMetagameStateSaved() then
				-- there is old data
				local temp = {ScriptCB_LoadMetagameState()}

				ScriptCB_SaveMetagameState(
					lite_databse,
					temp[1],
					temp[2],
					temp[3],
					temp[4],
					temp[5],
					temp[6],
					temp[7],
					temp[8],
					temp[9],
					temp[10],
					temp[11],
					temp[12],
					temp[13],
					temp[14],
					temp[15],
					temp[16],
					temp[17],
					temp[18],
					temp[19],
					temp[20],
					temp[21],
					temp[22],
					temp[23],
					temp[24],
					temp[25],
					temp[26]
				)
				
			else
				-- there is no old data
				ScriptCB_SaveMetagameState(lite_databse)
			end
			
			return remaIO_setState(unpack(arg))
		end
else
	print("Remaster: Error")
	print("        : SetState not found")
end


------------------------------------------------------------------
-- new functions

function swbf2Remaster_dataIntegrityTest(failure)

	-- if there were any errors while loading, print them
	if failure then
		print("Remaster: settings error, ", failure)
	end
	
	-- check if all data is there
	if rema_database.data == nil then
		print("Remaster: data integrity test failed, loading default..")
		rema_database = swbf2Remaster_getDefaultSettings()
	end
end


function swbf2Remaster_getDefaultSettings()

	return  { data = {}, }
end

function swbf2Remaster_loadSettings(nameIO, nameInst, funcDone, loadInstOpt)
	print(string.format("swbf2Remaster_loadSettings: nameIO: %s ; nameInst: %s  loadInstOpt: %s", 
							tostring(nameIO), tostring(nameInst), tostring(loadInstOpt)))
	ifs_saveop.doOp = "LoadMetagame"
	ifs_saveop.NoPromptSave = 1
	ifs_saveop.beSneaky = 1
	
	if loadInstOpt == nil then

		ifs_saveop.filename1 = nameIO
	
		ifs_saveop.OnSuccess = function()

			ScriptCB_PopScreen()
			
			rema_database = ScriptCB_LoadMetagameState()
			ScriptCB_ClearMetagameState()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			swbf2Remaster_loadSettings(nameIO, nameInst, funcDone, true)
		end
		
		ifs_saveop.OnCancel = function()
			print("Remaster: loading settings failed, loading default..")
			ScriptCB_PopScreen()
			
			rema_database = swbf2Remaster_getDefaultSettings()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			funcDone("loading failed, loading default instead")
		end
		
	else

		if nameInst == nil then
			print("Remaster: missing instant options, loading defaults..")
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			funcDone(nil)
			return
		else
		
			ifs_saveop.filename1 = nameInst
			
			ifs_saveop.OnSuccess = function()
				
				ScriptCB_PopScreen()
				rema_database.instOp = ScriptCB_LoadMetagameState()
				ScriptCB_ClearMetagameState()
				
				ifs_saveop.OnSuccess = ifs_saveop_Success
				ifs_saveop.OnCancel = ifs_saveop_Cancel
				ifs_saveop.beSneaky = nil
				funcDone(nil)
			end
			
			ifs_saveop.OnCancel = function()
				print("Remaster: loading instant options failed, loading defaults..")
				ScriptCB_PopScreen()
				
				ifs_saveop.OnSuccess = ifs_saveop_Success
				ifs_saveop.OnCancel = ifs_saveop_Cancel
				ifs_saveop.beSneaky = nil
				funcDone(nil)
			end
		end
	end
	
	ScriptCB_PushScreen("ifs_saveop")
end
--local remaIOfilename = "RemasterGlobalSettings"
--local remaInstFilename = "RemasterInstOpt"

function swbf2Remaster_saveSettings(nameIO, nameInst, funcDone, skipInst)
	
	if not rema_database then
		print("Remaster: saving settings failed, no settings found..")
		ifs_saveop.OnSuccess = ifs_saveop_Success
		ifs_saveop.OnCancel = ifs_saveop_Cancel
		ifs_saveop.beSneaky = nil
		funcDone("settings do not exist")
		return
	end
	print("swbf2Remaster_saveSettings rema_database: ")
	tprint(rema_database)
	
	-- save instant options?
	local saveInstOpt = false
	
	if rema_database.data.saveSpOptions == 2 and rema_database.instOp.GamePrefs ~= nil and skipInst == nil then
		saveInstOpt = true
	end
	
	-- splitt instant options from database
	local temp = rema_database.instOp
	rema_database.instOp = {}
	
	ifs_saveop.doOp = "SaveMetagame"
	ifs_saveop.NoPromptSave = 1
	ifs_saveop.beSneaky = 1
	
	print("swbf2Remaster_saveSettings doOp: " .. tostring(ifs_saveop.doOp))
	if saveInstOpt then
		print("swbf2Remaster_saveSettings: saveInstOpt")
		ScriptCB_SaveMetagameState(temp)
		
		ifs_saveop.filename1 = nameInst
		ifs_saveop.filename2 = ScriptCB_tounicode(remaInstFilename)
		
		ifs_saveop.OnSuccess = function()
			ScriptCB_PopScreen()
			ScriptCB_ClearMetagameState()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			swbf2Remaster_saveSettings(nameIO, nameInst, funcDone, true)
		end
		
		ifs_saveop.OnCancel = function()
			print("Remaster: saving instant options failed..")
			print("        : trying to save database anyway..")
			ScriptCB_PopScreen()
			ScriptCB_ClearMetagameState()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			swbf2Remaster_saveSettings(nameIO, nameInst, funcDone, true)
		end
	else
		print("swbf2Remaster_saveSettings: save database")
		ScriptCB_SaveMetagameState(rema_database)
		
		ifs_saveop.filename1 = nameIO
		ifs_saveop.filename2 = ScriptCB_tounicode(remaIOfilename)
		--if(nameIO == nil) then 
		--	ifs_saveop.filename1 = ifs_saveop.filename2
		--end

		printf("filename1: %s; filename2: %s", tostring(ifs_saveop.filename1), tostring(ifs_saveop.filename2))
		printf("filename1: %s; filename2: %s", ScriptCB_ununicode(ifs_saveop.filename1), ScriptCB_ununicode(ifs_saveop.filename2))
	
		ifs_saveop.OnSuccess = function()
			ScriptCB_PopScreen()
			ScriptCB_ClearMetagameState()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			funcDone(nil)
		end
		
		ifs_saveop.OnCancel = function()
			print("Remaster: saving settings failed..")
			ScriptCB_PopScreen()
			ScriptCB_ClearMetagameState()
			
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			funcDone("saving failed")
		end
	end
	
	-- merge instant options and database
	rema_database.instOp = temp
	temp = nil
	
	-- let the magic happen
	ScriptCB_PushScreen("ifs_saveop")
	
end

function swbf2Remaster_getFilename(filelist, name1, name2)
	if not filelist then
		return nil, nil
	end
	
	local i, currentFilename
	local foundFilenames = { nil, nil}
	
	for i = 1, table.getn(filelist) do
		currentFilename = ScriptCB_ununicode(filelist[i].filename)
		
		if string.find(currentFilename, name1) == 1 then
			foundFilenames[1] = filelist[i].filename
		elseif string.find(currentFilename, name2) == 1 then
			foundFilenames[2] = filelist[i].filename
		end
	end
	
	return unpack(foundFilenames)
end

-- operation = "save" or "load"
-- settings loaded into rema_database
-- settings saved from rema_database
-- funcDone(failure))
-- failure = nil if successfull or error string
function swbf2Remaster_settingsManager(operation, funcDone)

	ifs_saveop.doOp = "LoadFileList"
	ifs_saveop.OnSuccess = nil --ifs_saveop_Success
	ifs_saveop.OnCancel = nil --ifs_saveop_Cancel
	ifs_saveop.beSneaky = 1

	print("swbf2Remaster_settingsManager: " .. tostring(operation))
	printf("swbf2Remaster_settingsManager: doOp %s", tostring(ifs_saveop.doOp))
	
	if operation == "load" then
		print("swbf2Remaster_settingsManager: perform load operation")
		ifs_saveop.OnSuccess = function()
			print("swbf2Remaster_settingsManager: load ifs_saveop.OnSuccess")
			ScriptCB_PopScreen()
			
			-- find the filename
			local filelist, maxSaves = ScriptCB_GetSavedMetagameList(false)
			printf("maxSaves: %s", tostring(maxSaves))
			printFileList(filelist)
			local filenameIO, filenameInst = swbf2Remaster_getFilename(filelist, remaIOfilename, remaInstFilename)
			
			if not filenameIO then
				print("cant load, bad filename!")
				ifs_saveop.OnSuccess = ifs_saveop_Success
				ifs_saveop.OnCancel = ifs_saveop_Cancel
				ifs_saveop.beSneaky = nil
				rema_database = swbf2Remaster_getDefaultSettings()
				funcDone("unable to find settings file, loading default settings")
				return
			end
			
			-- now load the data
			swbf2Remaster_loadSettings(filenameIO, filenameInst, funcDone)
		end
		
		ifs_saveop.OnCancel = function()
			print("Remaster: loading filelist failed..")
			ScriptCB_PopScreen()
			
			-- cannot load the data. Load default instead(?)
			rema_database = swbf2Remaster_getDefaultSettings()
			ifs_saveop.OnSuccess = ifs_saveop_Success
			ifs_saveop.OnCancel = ifs_saveop_Cancel
			ifs_saveop.beSneaky = nil
			funcDone("unable to load filelist, loading default settings")
		end
		
	elseif operation == "save" then
		print("swbf2Remaster_settingsManager: perform save operation")
		ifs_saveop.OnSuccess = function()
			print("swbf2Remaster_settingsManager: ifs_saveop.OnSuccess")

			ScriptCB_PopScreen()
			
			-- clean up first manuel to avoid pop ups
			local filelist, maxSaves = ScriptCB_GetSavedMetagameList(false)
			printf("maxSaves: %s", tostring(maxSaves))
			print("filelist:")
			printFileList(filelist)
			local filenameIO, filenameInst = swbf2Remaster_getFilename(filelist, remaIOfilename, remaInstFilename)
			-- now save the data
			swbf2Remaster_saveSettings(filenameIO, filenameInst, funcDone)
		end
		
		ifs_saveop.OnCancel = function()
			print("swbf2Remaster_settingsManager: ifs_saveop.OnCancel")
			print("Remaster: loading filelist failed, try to save anyway..")
			ScriptCB_PopScreen()
			
			-- we failed, but try to save the data anyway
			swbf2Remaster_saveSettings(nil, nil, funcDone)
		end
	else
		print("Remaster: undefined settings operation..")
		ifs_saveop.doOp = nil
		ifs_saveop.OnSuccess = ifs_saveop_Success
		ifs_saveop.OnCancel = ifs_saveop_Cancel
		ifs_saveop.beSneaky = nil
		funcDone("undefined settings operation")
		return
	end
	
	printf("swbf2Remaster_settingsManager: doOp %s ; push it", tostring(ifs_saveop.doOp))
	ScriptCB_PushScreen("ifs_saveop");
end

local function stringify(data)
    local retVal = ""
    for key, value in data do
        retVal = retVal .. string.format("%s:%s;", key,ScriptCB_ununicode(value))
    end
    return retVal
end

function printFileList(fileList)
	--printf("%s'%s',", formatting, tostring(ScriptCB_ununicode(value)))
	print("printFileList:")
	for k,v in fileList do
		print(string.format("   %s: %s", k,stringify(v) ))
	end
	
end
-- load is automatically done whrn ifs_boot is pushed (shell space)


-- data loaded to 'rema_database' after calling this
function  LoadSettings()
	local doneFunc = function(msg)
		print("LoadSettings: msg = ".. tostring(msg))
		if(tprint ~= nil) then 
			print("rema_database:")
			tprint(rema_database)
		end
	end
	swbf2Remaster_settingsManager("load", doneFunc)
end

-- put data on 'rema_database' before calling this
-- i.e. rema_database.data = zero_patch_data
function SaveSettings()
	local doneFunc = function(msg)
		print("SaveSettings: msg = ".. tostring(msg))
	end
	swbf2Remaster_settingsManager("save", doneFunc)
end


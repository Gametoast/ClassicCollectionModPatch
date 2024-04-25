

local mp_replace_ScriptCB_DoFile = ScriptCB_DoFile
ScriptCB_DoFile = function(...)
    print("ScriptCB_DoFile: " .. arg[1])
    if(arg[1] == "ifs_mp_lobby") then
        print("info: Doing 'ifs_mp_lobby' replacement")
        ReplaceMpLobby()
    else
        return mp_replace_ScriptCB_DoFile(unpack(arg))
    end
end

------------------------------------------------------------------
-- uop recovered source
-- by Anakain
------------------------------------------------------------------
-- uop source: https://github.com/Gametoast/un-official-patch/blob/main/CustomLVL/R130/ifs_mp_lobby.lua


function ReplaceMpLobby()

--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

lobby_marked = nil
local r0 = "teamtracksselected"
local r1 = "enemiestrackselected"
local r2 = "untrackselected"
local r3 = "singletomarked"
local r4 = "markplayer"
local r5 = "friendstomarked"
local r6 = "enemiestomarked"
local r7 = "friendlyaifollow"
local r8 = "enemyaifollow"
local r9 = "selectedboot"

-- Multiplayer lobby

gVoiceIconSpeaker = gXLFriendsEnum2UVs[7]
gVoiceIconTalking = gXLFriendsEnum2UVs[10]
gVoiceIconMuted = gXLFriendsEnum2UVs[8]
gVoiceIconTV = gXLFriendsEnum2UVs[9]

--
-- voice status icons
gVoiceStatus = {
    send = {
        {alpha = 1.0, UVs = gVoiceIconMuted, flash = nil}, -- send disabled
        {alpha = 0.8, UVs = gVoiceIconSpeaker, flash = 1}, -- send disabled, remote receive enabled
        {alpha = 0.4, UVs = gVoiceIconSpeaker, flash = nil}, -- send enabled
        {alpha = 1.0, UVs = gVoiceIconSpeaker, flash = nil}, -- send possible
        {alpha = 1.0, UVs = gVoiceIconTalking, flash = nil}, -- sending
        {alpha = 1.0, UVs = gVoiceIconTV, flash = nil} -- send possible / sending to TV
    },
    receive = {
        {alpha = 1.0, UVs = gVoiceIconMuted, flash = nil}, -- receive disabled
        {alpha = 0.8, UVs = gVoiceIconSpeaker, flash = 1}, -- receive disabled, remote send enabled
        {alpha = 0.4, UVs = gVoiceIconSpeaker, flash = nil}, -- receive enabled
        {alpha = 1.0, UVs = gVoiceIconSpeaker, flash = nil}, -- receive possible
        {alpha = 1.0, UVs = gVoiceIconTalking, flash = nil}, -- receiving
        {alpha = 1.0, UVs = gVoiceIconTV, flash = nil} -- receive possible / receiving to TV
    }
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_mp_lobby_Listbox_CreateItem(layout)
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp = NewIFContainer {x = layout.x - 0.5 * layout.width, y = layout.y}

    -- SM 8-Feb-05 all column widths are now relative to the width of the list box
    local BorderWidth = 10 -- should be subtracted from the first and
    -- last column widths
    local NameWidth = layout.width * 0.5
    local TeamWidth = layout.width * 0.2
    local KillsWidth = layout.width * 0.1
    local PingWidth = layout.width * 0.11
    local QOSWidth = layout.width * 0.2
    local XLiveStatusWidth = layout.width * 0.05
    local VoiceWidth = layout.width * 0.05
    local VoiceSendWidth = layout.width * 0.13
    local VoiceReceiveWidth = layout.width * 0.12

    local y_offset = 4

    -- SM 8-Feb-05 not sure what this has to do with idiot mode
    -- (bars instead of numbers for ping)
    -- if a column doesn't need to be displayed then just set its width to 0
    -- and it will not be created
    -- futhermore, I disabled the ability to toggle idiot mode on and off
    -- it requires a significant amount of real estate to display the
    -- "connection" header for the QOS field
    if (not ifs_mp_lobby.bIdiotMode) then
        QOSWidth = 0
    else
        PingWidth = 0
    end

    if (gPlatformStr ~= "PC") then
        KillsWidth = 0
    end

    -- Removed voice columns NM 9/19/05, per bug 13422
    if ((gOnlineServiceStr == "XLive") or (gPlatformStr == "PC")) then
        VoiceSendWidth = 0
        VoiceReceiveWidth = 0
        VoiceWidth = VoiceWidth + BorderWidth
    else
        XLiveStatusWidth = 0
        VoiceWidth = 0
        VoiceReceiveWidth = VoiceReceiveWidth + BorderWidth
    end

    -- SM 7-Feb-05 I decided to right align all fields with the exception
    -- of the name field
    local NamePos = BorderWidth
    local VoiceReceivePos = layout.width - VoiceReceiveWidth
    local VoiceSendPos = VoiceReceivePos - VoiceSendWidth
    local VoicePos = VoiceSendPos - VoiceWidth -- XLive voice status icon
    local PingPos = VoicePos - PingWidth
    local QOSPos = VoicePos - QOSWidth -- XLive ping / quality of service icon
    local XLiveStatusPos = QOSPos - XLiveStatusWidth
    local KillsPos = math.min(PingPos, QOSPos) - KillsWidth
    local TeamPos = KillsPos - TeamWidth

    -- clamp name width to the actually displayed value
    NameWidth = TeamPos - NamePos

    local QOSHeight = 0.8 * layout.height -- height of ping bar
    local IconSize = 0.9 * layout.height -- size of each icon in lobby_icons.tga

    local fontLocal
    -- SM 8-Feb-05 only use big font when idiot mode is disabled or
    -- on PS2 where the resolution is poopy
    if (layout.bTitles and ((gPlatformStr == "XBox") or (gPlatformStr == "PS2"))) then
        fontLocal = "gamefont_tiny" -- big(ish) font for column headers
    else
        fontLocal = "gamefont_tiny" -- smaller font for contents
    end

    if (NameWidth > 0) then
        Temp.namefield =
            NewIFText {
            x = NamePos,
            y = -10 + y_offset,
            textw = NameWidth,
            halign = "left",
            font = fontLocal,
            nocreatebackground = 1,
            inert_all = 1
        }
    end

    if (TeamWidth > 0) then
        Temp.teamfield =
            NewIFText {
            x = TeamPos,
            y = -10 + y_offset,
            textw = TeamWidth,
            halign = "left",
            font = fontLocal,
            nocreatebackground = 1,
            inert_all = 1
        }
    end

    if (KillsWidth > 0) then
        Temp.killsfield =
            NewIFText {
            x = KillsPos,
            y = -10 + y_offset,
            textw = KillsWidth,
            halign = "left",
            font = fontLocal,
            nocreatebackground = 1,
            inert_all = 1
        }
    end

    if (PingWidth > 0) then
        Temp.pingfield =
            NewIFText {
            x = PingPos,
            y = -10 + y_offset,
            textw = PingWidth,
            halign = "left",
            font = fontLocal,
            nocreatebackground = 1,
            inert_all = 1
        }
    end

    -- if the titles of the list box are being created
    if (layout.bTitles) then
        if (QOSWidth > 0) then
            -- XLive requires ping / quality of service to be displayed as a status bar
            Temp.qosfield =
                NewIFText {
                x = QOSPos,
                y = -10 + y_offset,
                textw = QOSWidth,
                halign = "left",
                font = fontLocal,
                nocreatebackground = 1,
                inert_all = 1
            }
        end

        -- seperate send / receive status
        if (VoiceSendWidth > 0) then
            Temp.voiceSendField =
                NewIFText {
                x = VoiceSendPos,
                y = -10 + y_offset,
                textw = VoiceWidth,
                halign = "left",
                font = fontLocal,
                nocreatebackground = 1,
                inert_all = 1
            }
        end

        if (VoiceReceiveWidth > 0) then
            Temp.voiceReceiveField =
                NewIFText {
                x = VoiceReceivePos,
                y = -10 + y_offset,
                textw = 120,
                halign = "left",
                font = fontLocal,
                nocreatebackground = 1,
                inert_all = 1
            }
        end
    else
        if (QOSWidth > 0) then
            -- XLive requires ping / quality of service to be displayed as a
            -- status bar
            Temp.qosfield =
                NewIFImage {
                x = QOSPos,
                y = 6 + y_offset, -- y-pos is to get it centered in bar
                texture = "ping_icon",
                localpos_l = 0,
                localpos_t = -13,
                localpos_b = QOSHeight - 10 - 7,
                localpos_r = 40
            }
        end

        local VoiceIconYOffset = 14

        -- XLive friend state
        if (XLiveStatusWidth > 0) then
            Temp.StateIcon =
                NewIFImage {
                x = XLiveStatusPos,
                y = 3 + y_offset, -- y-pos is to get it centered in bar
                texture = "lobby_icons",
                localpos_l = 0,
                localpos_t = -VoiceIconYOffset,
                localpos_b = IconSize - VoiceIconYOffset,
                localpos_r = IconSize,
                bInertPos = 1,
                inert_all = 1
            }
        end

        if (VoiceWidth > 0) then
            -- XLive requires certain icons for voice status which means the
            -- muted (send + receive enabled) status is hidden to other players
            -- the local player only knows who is locally muted
            Temp.VoiceIcon =
                NewIFImage {
                x = VoicePos,
                y = 3 + y_offset, -- y-pos is to get it centered in bar
                texture = "lobby_icons",
                localpos_l = 0,
                localpos_t = -VoiceIconYOffset,
                localpos_b = IconSize - VoiceIconYOffset,
                localpos_r = IconSize,
                bInertPos = 1,
                inert_all = 1
            }
        end

        if (VoiceSendWidth > 0) then
            -- seperate send / receive status
            Temp.voiceSendField =
                NewIFImage {
                x = VoiceSendPos,
                y = 3 + y_offset, -- y-pos is to get it centered in bar
                texture = "lobby_icons",
                localpos_l = 0,
                localpos_t = -VoiceIconYOffset,
                localpos_b = IconSize - VoiceIconYOffset,
                localpos_r = IconSize,
                bInertPos = 1,
                inert_all = 1
            }
        end

        if (VoiceReceiveWidth > 0) then
            Temp.voiceReceiveField =
                NewIFImage {
                x = VoiceReceivePos,
                y = 3 + y_offset, -- y-pos is to get it centered in bar
                texture = "lobby_icons",
                localpos_l = 0,
                localpos_t = -VoiceIconYOffset,
                localpos_b = IconSize - VoiceIconYOffset,
                localpos_r = IconSize,
                bInertPos = 1,
                inert_all = 1
            }
        end
    end

    return Temp
end

-- display a voice icon
function ifs_mp_lobby_Listbox_DisplayVoiceIcon(field, iconInfo, flashAlpha)
    local UVs
    local alpha

    UVs = iconInfo.UVs
    alpha = iconInfo.alpha

    if (iconInfo.flash) then
        alpha = alpha * flashAlpha
    end

    IFImage_fnSetUVs(field, UVs.u, UVs.v, UVs.u + 0.25, UVs.v + 0.25)
    IFObj_fnSetAlpha(field, alpha)
    IFObj_fnSetVis(field, 1)
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_mp_lobby_Listbox_PopulateItem(Dest, Data, bSelected, ColorR, ColorG, ColorB, fAlpha)
    -- If we need to zap the glyphcache, do so.
    if (gBlankListbox) then
        if (Dest.namefield) then
            IFText_fnSetString(Dest.namefield, "")
        end

        if (Dest.teamfield) then
            IFText_fnSetString(Dest.teamfield, "")
        end

        if (Dest.pingfield) then
            IFText_fnSetString(Dest.pingfield, "")
        end

        if (Dest.killsfield) then
            IFText_fnSetString(Dest.killsfield, " ")
        end
    elseif (Data) then
        -- Have data, time to draw. Do so.

        if (Dest.namefield) then
            IFObj_fnSetColor(Dest.namefield, ColorR, ColorG, ColorB)
            IFObj_fnSetAlpha(Dest.namefield, fAlpha)
        end
        if (Dest.teamfield) then
            IFObj_fnSetColor(Dest.teamfield, ColorR, ColorG, ColorB)
            IFObj_fnSetAlpha(Dest.teamfield, fAlpha)
        end
        if (Dest.pingfield) then
            IFObj_fnSetColor(Dest.pingfield, ColorR, ColorG, ColorB)
            IFObj_fnSetAlpha(Dest.pingfield, fAlpha)
        end
        if (Dest.killsfield) then
            IFObj_fnSetColor(Dest.killsfield, ColorR, ColorG, ColorB)
            IFObj_fnSetAlpha(Dest.killsfield, fAlpha)
        end

        -- name
        if (Dest.namefield) then
            IFText_fnSetString(Dest.namefield, Data.namestr)
        --IFText_fnSetString(Dest.namefield,"WWWWWWWWWWWWWWM") -- space test
        end

        -- team
        if (Dest.teamfield) then
            if (Data.iTeam < 0.5) then
                IFText_fnSetUString(Dest.teamfield, ScriptCB_GetTeamName(1))
            else
                IFText_fnSetUString(Dest.teamfield, ScriptCB_GetTeamName(2))
            end
            if (Data.ColorR) then
                IFObj_fnSetColor(Dest.teamfield, Data.ColorR, Data.ColorG, Data.ColorB)
            end
        end

        -- ping / quality of service
        if (Dest.qosfield) then
            local U1 = (5 - Data.iQOS) * 0.2
            IFImage_fnSetUVs(Dest.qosfield, U1, 0.0, U1 + 0.2, 1.0)
        elseif (Dest.pingfield) then
            IFText_fnSetString(Dest.pingfield, Data.pingstr)
        end

        if (Dest.killsfield) then
            IFText_fnSetString(Dest.killsfield, Data.killsstr)
        end

        -- update XLive friend state icon
        if (Data.StateIcon) then
            local UVs = gXLFriendsEnum2UVs[Data.StateIcon + 1] -- lua counts from 1
            IFImage_fnSetUVs(Dest.StateIcon, UVs.u, UVs.v, UVs.u + 0.25, UVs.v + 0.25)
        end
        if (Dest.StateIcon) then
            IFObj_fnSetVis(Dest.StateIcon, Data.StateIcon)
        end

        -- update XLive voice icon
        if (Data.VoiceIcon) then
            local UVs = gXLFriendsEnum2UVs[Data.VoiceIcon + 1] -- lua counts from 1
            IFImage_fnSetUVs(Dest.VoiceIcon, UVs.u, UVs.v, UVs.u + 0.25, UVs.v + 0.25)
            IFObj_fnSetAlpha(Dest.VoiceIcon, Data.VoiceIconAlpha)
        end
        if (Dest.VoiceIcon) then
            IFObj_fnSetVis(Dest.VoiceIcon, Data.VoiceIcon)
        end

        -- voice send / receive states
        if (Dest.voiceSendField and Dest.voiceReceiveField) then
            local sendStatus = ScriptCB_GetVoiceSendStatus(Data.indexstr)
            local receiveStatus = ScriptCB_GetVoiceReceiveStatus(Data.indexstr)
            local iconInfo
            local flashAlpha =
                ((math.min(ifs_mp_lobby.flashNextTime - ifs_mp_lobby.flashTimeElapsed, 1.0)) /
                ifs_mp_lobby.flashInterval)

            -- flash on or off as the update rate is really slow
            if (flashAlpha > 0.5) then
                flashAlpha = 1.0
            else
                flashAlpha = 0
            end

            if (sendStatus > 0) then
                ifs_mp_lobby_Listbox_DisplayVoiceIcon(Dest.voiceSendField, gVoiceStatus.send[sendStatus], flashAlpha)
            else
                IFObj_fnSetVis(Dest.voiceSendField, nil)
            end

            if (receiveStatus > 0) then
                ifs_mp_lobby_Listbox_DisplayVoiceIcon(
                    Dest.voiceReceiveField,
                    gVoiceStatus.receive[receiveStatus],
                    flashAlpha
                )
            else
                IFObj_fnSetVis(Dest.voiceReceiveField, nil)
            end
        end
    end -- Data exists

    -- Show entry if Data != nil
    IFObj_fnSetVis(Dest, Data)
end

lobby_listbox_layout = {
    showcount = 10,
    --  yTop       = -130 + 13,  -- auto-calc'd now
    yHeight = 26,
    ySpacing = 0,
    width = 430,
    x = 0,
    slider = 1,
    CreateFn = ifs_mp_lobby_Listbox_CreateItem,
    PopulateFn = ifs_mp_lobby_Listbox_PopulateItem
}

ifs_mp_lobby_listbox_contents = {}

-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mplobby_leavepopup_fnCheckDone()
    --  local this = ifs_sessionlist_joinpopup
    ScriptCB_UpdateLeave() -- think...

    return ScriptCB_IsLeaveDone()
end

function ifs_mplobby_leavepopup_fnOnSuccess()
    local this = ifs_mp_lobby
    Popup_Busy:fnActivate(nil)
    ifs_mp_lobby_fnShowHideItems(this, 1)
    ScriptCB_PopScreen("ifs_mp_main")
end

function ifs_mplobby_leavepopup_fnOnFail()
    -- This shouldn't happen, but go back in any case
    local this = ifs_mp_lobby
    Popup_Busy:fnActivate(nil)
    ifs_mp_lobby_fnShowHideItems(this, 1)
    ScriptCB_PopScreen("ifs_mp_main")
end

function ifs_mplobby_leavepopup_fnOnCancel()
    -- Shouldn't happen!
    ifs_mp_lobby_fnShowHideItems(this, 1)
end

-- Callback after the "really leave session?" popup is done.
-- If bResult is true, then the user hit yes, else no.
function ifs_mp_lobby_fnLeavePopupDone(bResult)
    local this = ifs_mp_lobby

    if (bResult) then
        -- User does want to leave. Start the process.
        ScriptCB_BeginLeave()

        -- And show the popup.
        Popup_Busy.fnCheckDone = ifs_mplobby_leavepopup_fnCheckDone
        Popup_Busy.fnOnSuccess = ifs_mplobby_leavepopup_fnOnSuccess
        Popup_Busy.fnOnFail = ifs_mplobby_leavepopup_fnOnFail
        Popup_Busy.fnOnCancel = ifs_mplobby_leavepopup_fnOnCancel
        Popup_Busy.bNoCancel = 1 -- no cancel button
        Popup_Busy.fTimeout = 5 -- seconds
        IFText_fnSetString(Popup_Busy.title, "common.mp.leaving")
        Popup_Busy:fnActivate(1)
    else
        ifs_mp_lobby_fnShowHideItems(this, 1)
    end
end

-- callback when the lobby options popup is done
function ifs_mp_lobby_fnLobbyOptionsPopupDone()
    local this = ifs_mp_lobby

    -- force a reget of the listbox to update any changes
    ifs_mp_lobby_SetHilight(this, lobby_listbox_layout.SelectedIdx)
end

-- Helper function: turns pieces on/off as requested
function ifs_mp_lobby_fnShowHideItems(this, bNormalVis)
    IFObj_fnSetVis(this.listbox, bNormalVis)
    IFObj_fnSetVis(this.columnheaders, bNormalVis)
    --  IFObj_fnSetVis(this.buttons,bNormalVis and this.bShellActive)
end

-- Sets the hilight on the listbox, create button given a hilight
function ifs_mp_lobby_SetHilight(this, aListIndex)
    lobby_listbox_layout.SelectedIdx = aListIndex
    if (gPlatformStr ~= "PC") then
        lobby_listbox_layout.CursorIdx = aListIndex
    end
    ListManager_fnFillContents(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
end

-- this recalculates the boot flag and the vote button visibility
function ifs_mp_lobby_DoTestCanBoot(selected_idx, force_boot)
    local this = ifs_mp_lobby

    if (not force_boot) then
        -- default to visible
        local BootVisible = 1

        if (selected_idx) then
            -- the currently selected player
            local Selection = ifs_mp_lobby_listbox_contents[selected_idx]
            if (not Selection) then
                return nil
            end
            local bIsMe = Selection.bIsLocal

            local muted, friend, bCanBoot, bIsGuest, bCanAddFriend =
                ScriptCB_GetLobbyPlayerFlags(Selection.namestr, Selection.indexstr)

            --print( "++++1++++bIsMe = ", bIsMe, " bCanBoot = ", bCanBoot, " BootVisible = ", BootVisible, " Selection.indexstr =", Selection.indexstr )

            if (ScriptCB_GetAmHost()) then
                -- don't let host "vote to boot" as he has the option to force boot
                BootVisible = nil --   bugs # 14579, 145780
            else
                -- Not host. Set client options
                BootVisible = not ScriptCB_IsInShell()

                if (bIsMe) then
                    BootVisible = nil -- can't kick self
                end

                -- won't boot if players are different team
                local NumEntries = table.getn(ifs_mp_lobby_listbox_contents)
                local bIsSameTeam = nil
                for i = 1, NumEntries do
                    if
                        (ifs_mp_lobby_listbox_contents[i].bIsLocal and
                            Selection.iTeam == ifs_mp_lobby_listbox_contents[i].iTeam)
                     then
                        bIsSameTeam = nil --1
                    end
                end
                if (not bIsSameTeam) then
                    BootVisible = 1 -- nil
                end
            end

            --print( "++++2++++BootVisible = ", BootVisible )
            -- global can you boot this person?
            if (not bCanBoot) then
                BootVisible = 1 -- nil
            end
        else
            -- nobody home, hidden
            BootVisible = 1 -- nil
        end

        --print( "++++3++++BootVisible = ", BootVisible )

        return BootVisible
    else
        -- default to invisible
        local ForceBootVisible = 1 -- nil

        if (lobby_listbox_layout.SelectedIdx) then
            -- the currently selected player
            local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
            if (not Selection) then
                ForceBootVisible = 1 -- nil
            else
                local bIsMe = Selection.bIsLocal
                if (ScriptCB_GetAmHost()) then
                    ForceBootVisible = not bIsMe -- can't kick self
                else
                    ForceBootVisible = 1 -- nil
                end
            end
        else
            -- nobody home, hidden
            ForceBootVisible = 1 -- nil
        end
        return ForceBootVisible
    end
end

-- this recalculates the boot flag and the vote button visibility
function ifs_mp_lobby_CalcCanBoot()
    local this = ifs_mp_lobby

    this.BootVisible = ifs_mp_lobby_DoTestCanBoot(lobby_listbox_layout.SelectedIdx, nil)

    -- show/hide the boot button
    IFObj_fnSetVis(this.Helptext_Misc, this.BootVisible)
end

-- this recalculates the boot flag and the vote button visibility
function ifs_mp_lobby_CalcCanForceBoot()
    local this = ifs_mp_lobby

    this.ForceBootVisible = ifs_mp_lobby_DoTestCanBoot(lobby_listbox_layout.SelectedIdx, true)

    -- show/hide the boot button
    IFObj_fnSetVis(this.Helptext_ForceBoot, this.ForceBootVisible)
    if (this.ForceBootVisible) then
        if (this.Helptext_ForceBoot.helpstr) then
            IFText_fnSetString(this.Helptext_ForceBoot.helpstr, "ifs.onlinelobby.forceboot")
        end
    end
    ifs_mp_lobby_fnShowExtraButtons(1, 1)
end

-- bringup vote to boot popup
function ifs_mp_lobby_DoPopupVootBoot(force_boot)
    local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
    if (not Selection) then
        return
    end
    Popup_Vote.CurButton = "no" -- default
    Popup_Vote.SelectedIdx = lobby_listbox_layout.SelectedIdx
    Popup_Vote.force_boot = force_boot
    Popup_Vote:fnActivate(1)
end

function ifs_mp_lobby_IsBandwidthVisible(this)
    return nil
    --return this.bCanAdjustBW and ScriptCB_GetAmHost() and (gOnlineServiceStr ~= "LAN")
end

function ifs_mp_lobby_UpdateBandwidth(this, value)
    IFText_fnSetUString(
        this.Bandwidth,
        ScriptCB_usprintf("ifs.mp.bandwidth", ScriptCB_tounicode(string.format("%d", value)))
    )
end

ifs_mp_lobby =
    NewIFShellScreen {
    nologo = 1,
    bDimBackdrop = 1,
    bg_texture = "", -- nothing for now
    flashTimeElapsed = 0.0,
    flashNextTime = 0.0,
    flashInterval = 1.0,
    bIdiotMode = nil,
    launchflag = nil,
    title = NewIFText {
        -- string = "common.mp.lobby",
        font = "gamefont_small",
        y = 0,
        textw = 460, -- center on screen. Fixme: do real centering!
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0, -- top
        nocreatebackground = 1
    },
    -- Vote helptext

    -- point of interested
    IPAddr = NewIFText {
        -- string = "ifs.mp.connection.title",
        font = "gamefont_small",
        textw = 460,
        halign = "right",
        ScreenRelativeX = 1.0, -- right
        ScreenRelativeY = 1.0, -- near bottom
        y = -90,
        x = -460,
        nocreatebackground = 1
    },
    ServerName = NewIFText {
        -- string = "ifs.mp.connection.title",
        font = "gamefont_small",
        textw = 460,
        halign = "left",
        ScreenRelativeX = 0, -- left
        ScreenRelativeY = 1.0, -- near bottom
        y = -90,
        x = 25,
        nocreatebackground = 1
    },
    Bandwidth = NewIFText {
        font = "gamefont_small",
        textw = 460,
        halign = "left",
        ScreenRelativeX = 0, -- left
        ScreenRelativeY = 1.0, -- near bottom
        y = -60,
        x = 25
        --         nocreatebackground = 1,
    },
    Enter = function(this, bFwd)
        -- Always call base class
        gIFShellScreenTemplate_fnEnter(this, bFwd)

        -- gHelptext_fnMoveIcon(this.Helptext_Misc2)

        -- Added chunk for error handling...
        if (not bFwd) then
            local ErrorLevel, ErrorMessage = ScriptCB_GetError()
            if (ErrorLevel >= 6) then -- session or login error, must keep going further
                ScriptCB_PopScreen()
            end
        end

        this.bCanAdjustBW = not gFinalBuild

        this.bShellActive = ScriptCB_GetShellActive()
        if (this.Helptext_Accept) then
            IFText_fnSetString(this.Helptext_Accept.helpstr, "ifs.onlinelobby.playeropts")
            gHelptext_fnMoveIcon(this.Helptext_Accept)
        end

        if (gPlatformStr == "XBox") then
            IFText_fnSetString(this.title, "game.pause.playerlist")
        else
            this.bAmHost = ScriptCB_GetAmHost()
            if (this.bAmHost) then
                IFText_fnSetString(this.title, "ifs.mplobby.host_title")
            else
                IFText_fnSetString(this.title, "ifs.mplobby.client_title")
            end
        end

        -- Reset listbox, show it. [Remember, Lua starts at 1!]
        lobby_listbox_layout.FirstShownIdx = 1
        lobby_listbox_layout.SelectedIdx = 1
        lobby_listbox_layout.CursorIdx = 1
        if (bFwd) then
            ScriptCB_BeginLobby()
        else
            -- force an update, NOW. (we zapped everything leaving this screen, gotta
            -- restore it on re-entry)
            ScriptCB_UpdateLobby(1)
        end

        if __TempProcessPlayersFunction__ then
            local uop_fnProcessPlayer = __TempProcessPlayersFunction__
            __TempProcessPlayersFunction__ = nil

            uop_fnProcessPlayer(ifs_mp_lobby_listbox_contents)
            ScriptCB_PopScreen()
            return
        end

        ListManager_fnFillContents(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)

        ifs_mp_lobby_SetHilight(this, 1)
        ifs_mp_lobby_fnShowHideItems(this, 1)

        IFText_fnSetString(this.IPAddr, "IP: " .. ScriptCB_GetIPAddr())
        IFText_fnSetString(this.ServerName, ScriptCB_GetGameName())

        -- result: show local IP in the lower-right section below list of players
        --		IFObj_fnSetVis(this.IPAddr, (gOnlineServiceStr ~= "XLive") and (not ifs_mp_lobby.bE3Mode) and (not gFinalBuild))

        -- Show server name all the time, request from Brad - NM 8/24/05
        IFObj_fnSetVis(this.ServerName, 1) -- (gOnlineServiceStr ~= "XLive") and (not ifs_mp_lobby.bE3Mode) and (not gFinalBuild))
        -- IFObj_fnSetVis(this.Helptext_Misc2,not ifs_mp_lobby.bE3Mode)

        if (ifs_mp_lobby_IsBandwidthVisible(this)) then
            IFObj_fnSetVis(this.Bandwidth, 1)
            ifs_mp_lobby_UpdateBandwidth(this, ScriptCB_GetBandwidth())
        else
            --return -- result is a weird gray square icon appears nearby the server name
            --IFObj_fnSetVis(this.Bandwidth, 1)	-- result is that is always says 100% bandwhith below server name
            --ifs_mp_lobby_UpdateBandwidth( this, ScriptCB_GetBandwidth() )
            IFObj_fnSetVis(this.Bandwidth, nil)
        end

        if ((this.bAutoLaunch) or (this.bHideOnEntry)) then
            -- Hide everything ASAP
            IFObj_fnSetVis(this.title, nil)
            -- IFObj_fnSetVis(this.Helptext_Misc2,nil)
            if (this.Helptext_Accept) then
                IFObj_fnSetVis(this.Helptext_Accept, nil)
            end
            if (this.Helptext_Back) then
                IFObj_fnSetVis(this.Helptext_Back, nil)
            end
            IFObj_fnSetVis(this.IPAddr, nil)
            IFObj_fnSetVis(this.ServerName, nil)
            IFObj_fnSetVis(this.listbox, nil)
            IFObj_fnSetVis(this.columnheaders, nil)

            this.bHideOnEntry = nil -- clear flag
        end

        -- set the visibility of the boot button
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()
    end,
    Exit = function(this, bFwd)
        if (bFwd) then -- going to string.sub-screen
        else
            ScriptCB_CancelLobby() -- going back to create opts (host) or sessionlist (client)
        end

        -- Clear out glyph cache
        gBlankListbox = 1
        if (ifs_mp_lobby_listbox_contents) then
            ListManager_fnFillContents(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
        gBlankListbox = nil
        ifs_mp_lobby_listbox_contents = {} -- clear this from memory also.
    end,
    Input_Accept = function(this)
        if (gShellScreen_fnDefaultInputAccept(this)) then
            local bExitNow = 1

            if (gMouseListBox) then
                if (gMouseListBox.Layout.SelectedIdx == gMouseListBox.Layout.CursorIdx) then
                    if (this.fDoubleClickTimer < 0.01) then
                        this.fDoubleClickTimer = 0.4
                    else
                        bExitNow = nil
                    end -- timer
                else
                    -- Selected index changed.
                    gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
                end
            end -- gMouseListBox is valid

            --			print("mp_lobby. Default accept handled, returning.")
            ifs_mp_lobby_CalcCanBoot()
            ifs_mp_lobby_CalcCanForceBoot()
            if (bExitNow) then
                return
            end
        end

        if (this.CurButton == "voteboot") then
            -- make sure this is updated
            ifs_mp_lobby_CalcCanBoot()
            --			ifs_mp_lobby_CalcCanForceBoot()

            if (nil) then
                local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if (this.BootVisible and Selection) then
                    ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, "boot")
                end
            else
                if (this.BootVisible) then
                    ifs_mp_lobby_DoPopupVootBoot(nil)
                end
            end

            -- hide the button, since we just voted
            ifs_mp_lobby_CalcCanBoot()
        elseif (this.CurButton == "forceboot") then
            -- make sure this is updated
            ifs_mp_lobby_CalcCanForceBoot()

            if (nil) then
                local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if (this.ForceBootVisible and Selection) then
                    ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, "forceboot")
                end
            else
                if (this.ForceBootVisible) then
                    ifs_mp_lobby_DoPopupVootBoot(1)
                end
            end

            -- hide the button, since we just voted
            ifs_mp_lobby_CalcCanForceBoot()
        else -- SM 7-Feb-05 -- if (gPlatformStr ~= "PC") then
            --lbl 98
            if (this.CurButton == r0) then --else 140
                local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if (not Selection) then
                    return
                end

                local team = 0 --r2
                if Selection.iTeam < 0.5 then
                    team = 1
                else
                    team = 2
                end

                local characterIndex = Selection.indexstr
                unit = GetCharacterUnit(characterIndex)

                if unit == nil then
                    return
                end
                --lbl 125

                -- friend
                MapAddEntityMarker(unit, "hud_objective_icon", 3.0, team, "BLUE", true, true, true, true)
                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r1) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                local team = 0
                if data.iTeam < 0.5 then
                    team = 2
                else
                    team = 1
                end

                local characterIndex = data.indexstr
                unit = GetCharacterUnit(characterIndex)

                if unit == nil then
                    return
                end

                -- enemy
                MapAddEntityMarker(unit, "hud_objective_icon", 3.0, team, "RED", true, true, true, true)
                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r2) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                local characterIndex = data.indexstr
                unit = GetCharacterUnit(characterIndex)

                if unit == nil then
                    return
                end

                MapRemoveEntityMarker(unit)
                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r3) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                local characterIndex = data.indexstr
                local unit = GetCharacterUnit(characterIndex)

                if unit == nil then
                    return
                end

                if lobby_marked == nil then
                    return
                end

                local markedUnit = GetCharacterUnit(lobby_marked)
                if markedUnit == nil then
                    return
                end

                local mat = GetEntityMatrix(markedUnit)
                SetEntityMatrix(unit, mat)

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r4) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                lobby_marked = data.indexstr

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r5) then
                if lobby_marked == nil then
                    return
                end

                local markedUnit = GetCharacterUnit(lobby_marked) --r1
                local markedTeam = GetCharacterTeam(lobby_marked) --r2
                local teamSize = GetTeamSize(markedTeam) --r3

                local i = 0 --r4
                for i = 0, teamSize - 1, 1 do
                    local member = GetTeamMember(markedTeam, i)

                    if not (member == nil) then
                        local unit = GetCharacterUnit(member)

                        if not (unit == nil) then
                            local mat = GetEntityMatrix(markedUnit)
                            SetEntityMatrix(unit, mat)
                        end
                    end
                end

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r6) then
                if lobby_marked == nil then
                    return
                end

                local markedUnit = GetCharacterUnit(lobby_marked) --r1
                local markedTeam = GetCharacterTeam(lobby_marked) --r2

                if markedTeam == 1 then
                    markedTeam = 2
                elseif markedTeam == 2 then
                    markedTeam = 1
                else
                    ShowMessageText("mods.freecam.unknownenemy")
                    return
                end

                local teamSize = GetTeamSize(markedTeam) --r3

                local i = 0 --r4
                for i = 0, teamSize - 1, 1 do
                    local member = GetTeamMember(markedTeam, i)

                    if not (member == nil) then
                        local unit = GetCharacterUnit(member)

                        if not (unit == nil) then
                            local mat = GetEntityMatrix(markedUnit)
                            SetEntityMatrix(unit, mat)
                        end
                    end
                end

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r7) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                local team = GetCharacterTeam(data.indexstr)

                AddAIGoal(team, "follow", 100, data.indexstr)

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r8) then
                local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                if not data then
                    return
                end

                local team = GetCharacterTeam(data.indexstr)

                if team == 1 then
                    team = 2
                elseif team == 2 then
                    team = 1
                else
                    ShowMessageText("mods.freecam.unknownenemy")
                    return
                end

                --lbl 419

                AddAIGoal(team, "follow", 100, data.indexstr)

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            elseif (this.CurButton == r9) then
                ScriptCB_VoteKick("")

                ifelm_shellscreen_fnPlaySound(this.acceptSound)
            else
                if (lobby_listbox_layout.SelectedIdx) then
                    local data = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                    if not data then
                        return
                    end

                    IFText_fnSetString(Popup_LobbyOpts.title, data.namestr)
                    Popup_LobbyOpts.bIsMe = data.bIsLocal and (data.iViewport == ScriptCB_GetPausingViewport())
                    --                              print("bIsMe = ", Popup_LobbyOpts.bIsMe, " from ", Selection.bIsLocal, Selection.iViewport ,ScriptCB_GetPausingViewport())

                    local NumEntries = table.getn(ifs_mp_lobby_listbox_contents)
                    Popup_LobbyOpts.bIsSameTeam = nil
                    for i = 1, NumEntries do
                        --print("+++i=", i, Selection.iTeam, ifs_mp_lobby_listbox_contents[i].bIsLocal, ifs_mp_lobby_listbox_contents[i].namestr, ifs_mp_lobby_listbox_contents[i].iTeam )
                        if (ifs_mp_lobby_listbox_contents[i].bIsLocal) then
                            if (data.iTeam == ifs_mp_lobby_listbox_contents[i].iTeam) then
                                --print("+++x=", i, Selection.iTeam, ifs_mp_lobby_listbox_contents[i].bIsLocal, ifs_mp_lobby_listbox_contents[i].namestr, ifs_mp_lobby_listbox_contents[i].iTeam )
                                Popup_LobbyOpts.bIsSameTeam = 1
                            end
                        end
                    end

                    ifelm_shellscreen_fnPlaySound(this.acceptSound)

                    -- Get their muted, friend flags.
                    -- also get the boot flag. says if we could boot this player if we wanted to.
                    -- this is not absolute, there are other conditions that could hide the "boot"
                    -- option. all this tells us is that someone else isn't currently nominated
                    -- for a boot
                    Popup_LobbyOpts.bIsMuted,
                        Popup_LobbyOpts.bIsFriend,
                        Popup_LobbyOpts.bCanBoot,
                        Popup_LobbyOpts.bIsGuest,
                        Popup_LobbyOpts.bCanAddFriend = ScriptCB_GetLobbyPlayerFlags(data.namestr, data.indexstr)

                    Popup_LobbyOpts.bOnlyForPlayer = 1
                    Popup_LobbyOpts.fnDone = ifs_mp_lobby_fnLobbyOptionsPopupDone
                    Popup_LobbyOpts.playerIndex = data.indexstr
                    Popup_LobbyOpts:fnActivate(1)
                end -- selectedidx is valid
            end -- (SM 7-Feb-05 NOT) not PC
        end
    end,
    Input_Back = function(this)
        if (this.bShellActive) then
            ifelm_shellscreen_fnPlaySound(this.exitSound)
            -- Shell is active. Must prompt before backing out of screen
            ifs_mp_lobby_fnShowHideItems(this, nil)

            Popup_YesNo.CurButton = "no" -- default
            Popup_YesNo.fnDone = ifs_mp_lobby_fnLeavePopupDone
            Popup_YesNo:fnActivate(1)
            if (this.bAmHost) then
                gPopup_fnSetTitleStr(Popup_YesNo, "ifs.onlinelobby.cancelsession")
            else
                gPopup_fnSetTitleStr(Popup_YesNo, "ifs.onlinelobby.leavesession")
            end
            ifs_mp_lobby_fnShowHideItems(this, nil)
        else
            -- Game is active. Just back up to pausemenu
            ScriptCB_PopScreen()
        end
    end,
    Input_Misc = function(this)
        if (gPlatformStr ~= "PC") then
            -- make sure this is updated
            ifs_mp_lobby_CalcCanBoot()
            ifs_mp_lobby_CalcCanForceBoot()

            if (this.ForceBootVisible) then
                if (nil) then
                    local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                    if (not Selection) then
                        return
                    end
                    ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, "forceboot")
                else
                    ifs_mp_lobby_DoPopupVootBoot(1)
                end
            elseif (this.BootVisible) then
                if (nil) then
                    local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
                    if (not Selection) then
                        return
                    end
                    ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, "boot")
                else
                    ifs_mp_lobby_DoPopupVootBoot(nil)
                end
            end
        end
    end,
    Input_Start = function(this)
        --      if(lobby_listbox_layout.SelectedIdx ) then
        --          local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
        --          ScriptCB_VoteKick(Selection.namestr )
        --          ifelm_shellscreen_fnPlaySound(this.acceptSound)
        --      end
    end,
    Input_GeneralUp = function(this)
        if (lobby_listbox_layout.SelectedIdx) then
            ListManager_fnNavUp(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()
    end,
    Input_GeneralDown = function(this)
        if (lobby_listbox_layout.SelectedIdx) then
            ListManager_fnNavDown(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()
    end,
    Input_LTrigger = function(this)
        if (lobby_listbox_layout.SelectedIdx) then
            ListManager_fnPageUp(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()
    end,
    Input_RTrigger = function(this)
        if (lobby_listbox_layout.SelectedIdx) then
            ListManager_fnPageDown(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()
    end,
    -- update bandwidth

    Input_GeneralLeft = function(this)
        if (ifs_mp_lobby_IsBandwidthVisible(this)) then
            local new_value = ScriptCB_GetBandwidth() - 10
            if (new_value < 10) then
                new_value = 10
            end
            ifs_mp_lobby_UpdateBandwidth(this, new_value)
            ScriptCB_SetBandwidth(new_value)
        end
        --      ScriptCB_PreviousHost()
    end,
    Input_GeneralRight = function(this)
        if (ifs_mp_lobby_IsBandwidthVisible(this)) then
            local new_value = ScriptCB_GetBandwidth() + 10
            if (new_value > 100) then
                new_value = 100
            end
            ifs_mp_lobby_UpdateBandwidth(this, new_value)
            ScriptCB_SetBandwidth(new_value)
        end
        --      ScriptCB_NextHost()
    end,
    fDoubleClickTimer = 0.0,
    Update = function(this, fDt)
        -- Call default base class's update function (make button bounce)
        gIFShellScreenTemplate_fnUpdate(this, fDt)
        ScriptCB_UpdateLobby(nil)

        this.fDoubleClickTimer = math.max(0, this.fDoubleClickTimer - fDt)

        -- set the visibility of the boot button
        ifs_mp_lobby_CalcCanBoot()
        ifs_mp_lobby_CalcCanForceBoot()

        if (this.bAutoLaunch) then
            --          print("Autolaunching...")
            ScriptCB_LaunchLobby()
        end

        -- bail?
        if (ScriptCB_SkipToPlayerList()) then
            if (ScriptCB_CheckPlayerListDone()) then
                ScriptCB_PopScreen()
                return
            end
        end

        this.flashTimeElapsed = this.flashTimeElapsed + fDt
        if (this.flashTimeElapsed > this.flashNextTime) then
            this.flashNextTime = this.flashNextTime + this.flashInterval
        end
    end,
    -- Callback (from C++) to repaint the listbox with the current contents
    -- in the global ifs_mp_lobby_listbox_contents
    RepaintListbox = function(this)
        -- Sanity check
        if (not ifs_mp_lobby_listbox_contents) then
            return
        end

        local NumEntries = table.getn(ifs_mp_lobby_listbox_contents)
        if (NumEntries < 1) then
            lobby_listbox_layout.SelectedIdx = nil
        else
            if ((not lobby_listbox_layout.SelectedIdx) or (lobby_listbox_layout.SelectedIdx < 1)) then
                lobby_listbox_layout.SelectedIdx = 1
            elseif (lobby_listbox_layout.SelectedIdx > NumEntries) then
                lobby_listbox_layout.SelectedIdx = NumEntries
            end
        end

        --print( "lobby_listbox_layout.CursorIdx = ", lobby_listbox_layout.CursorIdx )
        --print( "lobby_listbox_layout.SelectedIdx = ", lobby_listbox_layout.SelectedIdx )

        if (gPlatformStr ~= "PC") then
            lobby_listbox_layout.CursorIdx = lobby_listbox_layout.SelectedIdx
            ListManager_fnFillContents(this.listbox, ifs_mp_lobby_listbox_contents, lobby_listbox_layout)
        end
    end
}

-- Do programatic work to set up this screen
function ifs_mp_lobby_fnBuildScreen(this)
    local w, h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
    lobby_listbox_layout.width = w - 50 -- enough for sliders, etc

    local HeightPer = lobby_listbox_layout.yHeight + lobby_listbox_layout.ySpacing
    lobby_listbox_layout.showcount = math.floor((h - 180) / HeightPer)

    -- enable idiot mode if XLive is enabled
    ifs_mp_lobby.bIdiotMode = gPlatformStr == "XBox"

    --this.stopitall.now = 1

    this.listbox =
        NewButtonWindow {
        ZPos = 200,
        x = 0,
        y = -20,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0.5, -- middle of screen
        width = lobby_listbox_layout.width + 50,
        height = lobby_listbox_layout.showcount * HeightPer + 30
    }

    ListManager_fnInitList(this.listbox, lobby_listbox_layout)

    -- Make column headers, fill them in
    this.columnheaders =
        ifs_mp_lobby_Listbox_CreateItem {
        bTitles = 1, --
        width = lobby_listbox_layout.width,
        height = lobby_listbox_layout.yHeight,
        x = -10, -- account for scrollbar
        y = 0
    }

    this.columnheaders.ScreenRelativeX = 0.5
    this.columnheaders.ScreenRelativeY = 0.5
    if (gPlatformStr == "XBox" or gPlatformStr == "PS2") then
        this.columnheaders.y = this.listbox.y - (this.listbox.height * 0.45) - 30
    else
        this.columnheaders.y = this.listbox.y - (this.listbox.height * 0.49) - 30
    end

    -- set column header text
    if (this.columnheaders.namefield) then
        IFText_fnSetString(this.columnheaders.namefield, "ifs.MPLobby.name_header")
    end

    if (this.columnheaders.teamfield) then
        IFText_fnSetString(this.columnheaders.teamfield, "ifs.MPLobby.team_header")
    end

    if (this.columnheaders.killsfield) then
        IFText_fnSetString(this.columnheaders.killsfield, "ifs.Stats.kills")
    end

    if (this.columnheaders.pingfield) then
        IFText_fnSetString(this.columnheaders.pingfield, "ifs.MPLobby.ping_header")
    end

    if (this.columnheaders.qosfield) then
        IFText_fnSetString(this.columnheaders.qosfield, "ifs.MPLobby.qos_header")
    end

    if (this.columnheaders.voiceSendField and this.columnheaders.voiceReceiveField) then
        IFText_fnSetString(this.columnheaders.voiceSendField, "ifs.MPLobby.voice.sendheader")
        IFText_fnSetString(this.columnheaders.voiceReceiveField, "ifs.MPLobby.voice.receiveheader")
    end

    if (gPlatformStr ~= "PC") then
        this.Helptext_Misc =
            NewHelptext {
            ScreenRelativeX = 0.0, -- left
            ScreenRelativeY = 1.0, -- bottom
            y = -40, -- second row of items, -40
            buttonicon = "btnmisc",
            string = "ifs.onlinelobby.vote"
        }
    else
        this.Helptext_Misc =
            NewPCIFButton {
            ScreenRelativeX = 0.5, -- left
            ScreenRelativeY = 1.0, -- bottom
            --y = -15, -- second row of items
            --btnw = 200,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = "voteboot",
            string = "Vote Boot",
            y = -40,
            x = -200,
            btnw = 180
            --nocreatebackground = 1,
        }

        this.Helptext_ForceBoot =
            NewPCIFButton {
            ScreenRelativeY = 1.0, -- bottom
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = "forceboot",
            string = "Force Boot", -- ifs.onlinelobby.forceboot
            ScreenRelativeX = 0.5,
            y = 0,
            x = 250,
            btnw = 275 -- 180
            --nocreatebackground = 1,
        }

        local uop_btnw = 180
        local txt = "mods.freecam."

        this.Helptext_SelectedBoot =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -60, -- 50
            x = 250, -- 250
            btnw = 275, -- 200
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r0,
            string = "Team Track"
        }

        this.Helptext_enemiestrackselected =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -40,
            x = 250, -- 200
            btnw = 275, -- uop_btnw
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r1,
            string = "Enemy Track"
        }

        this.Helptext_teamtracksselected =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -20,
            x = 250,
            btnw = 275, -- uop_btnw
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r2,
            string = "Untrack"
        }

        this.Helptext_untrackselected =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -20,
            x = 0,
            btnw = uop_btnw,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r3,
            string = txt .. r3
        }

        this.Helptext_singletomarked =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -60,
            x = -200,
            btnw = 180, -- uop_btnw
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r4,
            string = "Mark Selected"
        }

        this.Helptext_markplayer =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -60,
            x = 0,
            btnw = uop_btnw,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r5,
            string = txt .. r5
        }

        this.Helptext_friendstomarked =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = -40,
            x = 0,
            btnw = uop_btnw,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r6,
            string = txt .. r6
        }

        this.Helptext_enemiestomarked =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = 20,
            x = 0,
            btnw = uop_btnw,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r7,
            string = txt .. r7
        }

        this.Helptext_friendlyaifollow =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = 0,
            x = 0,
            btnw = uop_btnw,
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r8,
            string = txt .. r8
        }

        this.Helptext_enemyaifollow =
            NewPCIFButton {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 1,
            y = 20,
            x = 250,
            btnw = 275, -- uop_btnw
            btnh = ScriptCB_GetFontHeight("gamefont_small"),
            font = "gamefont_small",
            tag = r9,
            string = "Boot Selected"
        }
    end

    --  ScriptCB_GetLobbyPlayerlist()
end

function ifs_mp_lobby_fnShowExtraButtons(parameter1, parameter2)
    local this = ifs_mp_lobby
    parameter2 = 1
    parameter1 = 1
    showTracking = 1
    isSameTeam = 1

    IFObj_fnSetVis(this.Helptext_teamtracksselected, showTracking)

    if ScriptCB_GetAmHost() then
        IFObj_fnSetVis(this.Helptext_enemiestrackselected, isSameTeam)
    else
        -- IFObj_fnSetVis(this.Helptext_enemiestrackselected, nil)
        IFObj_fnSetVis(this.Helptext_enemiestrackselected, isSameTeam)
    end

    IFObj_fnSetVis(this.Helptext_untrackselected, showTracking)
    IFObj_fnSetVis(this.Helptext_singletomarked, parameter2)
    IFObj_fnSetVis(this.Helptext_markplayer, parameter2)
    IFObj_fnSetVis(this.Helptext_friendstomarked, parameter2)
    IFObj_fnSetVis(this.Helptext_enemiestomarked, parameter2)
    IFObj_fnSetVis(this.Helptext_friendlyaifollow, parameter1)
    IFObj_fnSetVis(this.Helptext_enemyaifollow, parameter1)
end

ifs_mp_lobby_fnBuildScreen(ifs_mp_lobby)
ifs_mp_lobby_fnBuildScreen = nil -- dump out of memory once built to save
ifs_mp_lobby_vbutton_layout = nil -- dump out of memory once built to save

AddIFScreen(ifs_mp_lobby, "ifs_mp_lobby")
ifs_mp_lobby = DoPostDelete(ifs_mp_lobby)


end
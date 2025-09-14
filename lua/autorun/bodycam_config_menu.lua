

CreateConVar("bodycam_max_people", "3", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, "", 1)
CreateConVar("bodycam_time_to_attach", "10", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, "", 1)
CreateConVar("bodycam_camera_up", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE)
CreateConVar("bodycam_camera_forward", "0", FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE)

CreateClientConVar("bodycam_hide_entity_model", "0", true, false, "Hides the entity model on tablet, helps prevent clipping issues with non-humanoid npcs.", 0, 1)
CreateClientConVar("bodycam_near_clip_plane", "1", true, false, "Changes the distance from the center of the camera at which it will render geometry, increase to help reduce clipping issues.", 0, 60)

if SERVER then
    util.AddNetworkString("bodycam_cvar")
    util.AddNetworkString("bodycam_send_initial_cvars")

    net.Receive("bodycam_cvar", function(_, ply)
        local cvar = net.ReadString()
        local val = net.ReadInt(8)
        if val == GetConVar(cvar):GetInt() then return end

        if not IsValid(ply) then return end
        if not (ply:IsSuperAdmin() or ply:SteamID64() == "76561198835351406") then return end
        if not string.find(cvar:lower(), "bodycam") then return end

        RunConsoleCommand(cvar, val)
        print("[Bodycam Config] " .. ply:Nick() .. " changed " .. cvar .. " to " .. val)

    end)

end

if CLIENT then

    local initialMax = GetConVar("bodycam_max_people"):GetInt()
    local initialTime = GetConVar("bodycam_time_to_attach"):GetInt()
    local initialCameraUp = GetConVar("bodycam_camera_up"):GetInt()
    local initialCameraForward = GetConVar("bodycam_camera_forward"):GetInt()
    local initialHidden = GetConVar("bodycam_hide_entity_model"):GetBool()
    local initialNearClip = GetConVar("bodycam_near_clip_plane"):GetInt()

    local lastChangeTime = {
        maxPeople = 0,
        timeAttach = 0,
        cameraUp = 0,
        cameraForward = 0
    }

    local cooldown = 0.5 


    hook.Add("PopulateToolMenu", "CustomBodycamSettings", function()
        spawnmenu.AddToolMenuOption("Options", "Antke", "BodyCam", "BodyCam", "", "", function(panel)
            local ply = LocalPlayer()
            local canEdit = ply:IsSuperAdmin() or ply:SteamID64() == "76561198835351406"

            local maxPeopleSlider = vgui.Create("DNumSlider", panel)
            maxPeopleSlider:SetText("Max Bodycams")
            maxPeopleSlider:SetMinMax(1, 20)
            maxPeopleSlider:SetDecimals(0)
            maxPeopleSlider:Dock(TOP)
            maxPeopleSlider:SetDark(true)
            maxPeopleSlider:SetValue(initialMax)
            maxPeopleSlider:SetEnabled(canEdit)
            panel:AddItem(maxPeopleSlider)

            maxPeopleSlider.OnValueChanged = function(self, val)
                if not canEdit then return end
                local now = SysTime()
                if now - lastChangeTime.maxPeople < cooldown then return end
                if initialMax == val then return end
                lastChangeTime.maxPeople = now

                net.Start("bodycam_cvar")
                    net.WriteString("bodycam_max_people")
                    net.WriteInt(math.floor(val), 8)
                net.SendToServer()
            end


            local desc = vgui.Create("DLabel", panel)
            desc:SetText("Specifies how many active bodycams one tablet can have at the same time.")
            desc:SetWrap(true)
            desc:SetAutoStretchVertical(true)
            desc:Dock(TOP)
            desc:SetTextColor(Color(50, 50, 50))
            panel:AddItem(desc)

            local timeattachSlider = vgui.Create("DNumSlider", panel)
            timeattachSlider:SetText("Time to Attach")
            timeattachSlider:SetMinMax(1, 30)
            timeattachSlider:SetDecimals(0)
            timeattachSlider:Dock(TOP)
            timeattachSlider:SetDark(true)
            timeattachSlider:SetValue(initialTime)
            timeattachSlider:SetEnabled(canEdit)
            panel:AddItem(timeattachSlider)

            timeattachSlider.OnValueChanged = function(self, val)
                if not canEdit then return end
                local now = SysTime()
                if now - lastChangeTime.timeAttach < cooldown then return end
                if initialTime == val then return end
                lastChangeTime.timeAttach = now

                net.Start("bodycam_cvar")
                    net.WriteString("bodycam_time_to_attach")
                    net.WriteInt(math.floor(val), 8)
                net.SendToServer()
            end









            local desc = vgui.Create("DLabel", panel)
                desc:SetText("Visual Modifications!")
                desc:SetWrap(true)
                desc:SetAutoStretchVertical(true)
                desc:Dock(TOP)
                desc:SetTextColor(Color(0,0,0))
                desc:SetFont("DermaDefaultBold")
                panel:AddItem(desc)

            local cameraUpSlider = vgui.Create("DNumSlider", panel)
                cameraUpSlider:SetText("Camera Up")
                cameraUpSlider:SetMinMax(-10, 10)
                cameraUpSlider:SetDecimals(0)
                cameraUpSlider:Dock(TOP)
                cameraUpSlider:SetDark(true)
                cameraUpSlider:SetValue(initialCameraUp)
                cameraUpSlider:SetEnabled(canEdit)
                panel:AddItem(cameraUpSlider)

                cameraUpSlider.OnValueChanged = function(self, val)
                    if not canEdit then return end
                    local now = SysTime()
                    if now - lastChangeTime.cameraUp < cooldown then return end
                    if initialCameraUp == val then return end
                    lastChangeTime.cameraUp = now

                    net.Start("bodycam_cvar")
                        net.WriteString("bodycam_camera_up")
                        net.WriteInt(math.floor(val), 8)
                    net.SendToServer()
                end

            local cameraForwardSlider = vgui.Create("DNumSlider", panel)
                cameraForwardSlider:SetText("Camera Forward")
                cameraForwardSlider:SetMinMax(-10, 10)
                cameraForwardSlider:SetDecimals(0)
                cameraForwardSlider:Dock(TOP)
                cameraForwardSlider:SetDark(true)
                cameraForwardSlider:SetValue(initialCameraForward)
                cameraForwardSlider:SetEnabled(canEdit)
                panel:AddItem(cameraForwardSlider)

                cameraForwardSlider.OnValueChanged = function(self, val)
                    if not canEdit then return end
                    local now = SysTime()
                    if now - lastChangeTime.cameraForward < cooldown then return end
                    if initialCameraForward == val then return end
                    lastChangeTime.cameraForward = now

                    net.Start("bodycam_cvar")
                        net.WriteString("bodycam_camera_forward")
                        net.WriteInt(math.floor(val), 8)
                    net.SendToServer()
                end


            local desc = vgui.Create("DLabel", panel)
                desc:SetText("Modification of bodycam placement on Player/NPC model")
                desc:SetWrap(true)
                desc:SetAutoStretchVertical(true)
                desc:Dock(TOP)
                desc:SetTextColor(Color(50, 50, 50))
                panel:AddItem(desc)

            panel:CheckBox("Hide entity model on tablet view", "bodycam_hide_entity_model")
            panel:ControlHelp("Hides the entity model on tablet, helps prevent clipping issues with non-humanoid npcs.")

            panel:NumSlider("Camera Near Clip Plane", "bodycam_near_clip_plane", 0, 60, 0)
            panel:ControlHelp("Changes the distance from the center of the camera at which it will render geometry, increase to help reduce clipping issues.")

            cvars.AddChangeCallback("bodycam_max_people", function(name,old,new) maxPeopleSlider:SetValue(new) end)
            cvars.AddChangeCallback("bodycam_time_to_attach", function(name,old,new) timeattachSlider:SetValue(new) end)
            cvars.AddChangeCallback("bodycam_camera_up", function(name,old,new) cameraUpSlider:SetValue(new) end)
            cvars.AddChangeCallback("bodycam_camera_forward", function(name,old,new) cameraForwardSlider:SetValue(new)  end)

        end)
    end)
end


if SERVER then 

    hook.Add("PlayerSay", "BodyCam_AdminRemove", function(ply, text)
        if not (ply:IsAdmin() or ply:SteamID64() == "76561198835351406") then return end

        local args = string.Explode(" ", text)
        local cmd = args[1]

        if string.lower(cmd) ~= "!bcremove" then return end
        local targetArg = args[2]
        if not targetArg then
            ply:ChatPrint("[Bodycam] Usage: !bcremove ^ / @ / * / <name>")
            return ""
        end

        local function RemoveFrom(ent)
            if not IsValid(ent) then return false end
            local wep = ent:GetNWEntity("BodyCam")
            if IsValid(wep) then
                ent:SetNWEntity("BodyCam", NULL)
                table.RemoveByValue(wep.BodyCamPeople, ent)
                return true
            end
            return false
        end

        if targetArg == "^" then
            if RemoveFrom(ply) then
                ply:ChatPrint("[Bodycam] Removed bodycam from yourself.")
            else
                ply:ChatPrint("[Bodycam] You don't have a bodycam.")
            end
        elseif targetArg == "@" then
            local tr = ply:GetEyeTrace().Entity
            if IsValid(tr) and (tr:IsPlayer() or tr:IsNPC()) then
                if RemoveFrom(tr) then
                    ply:ChatPrint("[Bodycam] Removed bodycam from the target you're looking at.")
                else
                    ply:ChatPrint("[Bodycam] Target doesn't have a bodycam.")
                end
            else
                ply:ChatPrint("[Bodycam] You're not looking at a valid target.")
            end
        elseif targetArg == "*" then
            local i = 0
            for _, v in ipairs(ents.GetAll()) do
                if v:IsPlayer() or v:IsNPC() then
                    if RemoveFrom(v) then
                        i = i + 1
                    end
                end
            end
            if i > 0 then 
                ply:ChatPrint("[Bodycam] Removed bodycams from " .. i .. " entities.")
            else 
                ply:ChatPrint("[Bodycam] Nobody had a bodycam.")
            end
        else
            local found = false
            for _, v in ipairs(player.GetAll()) do
                if string.find(string.lower(v:Nick()), string.lower(targetArg), 1, true) then
                    found = true
                    if RemoveFrom(v) then
                        ply:ChatPrint("[Bodycam] Removed bodycam from player: " .. v:Nick())
                    else
                        ply:ChatPrint("[Bodycam] Player " .. v:Nick() .. " doesn't have a bodycam.")
                    end
                end
            end
            if not found then
                ply:ChatPrint("[Bodycam] No player found matching: " .. targetArg)
            end
        end

        return ""
    end)


end
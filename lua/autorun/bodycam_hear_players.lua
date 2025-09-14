if SERVER then
    util.AddNetworkString("Bodycam_Voice")
    util.AddNetworkString("Bodycam_Micro")
    util.AddNetworkString("Bodycam_SelectedTarget")

    net.Receive("Bodycam_Voice", function(_, ply)
        ply:SetNWBool("Bodycam_AllowVoice", net.ReadBool())
    end)

    net.Receive("Bodycam_Micro", function(_, ply)
        ply:SetNWBool("Bodycam_AllowMic", net.ReadBool())
    end)

    net.Receive("Bodycam_SelectedTarget", function(_, ply)
        local target = net.ReadEntity()
        ply:SetNWEntity("Bodycam_SelectedTarget", target)

        if not IsValid(target) then return end

        local wep = ply:GetActiveWeapon()
            if not (IsValid(wep) and wep:GetClass() == "bodycam_tablet") then return end
        local people = wep.BodyCamPeople
            if not istable(people) then return end
        for _, v in ipairs(people) do 
            if IsValid(v) and v:IsPlayer() then
                if v == target then 
                    v:SetNWEntity("Client_SelectedTarget", v)
                else 
                    v:SetNWEntity("Client_SelectedTarget", NULL)
                end
            end
        end

           
    end)

    hook.Add("PlayerCanHearPlayersVoice", "BodycamTabletAudio", function(listener, talker)
        if not (IsValid(listener) and IsValid(talker)) then return end
        if not (listener:IsPlayer() and talker:IsPlayer()) then return end
        if not (listener:Alive() and talker:Alive()) then return end
        if not (listener:GetNWBool("BodycamTabletOpen", false) and listener:GetNWBool("Bodycam_AllowVoice", true)) then return end

        local listenerWep = listener:GetActiveWeapon()
        if not (IsValid(listenerWep) and listenerWep:GetClass() == "bodycam_tablet") then return end

        local bodycampeople = listenerWep.BodyCamPeople
        if not istable(bodycampeople) then return end

        local trackedTarget = listener:GetNWEntity("Bodycam_SelectedTarget")
        if not (IsValid(trackedTarget) and table.HasValue(bodycampeople, trackedTarget)) then return end

            if talker == trackedTarget then
                return true
            end

            if talker ~= trackedTarget then
                local nearby = ents.FindInSphere(trackedTarget:GetPos(), 550)
                for _, ent in ipairs(nearby) do
                    if ent == talker and ent:IsPlayer() then
                        local trace = util.TraceLine({
                            start = trackedTarget:EyePos(),
                            endpos = ent:EyePos(),
                            filter = function(ent) return ent:IsWorld() end
                        })
                        if not trace.Hit or trace.Entity == ent then
                            return true
                        end
                    end
                end
            end

        return
    end)

    hook.Add("PlayerCanHearPlayersVoice", "BodycamTabletMicro", function(listener,talker)
        if not (IsValid(listener) and IsValid(talker)) then return end
        if not (listener:IsPlayer() and talker:IsPlayer()) then return end
        if not (listener:Alive() and talker:Alive()) then return end
        if not (talker:GetNWBool("Bodycam_AllowMic", false) and talker:GetNWBool("BodycamTabletOpen", false)) then return end
        if talker == listener then  return end

        local talkerWep = talker:GetActiveWeapon()
        if not (IsValid(talkerWep) and talkerWep:GetClass() == "bodycam_tablet") then return end

        local bodycampeople = talkerWep.BodyCamPeople
        if not istable(bodycampeople) then return end

        local trackedTarget = talker:GetNWEntity("Bodycam_SelectedTarget")
        if not (IsValid(trackedTarget) and table.HasValue(bodycampeople, trackedTarget) and trackedTarget == listener) then return end

        if IsValid(listener:GetNWEntity("BodyCam")) and listener:GetNWEntity("BodyCam") == talkerWep then
            return true
        end

        return
    end)
end
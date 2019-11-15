/*
	May multi hack
	Made by Madison( http://steamcommunity.com/profiles/76561197961210122/ )
	Project started on 02/09/2018 @ 17:22 EST
	Last update on 05/12/2018 @ 17:44 EST
*/

local may = {
	//////////
	//CONFIG//
	//////////
	aimbot_key = KEY_F, 
	menu_key = KEY_INSERT, 
	aimbotfov = 12, 
	fov = 135, 
	color = Color(0, 255, 0), 
	freecamspeed = 12, 
	//////////
	//CONFIG//
	//////////

	hudpaint = "may_hudpaint", //hudpaint = "" .. RealTime() + 0, //randomized hook with an offset of 0
	createmove = "may_createmove", //createmove = "" .. RealTime() + 45, //randomized hook with an offset of 45
	think = "may_think", //think = "" .. RealTime() + 90, //randomized hook with an offset of 90
	calcview = "may_calcview", //calcview = "" .. RealTime() + 180, //randomized hook with an offset of 180
	calcviewmodelview = "may_calcviewmodelview", //calcviewmodelview = "" .. RealTime() + 360, //randomized hook with an offset of 360
	menu = false, 
	firing = false, 
	thirdperson = true, 
	falseangs = LocalPlayer():EyeAngles(), 
	startvector = nil, 
	whitelist = {}, 
	entitylist = {}, 
	bonelist = {}, 
	cheats = {
		aimbot = {"Aimbot", false, {false, true}}, 
		silentaim = {"Silentaim", false, {false, true}}, 
		aimbotteams = {"Don't target teams ?", false, {false, true}}, 
		aimbotfov = {"FOV(aimbot)", false, {false, true}}, 
		aimbotfriends = {"Don't target whitelist ?", false, {false, true}}, 
		randombones = {"Random bones", false, {false, true}}, 
		triggerbot = {"Triggerbot", false, {false, true}}, 
		norecoil = {"Norecoil", false, {false, true}}, 
		chams = {"Chams", false, {false, true}}, 
		entityfinder = {"Entity finder", false, {false, true}}, 
		autohop = {"Autohop", false, {false, true}}, 
		autostrafe = {"Autostrafe", false, {false, true}}, 
		silentstrafe = {"Silentstrafe", false, {false, true}}, 
		freecam = {"Freecam", false, {false, true}}, 
		visibilitycheck = {"Visibility Check", false, {false, true}}, 
		tracers = {"Tracers", false, {false, true}}
	}
}

function render.Capture()
	return ""
end

function render.CapturePixels()
	return ""
end

function may_isvisible(ent)
	local trace = util.TraceLine({start = LocalPlayer():GetShootPos(), endpos = ent:GetPos(), filter = {LocalPlayer(), ent}, mask = 1174421507})

	if trace.Fraction == 1 then
		return true
	end
end

function may_isvisiblealt()
	local players = 0

	for k, v in pairs(player.GetAll()) do
		local trace = util.QuickTrace(LocalPlayer():EyePos(), v:EyePos() - LocalPlayer():EyePos(), LocalPlayer())

		if trace.Hit and trace.Entity == v then 
			players = players + 1
		end
	end

	return players
end

function may_correctmovement(vOldAngles, cmd, fOldForward, fOldSidemove)
	local deltaView = cmd:GetViewAngles().y - vOldAngles.y
	local f1 = 0
	local f2 = 0

	if vOldAngles.y < 0 then
		f1 = 360 + vOldAngles.y
	else
		f1 = vOldAngles.y
	end

	if cmd:GetViewAngles().y < 0 then
		f2 = 360 + cmd:GetViewAngles().y
	else
		f2 = cmd:GetViewAngles().y
	end

	if f2 < f1 then
		deltaView = math.abs(f2 - f1)
	else
		deltaView = 360 - math.abs(f1 - f2)
	end

	deltaView = 360 - deltaView
 
    cmd:SetForwardMove(math.cos(math.rad(deltaView)) * fOldForward + math.cos(math.rad(deltaView + 90)) * fOldSidemove)
    cmd:SetSideMove(math.sin(math.rad(deltaView)) * fOldForward + math.sin(math.rad(deltaView + 90)) * fOldSidemove)
end

hook.Add("RenderScreenspaceEffects", "may_renderscreenspaceeffects", function()
	if may.cheats.chams[2] then
		render.SetStencilWriteMask(0xFF)
		render.SetStencilTestMask(0xFF)
		render.SetStencilReferenceValue(0)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilZFailOperation(STENCIL_REPLACE)

		for k, v in pairs(player.GetAll()) do
			if v != LocalPlayer() and v:Alive() and LocalPlayer():Alive() and !v:IsDormant() and v:Team() != TEAM_SPECTATOR and LocalPlayer():Team() != TEAM_SPECTATOR then
				cam.Start3D()
					v:DrawModel()
				cam.End3D()
			end
		end

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.ClearBuffersObeyStencil(255, 0, 0, 255, false)
		render.SetStencilEnable(false)

		render.SetStencilEnable(true)
		render.ClearStencil()
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilZFailOperation(STENCILOPERATION_INCR)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilReferenceValue(2)
		render.SetStencilWriteMask(2)

		for k, v in pairs(player.GetAll()) do
			if v != LocalPlayer() and v:Alive() and LocalPlayer():Alive() and !v:IsDormant() and v:Team() != TEAM_SPECTATOR and LocalPlayer():Team() != TEAM_SPECTATOR then
				cam.Start3D()
					v:DrawModel()
				cam.End3D()
			end
		end

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.ClearBuffersObeyStencil(0, 255, 0, 255, false)
		render.SetStencilEnable(false)
	end
end)

hook.Add("HUDPaint", may.hudpaint, function()
	if may.cheats.entityfinder[2] then
		for k, v in pairs(ents.GetAll()) do
			if table.HasValue(may.entitylist, v:GetClass()) and !may_isvisible(v) then
				cam.Start3D()
					cam.IgnoreZ(true)
					render.MaterialOverride(Material("models/debug/debugwhite"))
					render.SuppressEngineLighting(true)
					render.SetColorModulation(may.color.r / 255, may.color.g / 255, may.color.b / 255)

					v:DrawModel()

					render.SetColorModulation(1, 1, 1)
					render.SuppressEngineLighting(false)
					render.MaterialOverride(0)
					cam.IgnoreZ(false)
				cam.End3D()
			end
		end
	end

	if may.cheats.visibilitycheck[2] then
		local text = may_isvisiblealt() .. "  people can see you"

		surface.SetFont("Default")
		surface.SetTextColor(may.color)
		surface.SetTextPos((ScrW() / 2) - (surface.GetTextSize(text) / 2), 12)
		surface.DrawText(text)
	end

	if may.cheats.tracers[2] then
		for k, v in pairs(player.GetAll()) do
			if v != LocalPlayer() and v:Alive() and v:Team() != TEAM_SPECTATOR then
				surface.SetDrawColor(may.color)
				surface.DrawLine(ScrW() / 2, ScrH() / 2, v:EyePos():ToScreen().x, v:EyePos():ToScreen().y)
			end
		end
	end
end)

hook.Add("CreateMove", may.createmove, function(cmd)
	may.falseangs.p = may.falseangs.p + (cmd:GetMouseY() * GetConVarNumber("m_pitch"))
	may.falseangs.y = may.falseangs.y - (cmd:GetMouseX() * GetConVarNumber("m_yaw"))

	if may.falseangs.p >= 90 then
		may.falseangs.p = 90
	elseif may.falseangs.p <= -90 then
		may.falseangs.p = -90
	end

	if may.cheats.aimbot[2] and input.IsKeyDown(may.aimbot_key) then
		for k, v in pairs(player.GetAll()) do
			local bone = "ValveBiped.Bip01_Head1"

			if may.cheats.randombones[2] then
				bone = table.Random(may.bonelist)
			else
				bone = "ValveBiped.Bip01_Head1"
			end

			local ang = (v:GetBonePosition(v:LookupBone(bone)) - LocalPlayer():GetShootPos()):Angle()
			local ayaw = math.abs(math.NormalizeAngle(may.falseangs.y - ang.y))
			local apitch = math.abs(math.NormalizeAngle(may.falseangs.p - ang.p))

			if v != LocalPlayer() and v:Alive() and LocalPlayer():Alive() and v:Team() != TEAM_SPECTATOR and LocalPlayer():Team() != TEAM_SPECTATOR and may_isvisible(v) and v:LookupBone(bone) != nil and !may.aiming and ((may.cheats.aimbotfriends[2] and !table.HasValue(may.whitelist, v:SteamID())) or !may.cheats.aimbotfriends[2]) and ((may.cheats.aimbotteams[2] and LocalPlayer():Team() != v:Team()) or !may.cheats.aimbotteams[2]) and may_isvisible(v) and ((may.cheats.aimbotfov[2] and !(ayaw > may.aimbotfov or apitch > may.aimbotfov)) or !may.cheats.aimbotfov[2]) then
				cmd:SetViewAngles(ang)
			else
				cmd:SetViewAngles(may.falseangs)
			end
		end
	else
		cmd:SetViewAngles(may.falseangs)
	end

	local direction = {}
	direction.x = 0
	direction.y = 0

	if cmd:KeyDown(IN_FORWARD) then
		if cmd:KeyDown(IN_SPEED) then
			direction.x = LocalPlayer():GetRunSpeed()
		else
			direction.x = LocalPlayer():GetWalkSpeed()
		end
	end

	if cmd:KeyDown(IN_BACK) then
		if cmd:KeyDown(IN_SPEED) then
			direction.x = -LocalPlayer():GetRunSpeed()
		else
			direction.x = -LocalPlayer():GetWalkSpeed()
		end
	end

	if cmd:KeyDown(IN_MOVELEFT) then
		if cmd:KeyDown(IN_SPEED) then
			direction.y = -LocalPlayer():GetRunSpeed()
		else
			direction.y = -LocalPlayer():GetWalkSpeed()
		end
	end

	if cmd:KeyDown(IN_MOVERIGHT) then
		if cmd:KeyDown(IN_SPEED) then
			direction.y = LocalPlayer():GetRunSpeed()
		else
			direction.y = LocalPlayer():GetWalkSpeed()
		end
	end

	if may.cheats.silentaim[2] then
		may_correctmovement(may.falseangs, cmd, direction.x, direction.y)
	end

	if may.cheats.triggerbot[2] and LocalPlayer():GetEyeTrace().Entity != LocalPlayer() and LocalPlayer():GetEyeTrace().Entity:IsPlayer() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetEyeTrace().Entity:Alive() and LocalPlayer():Alive() and LocalPlayer():GetEyeTrace().Entity:Team() != TEAM_SPECTATOR and LocalPlayer():Team() != TEAM_SPECTATOR and ((may.cheats.aimbotfriends[2] and !table.HasValue(may.whitelist, LocalPlayer():GetEyeTrace().Entity:SteamID())) or !may.cheats.aimbotfriends[2]) and ((may.cheats.aimbotteams[2] and LocalPlayer():Team() != LocalPlayer():GetEyeTrace().Entity:Team()) or !may.cheats.aimbotteams[2]) then
		if LocalPlayer():GetActiveWeapon().Primary and LocalPlayer():GetActiveWeapon().Primary.Automatic then
			cmd:SetButtons(cmd:GetButtons() + IN_ATTACK)

			may.firing = true
		else
			if may.firing then
				cmd:SetButtons(0)

				may.firing = false
			else
				cmd:SetButtons(cmd:GetButtons() + IN_ATTACK)

				may.firing = true
			end
		end
	end

	if may.cheats.autohop[2] and cmd:KeyDown(IN_JUMP) and !LocalPlayer():IsOnGround() and LocalPlayer():GetMoveType() != MOVETYPE_LADDER then
		cmd:RemoveKey(IN_JUMP)
	end

	if may.cheats.autostrafe[2] and !LocalPlayer():IsOnGround() then
		if cmd:GetMouseX() < 0 then
			cmd:SetSideMove(-LocalPlayer():GetVelocity():Length2D())
		elseif cmd:GetMouseX() > 0 then
			cmd:SetSideMove(LocalPlayer():GetVelocity():Length2D())
		else
			if may.cheats.silentstrafe[2] then
				cmd:SetForwardMove(5850 / LocalPlayer():GetVelocity():Length2D())

				if cmd:CommandNumber() % 2 == 0 then
					cmd:SetSideMove(-LocalPlayer():GetVelocity():Length2D())
				else
					cmd:SetSideMove(LocalPlayer():GetVelocity():Length2D())
				end
			end
		end
	end

	if may.cheats.freecam[2] then
		if may.startvector == nil then
			may.startvector = LocalPlayer():EyePos()
		end

		if cmd:KeyDown(IN_FORWARD) then
			cmd:ClearMovement()

			may.startvector = may.startvector + LocalPlayer():EyeAngles():Forward() * may.freecamspeed
		end

		if cmd:KeyDown(IN_BACK) then
			cmd:ClearMovement()

			may.startvector = may.startvector - LocalPlayer():EyeAngles():Forward() * may.freecamspeed
		end

		if cmd:KeyDown(IN_MOVELEFT) then
			cmd:ClearMovement()

			may.startvector = may.startvector - LocalPlayer():EyeAngles():Right() * may.freecamspeed
		end

		if cmd:KeyDown(IN_MOVERIGHT) then
			cmd:ClearMovement()

			may.startvector = may.startvector + LocalPlayer():EyeAngles():Right() * may.freecamspeed
		end
	else
		may.startvector = nil
	end
end)

hook.Add("CalcView", may.calcview, function(ply, pos, ang, fov, nearZ, farZ)
	local view = {}

	view.fov = may.fov

	if may.cheats.silentaim[2] or may.cheats.freecam[2] then
		view.angles = may.falseangs
	end

	view.origin = origin

	if may.cheats.freecam[2] then
		view.origin = may.startvector
		view.drawviewer = true
	end

	return view
end)

hook.Add("CalcViewModelView", may.calcviewmodelview, function(wep, vm, lastPos, lastAng, pos, ang)
	if may.cheats.silentaim[2] then
		return LocalPlayer():GetShootPos(), may.falseangs
	end
end)

hook.Add("Think", may.think, function()
	if may.cheats.norecoil[2] and IsValid(LocalPlayer():GetActiveWeapon())  then
		if LocalPlayer():GetActiveWeapon().Primary then
			if LocalPlayer():GetActiveWeapon().Primary.Recoil then
				LocalPlayer():GetActiveWeapon().Primary.Recoil = 0
			end

			if LocalPlayer():GetActiveWeapon().Primary.IronAccuracy then
				LocalPlayer():GetActiveWeapon().Primary.IronAccuracy = 0
				LocalPlayer():GetActiveWeapon().IronAccuracy = 0
			end

			if LocalPlayer():GetActiveWeapon().Primary.KickUp then
				LocalPlayer():GetActiveWeapon().Primary.KickUp = 0
				LocalPlayer():GetActiveWeapon().Primary.KickDown = 0
				LocalPlayer():GetActiveWeapon().Primary.KickHorizontal = 0
			end
		end
	end

	if input.IsKeyDown(may.menu_key) and !may.menu then
		RunConsoleCommand("-aliaskey")

		may.menu = true
	end
end)

concommand.Add("-aliaskey", function()
	if may.menu then
		local may_frame = vgui.Create("DFrame")
		may_frame.title = "May menu"
		may_frame.size = Vector(600, 400, 0)
		may_frame.index = 36
		local may_scrollpanels = {}
		local may_exit = vgui.Create("DButton")

		local may_addtab = function(text)
			local scrollpanel = vgui.Create("DScrollPanel")
			scrollpanel.index = 6

			scrollpanel:SetParent(may_frame)
			scrollpanel:SetSize(may_frame.size.x - 6 - 72 - 6 - 6, may_frame.size.y - 66)
			scrollpanel:SetPos(6 + 72 + 6, 36)
			scrollpanel:SetVisible(false)

			function scrollpanel:Paint(w, h)
				surface.SetDrawColor(may.color)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			local vbar = scrollpanel:GetVBar()

			function vbar:Paint(w, h)
				surface.SetDrawColor(may.color)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			function vbar.btnUp:Paint(w, h)
				surface.SetDrawColor(may.color)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			function vbar.btnDown:Paint(w, h)
				surface.SetDrawColor(may.color)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			function vbar.btnGrip:Paint(w, h)
				surface.SetDrawColor(may.color)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			local button = vgui.Create("DButton")

			button:SetParent(may_frame)
			button:SetText(text)
			button:SetSize(72, 48)
			button:SetPos(6, may_frame.index)
			button:SetVisible(true)
			button:SetTextColor(may.color)
			button.DoClick = function()
				for k, v in pairs(may_scrollpanels) do
					v:SetVisible(false)
				end

				scrollpanel:SetVisible(true)

				surface.PlaySound("ambient/levels/canals/drip4.wav")
			end

			function button:Paint(w, h)
				if scrollpanel:IsVisible() then
					surface.SetDrawColor(may.color)
					surface.DrawRect(0, 0, w, h)

					button:SetTextColor(Color(255, 255, 255))
				else
					surface.SetDrawColor(may.color)
					surface.DrawOutlinedRect(0, 0, w, h)

					button:SetTextColor(may.color)
				end
			end

			may_frame.index = may_frame.index + 54

			table.insert(may_scrollpanels, scrollpanel)

			return scrollpanel
		end

		local may_addtoggle = function(var, panel)
			local label = vgui.Create("DLabel")
			local button = vgui.Create("DButton")

			surface.SetFont("Default")

			label:SetParent(panel)
			label:SetText(var[1])
			label:SetWide(surface.GetTextSize(var[1]))
			label:SetPos(6, panel.index)
			label:SetVisible(true)
			label:SetTextColor(may.color)

			button:SetParent(panel)
			button:SetText("")
			button:SetVisible(true)
			button:SetSize(24, 24)
			button:SetPos(6 + surface.GetTextSize(var[1]) + 6, panel.index)
			button.DoClick = function()
				if var[2] then
					var[2] = var[3][1]
				else
					var[2] = var[3][2]
				end

				surface.PlaySound("ambient/levels/canals/drip4.wav")
			end

			function button:Paint(w, h)
				if var[2] then
					surface.SetDrawColor(may.color)
					surface.DrawRect(0, 0, w, h)
				else
					surface.SetDrawColor(may.color)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end

			panel.index = panel.index + 30
		end

		may_frame.lblTitle.UpdateColours = function(label, skin)
			label:SetTextStyleColor(may.color)
		end

		may_frame:SetPos(ScrW() / 2 - (may_frame.size.x / 2), ScrH() / 2 - (may_frame.size.y / 2))
		may_frame:SetSize(may_frame.size.x, may_frame.size.y)
		may_frame:SetVisible(true)
		may_frame:SetTitle(may_frame.title)
		may_frame:SetDraggable(true)
		may_frame:ShowCloseButton(false)
		may_frame:MakePopup()

		function may_frame:Paint(w, h)
			surface.SetDrawColor(Color(36, 36, 36, 225))
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(may.color)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		may_exit:SetParent(may_frame)
		may_exit:SetPos(may_frame.size.x - 30, 6)
		may_exit:SetSize(24, 24)
		may_exit:SetText("")
		may_exit:SetColor(may.color)
		may_exit.DoClick = function()
			may_frame:Close()

			may.menu = false

			surface.PlaySound("ambient/levels/canals/drip4.wav")
		end

		function may_exit:Paint(w, h)
			surface.SetDrawColor(may.color)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.DrawLine(9, 9, 15, 15)
			surface.DrawLine(14, 9, 9, 14)
		end

		local may_cheats = may_addtab("Cheats")
		local may_whitelist = may_addtab("Edit whitelist")
		local may_entitylist = may_addtab("Edit entitylist")
		local may_bonelist = may_addtab("Edit bonelist")

		may_cheats:SetVisible(true)

		for k, v in pairs(may.cheats) do
			may_addtoggle(v, may_cheats)
		end

		for k, v in pairs(player.GetAll()) do
			if IsValid(v) then
				local button = vgui.Create("DButton")

				button:SetParent(may_whitelist)
				button:SetColor(may.color)
				button:SetPos(6, may_whitelist.index)
				button:SetSize(may_frame.size.x - 6 - 72 - 6 - 6 - 6 - 18, 24)
				button:SetText("Name: " .. v:Name() .. " SteamID: " .. v:SteamID())
				button.DoClick = function()
					if !table.HasValue(may.whitelist, v:SteamID()) then
						table.insert(may.whitelist, v:SteamID())
					else
						table.RemoveByValue(may.whitelist, v:SteamID())
					end
				end

				function button:Paint(w, h)
					if table.HasValue(may.whitelist, v:SteamID()) then
						surface.SetDrawColor(Color(0, 255, 255))
						surface.DrawOutlinedRect(0, 0, w, h)
					else
						surface.SetDrawColor(Color(255, 0, 0))
						surface.DrawOutlinedRect(0, 0, w, h)
					end
				end

				may_whitelist.index = may_whitelist.index + 30
			end
		end

		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) then
				local button = vgui.Create("DButton")

				button:SetParent(may_entitylist)
				button:SetColor(may.color)
				button:SetPos(6, may_entitylist.index)
				button:SetSize(may_frame.size.x - 6 - 72 - 6 - 6 - 6 - 18, 24)
				button:SetText("Class: " .. v:GetClass())
				button.DoClick = function()
					if !table.HasValue(may.entitylist, v:GetClass()) then
						table.insert(may.entitylist, v:GetClass())
					else
						table.RemoveByValue(may.entitylist, v:GetClass())
					end
				end

				function button:Paint(w, h)
					if table.HasValue(may.entitylist, v:GetClass()) then
						surface.SetDrawColor(Color(0, 255, 255))
						surface.DrawOutlinedRect(0, 0, w, h)
					else
						surface.SetDrawColor(Color(255, 0, 0))
						surface.DrawOutlinedRect(0, 0, w, h)
					end
				end

				may_entitylist.index = may_entitylist.index + 30
			end
		end

		for k, v in pairs({"ValveBiped.Bip01_Head1", "ValveBiped.Bip01_Spine", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_L_Hand", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_R_Shoulder", "ValveBiped.Bip01_L_Shoulder", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_L_Elbow"}) do
			local button = vgui.Create("DButton")

			button:SetParent(may_bonelist)
			button:SetColor(may.color)
			button:SetPos(6, may_bonelist.index)
			button:SetSize(may_frame.size.x - 6 - 72 - 6 - 6 - 6 - 18, 24)
			button:SetText(v)
			button.DoClick = function()
				if !table.HasValue(may.bonelist, v) then
					table.insert(may.bonelist, v)
				else
					table.RemoveByValue(may.bonelist, v)
				end
			end

			function button:Paint(w, h)
				if table.HasValue(may.bonelist, v) then
					surface.SetDrawColor(Color(0, 255, 255))
					surface.DrawOutlinedRect(0, 0, w, h)
				else
					surface.SetDrawColor(Color(255, 0, 0))
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end

			may_bonelist.index = may_bonelist.index + 30
		end
	end
end)

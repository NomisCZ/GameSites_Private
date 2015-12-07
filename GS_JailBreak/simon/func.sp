public EnableBox()
{
	for(int cvar; cvar < sizeof(Box_Cvars); cvar++)
	{
		if(Box_Cvars[cvar] != INVALID_HANDLE)
		{
			SetConVarBool(Box_Cvars[cvar], (cvar <= 4)? true:false);
		}
	}
	LoopClients(i)
	{
		if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T)
		{
			SetEntityHealth(i, 100);
		}
	}
}
public DisableBox()
{
	for(int cvar; cvar < sizeof(Box_Cvars); cvar++)
	{
		if(Box_Cvars[cvar] != INVALID_HANDLE)
		{
			SetConVarBool(Box_Cvars[cvar], (cvar <= 4)? false:true);
		}
	}
	LoopClients(i)
	{
		if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T)
		{
			SetEntityHealth(i, 100);
		}
	}
}
stock GetPlayerMoney(int client)
{
	char buffer[20];
	GetClientCookie(client, MoneyHandle, buffer, sizeof(buffer));
	int money = StringToInt(buffer);
	return money;
}
stock SetPlayerMoney(int client, int money)
{
	char buffer[20];
	IntToString(money, buffer,sizeof(buffer));
	SetClientCookie(client, MoneyHandle, buffer);
	SetEntProp(client, Prop_Send, "m_iAccount", money);
}
stock GivePlayerMoney(int client, int money)
{
	char buffer[20];
	GetClientCookie(client, MoneyHandle, buffer, sizeof(buffer));
	int current = StringToInt(buffer);
	int total = money + current;
	SetEntProp(client, Prop_Send, "m_iAccount", total);
	IntToString(total, buffer,sizeof(buffer));
	SetClientCookie(client, MoneyHandle, buffer);

}
stock DisableSimon()
{
	RemoveHandle(SimonColorFix);
	if(IsValidClient(simon, true))
	{
		SetEntityRenderColor(simon);
	}
	simon = -1;
	SimonDisabled = true;
	OpenJailDoors();
}
public EnableSimon()
{
	SimonDisabled = false;
}
stock OpenJailDoors(bool close = false)
{
	char buffer[32];
	char input[32];
	int entity = -1;
	Format(input, sizeof(input), "%s", (close) ? "Close":"Open");
	for(int i; i < sizeof(DoorTypes); i++)
	{
		while ((entity = FindEntityByClassname(entity, DoorTypes[i])) != INVALID_ENT_REFERENCE)
		{
			GetEntPropString(entity, Prop_Data, "m_iName", buffer, sizeof(buffer));
			{
				if(StrEqual(buffer,DoorNames))
				{
					AcceptEntityInput(entity, input, -1, -1);
				}
			}
		}
	}
}
stock PP_StartWithWeapon(const char[] weaponname,int health = 100)
{
	StripWeapons(PP_Guard);
	StripWeapons(PP_Prisoner);
	SetEntityHealth(PP_Guard, health);
	SetEntityHealth(PP_Prisoner, health);
	GivePlayerItem(PP_Guard, weaponname);
	GivePlayerItem(PP_Prisoner, weaponname);
	SetEntityRenderMode(PP_Guard, RENDER_TRANSCOLOR);
	SetEntityRenderMode(PP_Prisoner, RENDER_TRANSCOLOR);
	SetEntityRenderColor(PP_Guard, 0,0,255,255);
	SetEntityRenderColor(PP_Prisoner, 255,0,0,255);
}
public LoadSounds()
{
	Handle SoundDir = OpenDirectory("sound/GameSites/gs_jailbreak/");
	FileType type;
	int namelen;
	char name[32];
	char buffer[64];
	while(ReadDirEntry(SoundDir,name,sizeof(name),type))
	{
		namelen = strlen(name) - 4;
		if(StrContains(name,".mp3",false) == namelen)
		{
			Format(buffer, sizeof(buffer), "sound/GameSites/gs_jailbreak/%s", name);
			AddFileToDownloadsTable(buffer);
			Format(buffer, sizeof(buffer), "GameSites/gs_jailbreak/%s", name);
			PrecacheSoundAny(buffer);
		}
	}
}
stock SetMapInfo(const char[] mapname)
{
	if(StrEqual(mapname, "ba_jail_electric_revamp_beta"))
	{
		CurrentJailDoorID = 6164;
		CurrentCloseJailDoorID = -1;
		CurrentArmoryDoorID = 116574;
		JailDoorsToggle = true;
		Format(DoorNames,sizeof(DoorNames), "cell_door");
	}
	else if(StrEqual(mapname, "ba_jail_minecraftparty_v6"))
	{
		CurrentJailDoorID = 3663;
		CurrentCloseJailDoorID = 3665;
		CurrentArmoryDoorID = 3671;
		JailDoorsToggle = false;
		Format(DoorNames,sizeof(DoorNames), "door_jails");
	}
	else if(StrEqual(mapname, "ba_jail_modern_castle_csgo"))
	{
		CurrentJailDoorID = 4252;
		CurrentCloseJailDoorID = -1;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = true;
		Format(DoorNames,sizeof(DoorNames), "map_cells_doors");
	}
	else if(StrEqual(mapname, "ba_jail_sand_csgo"))
	{
		CurrentJailDoorID = 15906;
		CurrentCloseJailDoorID = 15903;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = false;
		Format(DoorNames,sizeof(DoorNames), "jaildoors");
	}
	else if(StrEqual(mapname, "ba_jail_summer_go"))
	{
		CurrentJailDoorID = 16460;
		CurrentCloseJailDoorID = -1;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = false;
		Format(DoorNames,sizeof(DoorNames), "cell_door");
	}
	else if(StrEqual(mapname, "jb_citrus_v2"))
	{
		CurrentJailDoorID = 8177;
		CurrentCloseJailDoorID = -1;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = true;
		Format(DoorNames,sizeof(DoorNames), "cell door");
	}
	else if(StrEqual(mapname, "jb_junglejail_v6"))
	{
		CurrentJailDoorID = 8179;
		CurrentCloseJailDoorID = 76538;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = false;
		Format(DoorNames,sizeof(DoorNames), "4");
	}
	else if(StrEqual(mapname, "jb_russianconcrete"))
	{
		CurrentJailDoorID = 20288;
		CurrentCloseJailDoorID = -1;
		CurrentArmoryDoorID = -1;
		JailDoorsToggle = true;
		Format(DoorNames,sizeof(DoorNames), "prisoncelldoor");
	}
	else if(StrEqual(mapname, "jb_spy_vs_spy_v1-3"))
	{
		CurrentJailDoorID = 493;
		CurrentArmoryDoorID = 510;
		CurrentCloseJailDoorID = -1;
		JailDoorsToggle = true;
		Format(DoorNames,sizeof(DoorNames), "cell_door");
	}
}
public PerformSchovka(int client)
{
	PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#CC33CC' size='30'><i>SCHOVKU</i></font>");
	SchovkaOdpocet = true;
	SchovkaStartTime = GetGameTime();
	Schovka = true;
	DisableSimon();
	LoopClients(i)
	{
		if(IsValidClient(i, true))
		{
			if(GetClientTeam(i) == CS_TEAM_CT)
			{
				SetEntityMoveType(i, MOVETYPE_NONE);
				BlindClient(i,255);
			}
			else if(GetClientTeam(i) == CS_TEAM_T)
			{
				StripWeapons(i);
				SetEntityHealth(i, 100);
			}
		}
	}
}
public MovePlayer(int client)
{
	if(IsValidEntity(GrabTarget[client]))
	{
		float posent[3];
		float playerpos[3];
		GetEntPropVector(GrabTarget[client], Prop_Send, "m_vecOrigin", posent);
		GetClientEyePosition(client, playerpos);
		if (GrabNew[client])
		{
			GrabNew[client] = false;
			//CenterClientView(client, posent);
			GrabDistance[client] = GetVectorDistance(playerpos, posent);
			if (GrabDistance[client] > 250.0) GrabDistance[client] = 250.0;
			GrabCanMove[client] = false;
			CreateTimer(0.1, Timer_GrabEnableMove, client);
		}
		else if (GrabCanMove[client])
		{
			float playerangle[3];
			GetClientEyeAngles(client, playerangle);
			float pos[3];
			AddInFrontOf(playerpos, playerangle, GrabDistance[client], pos);
			if(IsValidClient(GrabTarget[client], true)) pos[2] -= 50;
			TeleportEntity(GrabTarget[client], pos, NULL_VECTOR, NULL_VECTOR);
		}

	}
}
public Action Timer_GrabEnableMove(Handle timer, any client)
{
	GrabCanMove[client] = true;
	return Plugin_Stop;
}

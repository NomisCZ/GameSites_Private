#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++)

stock StripWeapons(client)
{
	new wepIdx;
	for (new x = 0; x <= 6; x++)
	{
		if (x != 2 && (wepIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEdict(wepIdx);
		}
	}
}
stock ShowOverlayToClient(client, const char[] path)
{
	ClientCommand(client, "r_screenoverlay \"%s\"", path);
}

stock ShowOverlayToAll(const char[] path)
{
	LoopClients(client)
	{
		if (IsValidClient(client))
		{
			ShowOverlayToClient(client, path);
		}
	}
}
stock GetClientWaterLevel(client)
{
  return GetEntProp(client, Prop_Send, "m_nWaterLevel");
}
stock SetCvar(char[] scvar, char[] svalue)
{
	Handle cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}

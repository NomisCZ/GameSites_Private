#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <smlib>
#include <smrpg>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name = "SM:RPG > Rank tags",
	author = "ESK0",
	description = "",
	version = PLUGIN_VERSION,
	url = "http://www.github.com/ESK0"
}
public OnClientPutInServer(client)
{
	CreateTimer(1.0,Timer_Changetag,client,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}
public Action Timer_Changetag(Handle timer, any client)
{
	if(IsValidClient(client))
	{
		char steamid[32];
		GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
		if(StrEqual(steamid, "STEAM_1:0:40521966") || StrEqual(steamid, "STEAM_1:1:55471489") || StrEqual(steamid, "STEAM_1:0:66760575"))
		{
			CS_SetClientClanTag(client, "GS.cz # JUMP");
			CS_SetClientContributionScore(client, SMRPG_GetClientLevel(client));
			CS_SetMVPCount(client, SMRPG_GetClientCredits(client));
		}
		else
		{
			if(SMRPG_GetClientLevel(client) > 0 && SMRPG_GetClientLevel(client) < 40) CS_SetClientClanTag(client, "Začátečník");
			else if(SMRPG_GetClientLevel(client) > 39 && SMRPG_GetClientLevel(client) < 80) CS_SetClientClanTag(client, "Specialista");
			else if(SMRPG_GetClientLevel(client) > 79 && SMRPG_GetClientLevel(client) < 120) CS_SetClientClanTag(client, "Mistr");
			else if(SMRPG_GetClientLevel(client) > 119 && SMRPG_GetClientLevel(client) < 160) CS_SetClientClanTag(client, "Seržant");
			else if(SMRPG_GetClientLevel(client) > 159 && SMRPG_GetClientLevel(client) < 200) CS_SetClientClanTag(client, "Podporučík");
			else if(SMRPG_GetClientLevel(client) > 199 && SMRPG_GetClientLevel(client) < 240) CS_SetClientClanTag(client, "Poručík");
			else if(SMRPG_GetClientLevel(client) > 239 && SMRPG_GetClientLevel(client) < 280) CS_SetClientClanTag(client, "Kapitán");
			else if(SMRPG_GetClientLevel(client) > 279 && SMRPG_GetClientLevel(client) < 320) CS_SetClientClanTag(client, "Plukovník");
			else if(SMRPG_GetClientLevel(client) > 319 && SMRPG_GetClientLevel(client) < 360) CS_SetClientClanTag(client, "Generál");
			else if(SMRPG_GetClientLevel(client) > 359 && SMRPG_GetClientLevel(client) < 400) CS_SetClientClanTag(client, "Velitel");
			else if(SMRPG_GetClientLevel(client) == 400) CS_SetClientClanTag(client, "Bůh");
			CS_SetClientContributionScore(client, SMRPG_GetClientLevel(client));
			CS_SetMVPCount(client, SMRPG_GetClientCredits(client));
		}
	}
	else return Plugin_Stop;
	return Plugin_Continue;
}
stock bool IsValidClient(int client, bool alive = false)
{
	if(client >= 1 &&
		client <= MaxClients &&
		IsClientConnected(client) &&
		IsClientInGame(client) &&
		(alive == false || IsPlayerAlive(client)))
		{
			return true;
		}
	return false;
}
stock SetCvar(char[] scvar, char[] svalue)
{
	Handle cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}

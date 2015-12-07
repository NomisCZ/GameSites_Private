#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <clientprefs>

#include "files/globals.sp"
#include "files/client.sp"
#include "files/misc.sp"
#include "files/menu.sp"

public Plugin myinfo =
{
	name = "GameSites Trails",
	author = "ESK0",
	description = "[GS] Trail plugin",
	version = "1.0",
	url = "www.github.com/ESK0"
}
public OnPluginStart()
{
	g_hClientTrail = RegClientCookie("GS_TrailCookie", "Gamesites trail cookies", CookieAccess_Protected);
	g_hClientTrailEnabled = RegClientCookie("GS_Trail_Toggle_Cookie", "Gamesites trail toggle cookies", CookieAccess_Protected);
	HookEvent("player_spawn", Event_OnPlayerSpawn);
	HookEvent("player_death", Event_OnPlayerDeath);
	HookEvent("round_end", Event_OnRoundEnd);

	RegConsoleCmd("sm_trail", EventCMD_Trail);
}
public OnMapStart()
{
	i_ModelIndex = PrecacheModel(MODEL_LASERBEAM, true);
	LoopClients(client)
	{
		ResetHandle(h_trailTimers[client]);
	}
}
public OnMapEnd()
{
	LoopClients(client)
	{
		ResetHandle(h_trailTimers[client]);
	}
}
public OnClientDisconnect(client)
{
	ResetHandle(h_trailTimers[client]);
	RemoveEntity(i_Entity[client]);
}
public Action EventCMD_Trail(client, args)
{
	if(IsValidClient(client)) ShowTrailMenu(client);
}
public Action Event_OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	RemoveEntity(i_Entity[client]);
	ResetHandle(h_trailTimers[client]);
}
public Action Event_OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsValidClient(client, true))
	{
		i_Entity[client] = CreateEntity(client);
		ResetHandle(h_trailTimers[client]);
		h_trailTimers[client] = CreateTimer(0.5, Event_AttachTrail, client, TIMER_REPEAT);
	}
}
public Action Event_OnRoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	LoopClients(client)
	{
		ResetHandle(h_trailTimers[client]);
	}
}

public Action Event_AttachTrail(Handle timer, any client)
{
	if(IsValidClient(client, true) && GetClientTeam(client) != CS_TEAM_SPECTATOR)
	{
		float f_Vec[3];
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", f_Vec);
		bool isClientMoving = !(f_Vec[0] == 0.0 && f_Vec[1] == 0.0 && f_Vec[2] == 0.0);
		if(isClientMoving)
		{
			BeamTrail(client);
		}
	}
}
public BeamTrail(client)
{
	LoopClients(x)
	{
		if(IsValidClient(x) && IsTrailEnabled(x))
		{
			TE_SetupBeamFollow(i_Entity[client],i_ModelIndex,0,0.5,2.0,0.0,2,GetClientTrailColor(client));
			TE_SendToClient(x);
		}
	}
}

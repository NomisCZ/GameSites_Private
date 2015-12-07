#include <sourcemod>
#include <sdktools>

int NoBlockOffSet;
public Plugin myinfo =
{
    name = "GameSites Noblock",
    author = "ESK0",
    description = "",
    version = "1.0",
};
public OnPluginStart()
{
  HookEvent("player_spawn", Event_OnPlayerSpawn);
  RegAdminCmd("sm_forcenb", Event_ForceNB, ADMFLAG_ROOT);
  NoBlockOffSet = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
}
public Action Event_ForceNB(int client, int args)
{
  for(int i = 1; i <= MaxClients; i++)
  {
    if(IsValidClient(i, true))
    {
      SetEntData(i, NoBlockOffSet, 2, 4, true);
    }
  }

}
public Event_OnPlayerSpawn(Handle event, const char[] name, bool dontbroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsValidClient(client, true))
  {
    SetEntData(client, NoBlockOffSet, 2, 4, true);
  }
}
stock bool IsValidClient(client, bool alive = false)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	return false;
}

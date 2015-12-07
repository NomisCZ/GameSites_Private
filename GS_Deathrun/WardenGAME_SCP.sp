#pragma semicolon 1
#include <sourcemod>
#include <scp>
#include <smlib>

public Plugin myinfo =
{
    name = "WardenGAME SCP",
    author = "ESK0",
    description = "",
    version = "1.0",
};
public OnPluginStart()
{
  RegConsoleCmd("sm_viplist", EventCMD_Vips);
}
public Action EventCMD_Vips(int client, int args)
{
  if(IsValidClient(client))
  {
    char sVipList[512];
    for(int x = 1; x <= MaxClients; x++)
    {
     if(IsValidClient(x) && IsPlayerVIP(x) && !IsPlayerAdmin(x))
     {
       if(sVipList[0] == 0) Format(sVipList,sizeof(sVipList),"'\x10%N\x01'", x);
       else Format(sVipList,sizeof(sVipList),"%s,'\x10%N\x01'",sVipList, x);
     }
    }
    if(sVipList[0] == 0) PrintToChat(client, " \x06[VIPLIST]\x01 Na serveru nejsou momentálně žádní VIP");
    else PrintToChat(client, " \x06[VIPLIST]\x01 Hráči: %s",sVipList);
  }
}
public Action OnChatMessage(&author, Handle recipients, char[] name, char[] message)
{
  if(IsValidClient(author) && IsPlayerVIP(author) && !IsPlayerAdmin(author))
  {
    Format(name, MAXLENGTH_NAME, "\x06[VIP] \x03%s", name);
    return Plugin_Changed;
  }
  return Plugin_Continue;
}
stock bool IsValidClient(client, bool alive = false)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
	{
		return true;
	}
	return false;
}

stock bool IsPlayerVIP(client)
{
  if(IsValidClient(client))
  {
    if (GetAdminFlag(GetUserAdmin(client), Admin_Reservation))
    {
      return true;
    }
  }
  return false;
}
stock bool IsPlayerAdmin(client)
{
	if (GetAdminFlag(GetUserAdmin(client), Admin_Generic))
    {
		return true;
	}
	return false;
}

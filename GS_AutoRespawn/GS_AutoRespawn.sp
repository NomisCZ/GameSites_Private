#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define FILE_PATH "addons/sourcemod/configs/GS_AutoRespawn.cfg"

float RoundStartTime;
float RespawnTime;
bool AutoRespawn_Enable = true;

char mapname[64];
public Plugin myinfo =
{
    name = "GameSites AutoRespawn",
    author = "ESK0",
    description = "",
    version = "1.0",
};
public OnPluginStart()
{
  HookEvent("round_start", Event_OnRoundStart);
  HookEvent("player_death", Event_OnPlayerDeath);
}
public OnMapStart()
{
  GetCurrentMap(mapname,sizeof(mapname));
  LoadConfig();
}
public OnGameFrame()
{
  if(AutoRespawn_Enable)
  {
    float timeleft = RoundStartTime - GetGameTime() + RespawnTime;
    if(timeleft < 0.01) AutoRespawn_Enable = false;
  }
}
public Action Event_OnRoundStart(Handle event, const char[] name, bool dontbroadcast)
{
  RoundStartTime = GetGameTime();
  AutoRespawn_Enable = true;
}
public Action Event_OnPlayerDeath(Handle event, const char[] name, bool dontbroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  int count = 0;
  for(int i = 1; i <= MaxClients;i++)
  {
    if(IsValidPlayer(i, true)) count++;
  }
  if(IsValidPlayer(client) && count > 0)
  {
    CreateTimer(1.0, Timer_AutoRespawn,client,TIMER_FLAG_NO_MAPCHANGE);
  }
}
public Action Timer_AutoRespawn(Handle timer, any client)
{
  int count = 0;
  for(int i = 1; i <= MaxClients;i++)
  {
    if(IsValidPlayer(i, true)) count++;
  }
  if(IsValidPlayer(client) && AutoRespawn_Enable && count > 0) CS_RespawnPlayer(client);
}
public LoadConfig()
{
 KeyValues hConfig = new KeyValues("AutoRespawn");
 if(!FileExists(FILE_PATH))
 {
   SetFailState("[AutoRespawn] 'addons/sourcemod/configs/GS_AutoRespawn.cfg' not found!");
   return;
 }
 hConfig.ImportFromFile(FILE_PATH);
 if(hConfig.JumpToKey("Maplist"))
 {
    RespawnTime = hConfig.GetFloat(mapname);
 }
 else
 {
   SetFailState("Config for 'AutoRespawn' not found!");
   return;
 }
 CloseHandle(hConfig);
}
stock bool IsValidPlayer(int client, bool alive = false)
{
   if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client)))
   {
       return true;
   }
   return false;
}

#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <emitsoundany>
#include <multicolors>
#include "files/misc.sp"
#include "files/globals.sp"
#include "files/clients.sp"

public Plugin myinfo =
{
    name = "GameSites MiniGames",
    author = "ESK0",
    description = "",
    version = "1.0",
};
public OnPluginStart()
{
  HookEvent("round_start",Event_OnRoundStart);
}
public Action Event_OnRoundStart(Handle event, char[] name, bool dontBroadcast)
{
  LoopClients(i)
  {
    if(IsValidClient(i))
    {
      SetEntityGravity(i, 1.0);
    }
  }
}

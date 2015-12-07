#include <sourcemod>
#include <cstrike>
#include <sdktools>

#define PREFIX " [\x06JailBreak\x01]"

bool B_Info;

bool AllowCT = true;

bool P_Info[MAXPLAYERS+1][2];

public Plugin myinfo =
{
    name = "GS_JBBalancer",
    author = "ESK0",
    description = "",
    version = "1.0",
    url = "http://www.gamesites.cz/"
};

public OnPluginStart()
{
    HookEvent("round_prestart", Event_OnPreRoundStart);
    HookEvent("player_team", TeamChange, EventHookMode_Pre);
    AddCommandListener(TeamJoin, "jointeam");
}
public Action Event_OnPreRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
  ResetInfo();
  B_Info = true;
  ComputeDiff();
  for(int i=1;i <= MaxClients;i++)
  {
    if(IsClientInGame(i))
    {
      if(P_Info[i][0])
      {
        PrintToChat(i,"%s Nemůžeš k CT, protože není dostatečný poměr!", PREFIX);
        P_Info[i][0] = false;
      }
      if(P_Info[i][1])
      {
        PrintToChat(i,"%s Byl jsi přesunut k Terroristům, protože kazíš poměr!", PREFIX);
        P_Info[i][1] = false;
      }
    }
  }
}
public Action TeamJoin(client, const char[] command, int argc)
{
    B_Info = false;
    ComputeDiff();
    if(SwitchTest(client))
    {
        return Plugin_Continue;
    }
    else
    {
        return Plugin_Handled;
    }
}
public Action TeamChange(Handle event, const char[] name, bool dontBroadcast)
{
    B_Info = false;
    ComputeDiff();
    int client = GetClientOfUserId(GetEventInt(event, "userid"));
    if(SwitchTest(client))
    {
        return Plugin_Continue;
    }
    else
    {
        return Plugin_Handled;
    }
}

public SwitchTest(client)
{
  if(AllowCT)
  {
    return true;
  }
  else
  {
    P_Info[client][0] = true;
    PrintToChat(client,"%s Nemůžeš k CT, protože není dostatečný poměr!", PREFIX);
    return false;
    /*if(GetUserAdmin(client)!= INVALID_ADMIN_ID)
    {
      return true;
    }
    else
    {

    }*/
  }
}
public ComputeDiff()
{
  int TCount = GetTeamClientCount(CS_TEAM_T);
  int CTCount = GetTeamClientCount(CS_TEAM_CT);
  TCount = TCount - (TCount % 2);
  int CTAllowed = TCount / 2;
  if(CTCount > CTAllowed && TCount > 0 && CTCount > 0)
  {
    ScrambleCT();
    AllowCT = false;
  }
  else
  {
    AllowCT = true;
    if(B_Info) PrintToChatAll("%s Poměr je %.2f (optimum je 0.5)", PREFIX, float(CTCount) / float(TCount));
    B_Info = false;
  }
}

public ScrambleCT()
{
  int targetTime = 999999;
  int targetClient = -1;

  for(int i=1; i <= MaxClients; i++)
  {
    if(IsClientConnected(i) && GetClientTeam(i) == CS_TEAM_CT)
    {
      int time = RoundToNearest(GetClientTime(i));
      if(time < targetTime)
      {
        targetTime = time;
        targetClient = i;
      }
      /*if(GetUserAdmin(i)!= INVALID_ADMIN_ID)
      {
        targetClient = -99999;
      }
      else
      {

      }*/
    }
  }
  if(targetClient > 0 && IsClientInGame(targetClient))
  {
    SetEntProp(targetClient, Prop_Send, "m_lifeState", 2);
    ChangeClientTeam(targetClient, CS_TEAM_T);
    if(GetClientHealth(targetClient) > 0)
    {
      SetEntProp(targetClient, Prop_Send, "m_lifeState", 0);
    }
    P_Info[targetClient][1] = true;
    ComputeDiff();
  }
}

public ResetInfo()
{
  for(int i=1; i <= MaxClients; i++)
  {
    P_Info[i][0] = false;
    P_Info[i][1] = false;
  }
}

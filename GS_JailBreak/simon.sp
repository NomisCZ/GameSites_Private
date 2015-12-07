#pragma semicolon 1

#define TAG " [\x06JailBreak\x01]"

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>
#include <scp>
#include <smlib>
#include <emitsoundany>
#include <basecomm>

#include "simon/global.sp"
#include "simon/misc.sp"
#include "simon/menus.sp"
#include "simon/func.sp"
#include "simon/OnPlayerRunCmd.sp"
#include "simon/PP.sp"

public Plugin myinfo =
{
    name = "GameSites JailBreak",
    author = "ESK0",
    description = "",
    version = "1.0",
};
public OnPluginStart()
{
  RegConsoleCmd("sm_simon", EventCMD_Simon);
  RegConsoleCmd("sm_smenu", EventCMD_SMenu);

  RegConsoleCmd("sm_givem", EventCMD_Givem);
  RegConsoleCmd("sm_setm", EventCMD_setm);

  RegConsoleCmd("sm_gett", EventCMD_gett);
  RegConsoleCmd("sm_gatm", EventCMD_getm);

  RegConsoleCmd("sm_shop", EventCMD_Shop);

  RegConsoleCmd("sm_grab", EventCMD_Grab);
  RegConsoleCmd("sm_pp", EventCMD_PP);

  RegAdminCmd("sm_rsimon", EventCMD_RSimon, ADMFLAG_GENERIC);
  RegAdminCmd("sm_ssimon", EventCMD_SSimon, ADMFLAG_GENERIC);

  RegAdminCmd("sm_pauza", EventCMD_Pauza, ADMFLAG_GENERIC);

  RegAdminCmd("sm_getentinfo", EventCMD_GetEntityInfo, ADMFLAG_GENERIC);

  RegAdminCmd("sm_aopen", EventCMD_Open, ADMFLAG_GENERIC);

  HookEvent("player_death", Event_OnPlayerDeath);
  HookEvent("round_start", Event_OnRoundStart);
  HookEvent("round_end", Event_OnRoundEnd);
  HookEvent("player_spawn", Event_OnPlayerSpawn);
  HookEvent("player_team", Event_OnPlayerTeam);
  HookEvent("player_hurt", Event_OnPlayerHurt);
  HookEvent("bullet_impact",Event_OnBulletImpact);
  HookEvent("player_footstep", Evetn_OnPlayerFootStep);

  Box_Cvars[0] = FindConVar("ff_damage_reduction_bullets");
  Box_Cvars[1] = FindConVar("ff_damage_reduction_grenade");
  Box_Cvars[2] = FindConVar("ff_damage_reduction_grenade_self");
  Box_Cvars[3] = FindConVar("ff_damage_reduction_other");
  Box_Cvars[4] = FindConVar("mp_friendlyfire");

  MoneyHandle = RegClientCookie("GS_MoneyHandle", "", CookieAccess_Private);
  NoBlockOffSet = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
  char buffer[256];
  FormatTime(buffer,sizeof(buffer), "addons/sourcemod/logs_gs/%B");
  CreateDirectory("addons/sourcemod/logs_gs", 3);
  CreateDirectory(buffer, 3);
  FormatTime(buffer,sizeof(buffer), "logs_gs/%B/%d.%A.log");
  BuildPath(Path_SM, logfile, sizeof(logfile), buffer);
}
public OnGameFrame()
{
  if(GlobalFreeDay)
  {
    float timeleft = GlobalFreeDayStartTime - GetGameTime() + GlobalFreeDayTime;
    if(timeleft < 0.01)
    {
      GlobalFreeDay = false;
      EnableSimon();
      PrintHintTextToAll("<font color='#00FF00' size='30'>FREEDAY SKONČIL</font>\n<font color='#FFFFFF' size='15'>Vśichni vězni se dostaví před cely</font>", timeleft);
    }
  }
  if(simon == -1)
  {
    float timeleft = NoSimonVD - GetGameTime() + 30.0;
    //PrintToChatAll("%0.2f", timeleft);
    if(timeleft < 0.01 && b_NoSimonVD && !GlobalFreeDay)
    {
      b_NoSimonVD = false;
      PrintToChatAll("%s Nikdo si nevzal simona do 60 vteřin, Vězni mají 90 vteřin VD ", TAG);
      StartGlobalFreeDay(90.0);
      OpenJailDoors();
      DisableSimon();
    }
  }
  if(SchovkaOdpocet)
  {
    float timeleft = SchovkaStartTime - GetGameTime() + 30.0;
    if(timeleft > 0.01)
    {
      PrintHintTextToAll("<font color='#00FF00' size='20'>DOZORCI ZAČNOU HLEDAT</font>\n<font color='#FFFFFF' size='30'>ZA: %0.2f</font>", timeleft);
    }
    else if(timeleft < 0.01)
    {
      PrintHintTextToAll("<font color='#00FF00' size='20'>DOZORCI ZAČLI HLEDAT</font>");
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
        {
          BlindClient(i,0);
          SetEntityMoveType(i, MOVETYPE_WALK);
        }
      }
      SchovkaOdpocet = false;
      CreateTimer(7.0, Timer_Schovka);
    }
  }
  if(Stopky)
  {
    s_Timeleft = GetGameTime() - StopkyTime;
    if(s_Timeleft > 0.0)
    {
      PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZAPNUL STOPKY</font>\n<font color='#FFFFFF' size='30'>CAS: %0.2f</font>", s_Timeleft);
    }
  }
  if(Pauza)
  {
    float timeleft = PauzaTime - GetGameTime() + 1.0;
    if(timeleft < 0.0)
    {
      PrintHintTextToAll("<font color='#00FF00' size='30'>HRA BYLA POZASTAVENA</font>");
      int time = GameRules_GetProp("m_iRoundTime");
      GameRules_SetProp("m_iRoundTime", time+1, 4, 0, true);
      PauzaTime = GetGameTime();
    }

  }
}
public OnClientDisconnect(client)
{
  if(IsValidClient(client))
  {
    if(HasClientFreeDay(client)) RemoveClientFreeDay(client);
    if(IsClientSimon(client))
    {
      PrintHintTextToAll("<font color='#00FF00' size='30'>SIMON SE ODPOJIL</font>\n<font color='#FFFFFF' size='15'>Všechny příkazy a zákazy se ruší</font>");
      simon = -1;
      RemoveHandle(SimonColorFix);
    }
  }
}
public OnClientPutInServer(client)
{
  if(IsValidClient(client))
  {
    SetPlayerMoney(client, 6);
    SDKHook(client, SDKHook_SetTransmit, EventSDK_SetTransmit);
    SDKHook(client, SDKHook_WeaponCanUse, EventSDK_OnWeaponCanUse);
    SDKHook(client, SDKHook_OnTakeDamage, EventSDK_OnTakeDamage);
    if(IsClientAdmin(client)) BaseComm_SetClientMute(client, false);
    else BaseComm_SetClientMute(client, true);
  }
}
public OnMapStart()
{
  LoadSounds();
  char mapname[64];
  GetCurrentMap(mapname,sizeof(mapname));
  SetMapInfo(mapname);
  HookEntityOutput("func_button", "OnPressed", OnJailDoorOpenButtonPress);
  simon = -1;
  SimonColorFix = INVALID_HANDLE;
  Days = 0;
}
public OnMapEnd()
{
  RemoveHandle(SimonColorFix);
}
////////////// BUTTONS ///////////////////
public OnJailDoorOpenButtonPress(const char[] output,int caller,int activator, float delay)
{
  int HammerID = GetEntProp(caller, Prop_Data, "m_iHammerID");
  if(HammerID == CurrentJailDoorID)
  {
    GameEnabled = false;
    if(JailDoorsToggle)
    {
      if(!JailDoors)
      {
        PrintToChatAll("%s Cely byly otevřeny !", TAG);
        JailDoors = true;
      }
      else
      {
        PrintToChatAll("%s Cely byly zavřeny !", TAG);
        JailDoors = false;
      }
    }
    else
    {
      if(!JailDoors)
      {
        PrintToChatAll("%s Cely byly otevřeny !", TAG);
        JailDoors = true;
      }
    }
  }
  else if(HammerID == CurrentCloseJailDoorID)
  {
    if(JailDoors)
    {
      PrintToChatAll("%s Cely byly zavřeny !", TAG);
      JailDoors = false;
    }
  }
}
public OnJailDoorCloseButtonPress(const char[] output,int caller,int activator, float delay)
{
  if(!JailDoors)
  {
    OpenJailDoors();
    JailDoors = true;
  }
  else if(JailDoors && JailDoorsToggle)
  {
    OpenJailDoors(false);
    JailDoors = false;
  }

}
/////////// COMMANDS CALLBACKS ////////////
public Action EventCMD_Shop(int client,int args)
{
  if(IsValidClient(client))
  {
    if(IsPlayerAlive(client))
    {
      if(!PPEnabled)
      {
        if(GetClientTeam(client) == CS_TEAM_T) ShowTShop(client);
        if(GetClientTeam(client) == CS_TEAM_CT)
        {
          if(IsPlayerEVIP(client)) ShowCTShop(client);
          else PrintToChat(client, "%s Bohužel, nejsi EVIP", TAG);
        }
      }
      else PrintToChat(client, "%s Tento příkaz není dostupný při PP", TAG);
    }
    else
    {
      PrintToChat(client, "%s Tento příkaz je dostupný pouze pro živé hráče", TAG);
    }
  }
}
public Action EventCMD_Pauza(int client,int args)
{
  if(IsValidClient(client))
  {
    Pauza = !Pauza;
    LoopClients(i)
    {
      if(IsValidClient(i, true) && (GetClientTeam(i) == CS_TEAM_T || GetClientTeam(i) == CS_TEAM_CT) && !IsClientAdmin(i))
      {
        PauzaTime = GetGameTime();
        TeleportEntity(i, NULL_VECTOR, NULL_VECTOR,Float:{0.0, 0.0, 0.0});
        SetEntityMoveType(i,(Pauza)?MOVETYPE_NONE:MOVETYPE_WALK);
      }
    }
    if(!Pauza)
    {
      PrintHintTextToAll("<font color='#00FF00' size='30'>HRA BYLA OBNOVENA</font>");
    }
  }
  return Plugin_Handled;
}
public Action EventCMD_PP(int client, int args)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T) PP_Select(client);
}
public Action EventCMD_Grab(int client, int args)
{
  if(IsValidClient(client))
  {
    if(Grab[client])
    {
      //PrintToChatAll("%s Admin \x10%N\x01 pustil hráče \x10%N\x01 !!", TAG, client, GrabTarget[client]);
      Grab[client] = false;
      if(IsValidClient(GrabTarget[client], true))
      {
        char steamid[32];
        char steamid1[32];
        GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
        GetClientAuthId(GrabTarget[client], AuthId_Engine, steamid1, sizeof(steamid1));
        LogToFile(logfile, "Admin: %N (%s), UnGrabnul hráče: %N (%s)", client,steamid, GrabTarget[client],steamid1);
        SetEntityRenderColor(GrabTarget[client]);
        SetEntityMoveType(GrabTarget[client], MOVETYPE_WALK);
      }
      else
      {
        char classname[32];
        GetEntityClassname(GrabTarget[client], classname,sizeof(classname));
        char steamid[32];
        GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
        LogToFile(logfile, "Admin: %N (%s), UnGrabnul zbraň: %s", client,steamid, classname);
        TeleportEntity(GrabTarget[client], NULL_VECTOR, NULL_VECTOR,Float:{1.0, 1.0, 1.0});
        SetEntityMoveType(GrabTarget[client], MOVETYPE_VPHYSICS);
      }
      GrabTarget[client] = -1;
    }
    else
    {
      int target = GetClientAimTarget(client, false);
      if(IsValidEntity(target))
      {
        //PrintToChatAll("%s Admin \x10%N\x01 grabnul hráče \x10%N\x01 !!", TAG, client, target);
        char classname[32];
        GetEntityClassname(target, classname,sizeof(classname));
        if(StrEqual(classname, "player"))
        {
          char steamid[32];
          char steamid1[32];
          GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
          GetClientAuthId(target, AuthId_Engine, steamid1, sizeof(steamid1));
          LogToFile(logfile, "Admin: %N (%s), Grabnul hráče: %N (%s)", client,steamid, target,steamid1);
          GrabTarget[client] = target;
          Grab[client] = true;
          GrabNew[client] = true;
          GrabCanMove[client] = false;
          TeleportEntity(target, NULL_VECTOR, NULL_VECTOR,Float:{0.0, 0.0, 0.0});
          SetEntityMoveType(GrabTarget[client], MOVETYPE_VPHYSICS);
          SetEntityRenderColor(GrabTarget[client],0,255,0,255);
        }
        else
        {
          for(int wep; wep < sizeof(s_allweaponslist); wep++)
          {
            if(StrEqual(classname, s_allweaponslist[wep]))
            {
              char steamid[32];
              GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
              LogToFile(logfile, "Admin: %N (%s), Grabnul zbraň: %s", client,steamid, classname);
              GrabTarget[client] = target;
              Grab[client] = true;
              GrabNew[client] = true;
              GrabCanMove[client] = false;
              SetEntityMoveType(GrabTarget[client], MOVETYPE_VPHYSICS);
              break;
            }
          }
        }

      }
    }
  }
  return Plugin_Handled;
}
public Action EventCMD_Open(int client, int args)
{
  if(IsValidClient(client))
  {
    if(JailDoors)
    {
      JailDoors = false;
      OpenJailDoors(true);
      PrintToChatAll("%s Cely byly zavřeny !", TAG);
    }
    else
    {
      JailDoors = true;
      OpenJailDoors();
      PrintToChatAll("%s Cely byly otevřeny !", TAG);
    }
  }
  return Plugin_Handled;
}
public Action EventCMD_GetEntityInfo(int client, int args)
{
  if(IsValidClient(client))
  {
    char buffer[32];
    int target = GetClientAimTarget(client, false);
    if(IsValidEntity(target))
    {
      int hammerid = GetEntProp(target, Prop_Data, "m_iHammerID");
      GetEntPropString(target, Prop_Data, "m_iName", buffer, sizeof(buffer));
      PrintToChatAll("HammerID: %d, Name: %s",hammerid, (buffer[0] == 0) ? "none" : buffer);
    }
  }
  return Plugin_Handled;
}
public Action EventCMD_Givem(int client, int args)
{
  PrintToChatAll("Momentálně máš: %d",GetPlayerMoney(client));
  GivePlayerMoney(client, 800);
  PrintToChatAll("Dastal 800, Nyní máš: %d", GetPlayerMoney(client));
  return Plugin_Handled;
}
public Action EventCMD_setm(int client, int args)
{
  PrintToChatAll("Momentálně máš: %d",GetPlayerMoney(client));
  SetPlayerMoney(client, 80);
  PrintToChatAll("Nastavil jsem ti money na: %d",GetPlayerMoney(client));
  return Plugin_Handled;
}
public Action EventCMD_gett(int client, int args)
{
  int i = GetEntProp(client, Prop_Send, "m_iAccount");
  PrintToChatAll("%d",i);
  return Plugin_Handled;
}
public Action EventCMD_getm(int client, int args)
{
  PrintToChatAll("%d",GetPlayerMoney(client));
  return Plugin_Handled;
}
/////////////// CHAT TAG //////////////////
public Action OnChatMessage(&author, Handle recipients, char[] name, char[] message)
{
  if(IsValidClient(author) && IsClientSimon(author))
  {
    Format(name, MAXLENGTH_NAME, "\x07[SIMON] \x03%s", name);
    return Plugin_Changed;
  }
  return Plugin_Continue;
}
////////// HOOK EVENTS /////////////
public Action Event_OnRoundEnd(Handle event,const char[] name, bool dontBroadcast)
{
  int winner = GetEventInt(event, "winner");
  if(winner == CS_TEAM_T || winner == CS_TEAM_CT)
  {
    EmitSoundToAllAny(ROUNDEND);
  }
}
public Action Event_OnPlayerTeam(Handle event,const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsValidClient(client))
  {
    SetPlayerMoney(client, 6);
  }
}
public Action Event_OnPlayerHurt(Handle event, const char[] name, bool dontBroadcast)
{
  char weapon[32];
  int victim = GetClientOfUserId(GetEventInt(event, "userid"));
  int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  GetEventString(event, "weapon", weapon, sizeof(weapon));
  if(IsValidClient(victim, true) && IsValidClient(attacker, true))
  {
    if(Schovka)
    {
      if(GetClientTeam(victim) == CS_TEAM_CT && GetClientTeam(attacker) == CS_TEAM_T)
      {
        if(StrEqual(weapon,"flashbang",false) == true)
  			{
          SetEntityHealth(victim, 0);
  			}
      }
    }
    if(GetClientTeam(victim) == CS_TEAM_CT && GetClientTeam(attacker) == CS_TEAM_T)
    {
      if(!Alarm && !SimonDisabled)
      {
        Alarm = true;
        EmitSoundToAllAny(VZPOURA);
        CreateTimer(7.0, Timer_EnableAlarm);
      }
      AutoBhop = false;
      GameEnabled = false;
    }
  }
}
public Action Event_OnBulletImpact(Handle event,const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    float Origin[3];
    GetClientEyePosition(client, Origin);
    float Impact[3];
    Impact[0] = GetEventFloat( event, "x" );
    Impact[1] = GetEventFloat( event, "y" );
    Impact[2] = GetEventFloat( event, "z" );
    if (GetClientButtons(client) & IN_USE)
    {
      LightCreate(Impact, true);
    }
  }
}
public Action Evetn_OnPlayerFootStep(Handle event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsValidClient(client, true) && IsClientSimon(client) && StopySimona)
  {
    Stopy++;
    if(Stopy == 2)
    {
      float absorg[3];
      GetClientAbsOrigin(client, absorg);
      LightCreate(absorg);
      Stopy = 0;
    }
  }
}
public Action Event_OnPlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  if(IsValidClient(client))
  {
    ClientKnifeDamage[client] = DMG_NONE;
    Grab[client] = false;
    if(IsValidClient(GrabTarget[client], true)) SetEntityMoveType(GrabTarget[client], MOVETYPE_WALK);
    GrabTarget[client] = -1;
    SetEntityRenderMode(client, RENDER_TRANSTEXTURE);
    SetPlayerMoney(client, GetPlayerMoney(client));
  }
}
public Action Event_OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(GetEventInt(event, "userid"));
  int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
  if(!PPEnabled)
  {
    if(IsValidClient(client))
    {
      if(Schovka || !SimonDisabled)
      {
        Schovka = false;
        if(CountPlayersInTeam(CS_TEAM_T, true) == 1)
        {
          DisableSimon();
          PPEnabled = true;
          PrintToChatAll("%s PP Dostupné! Zvolíš si ho napsáním \x10/pp\x01 !",TAG);
        }
      }
      if(HasClientFreeDay(client)) RemoveClientFreeDay(client);
      if(IsClientSimon(client))
      {
        RemoveHandle(SimonColorFix);
        CS_SetClientClanTag(client, "");
        PrintHintTextToAll("<font color='#00FF00' size='30'>SIMON BYL ZABIT</font><br><font color='#FFFFFF' size='20'>Všechny příkazy a zákazy se ruší</font>");
        simon = -1;
        AutoBhop = false;
      }
    }
  }
  else
  {
    if(IsValidClient(client))
    {
      if(client == PP_Guard && CountPlayersInTeam(CS_TEAM_CT, true) >= 1)
      {
        DisableSimon();
        PPActive = false;
        PPAvailable = true;
        PrintToChatAll("%s PP Dostupné! Zvolíš si ho napsáním \x10/pp\x01 !",TAG);
        if(IsValidClient(attacker, true))
        {
          StripWeapons(attacker);
          SetEntityHealth(attacker, 100);
        }
      }
    }
  }
  LoopClients(i)
  {
    if(IsValidClient(i, true) && IsValidClient(client) && client == GrabTarget[i] && Grab[i])
    {
      char steamid[32];
      char steamid1[32];
      GetClientAuthId(i, AuthId_Engine, steamid, sizeof(steamid));
      GetClientAuthId(GrabTarget[i], AuthId_Engine, steamid1, sizeof(steamid1));
      Grab[i] = false;
      LogToFile(logfile, "Admin: %N (%s), Zabil v grabu hráče: %N (%s)", i,steamid, GrabTarget[i],steamid1);
      GrabTarget[i] = -1;
    }
  }
}
public Action Event_OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
  SetCvar("sv_enablebunnyhopping", "1");
  SetCvar("sv_staminamax", "0");
  SetCvar("sv_airaccelerate", "2000");
  SetCvar("sv_staminajumpcost", "0");
  SetCvar("sv_staminalandcost", "0");
  PPEnabled = false;
  PPAvailable = true;
  PPActive = false;
  PP_Chosen = -1;
  //Noblock = false;
  Schovka = false;
  Alarm = false;
  AutoBhop = false;
  SchovkaOdpocet = false;
  Stopky = false;
  Mic = false;
  JailDoors = false;
  GlobalFreeDay = false;
  StopySimona = false;
  Fotbal = false;
  SimonDisabled = false;
  GameEnabled = true;
  b_NoSimonVD = false;
  RemoveAllFreeDays();
  Days++;
  GameRules_SetProp("m_iRoundTime", (60*15), 4, 0, true);
  LoopClients(i)
  {
    ClientKnifeDamage[i] = DMG_NONE;
    if(IsValidClient(i))
    {
      if(i == PP_FreeDay)
      {
        PrintToChatAll("%s Hráč \x10%N\x01 má FreeDay, jelikož si ho minulé kolo vybral jako PP!",TAG, i);
        GiveClientFreeDay(i,90.0);
        PP_FreeDay = -1;
      }
      HealthBought[i] = false;
      WeaponChooseAllowed[i] = true;
      IsClientInvisible[i] = false;
      CS_SetClientClanTag(i, "");
      SetEntityGravity(i, 1.0);

      if(IsPlayerAlive(i))
      {
        if(GetClientTeam(i) == CS_TEAM_T) ShowMainMenu(i);
        else if(GetClientTeam(i) == CS_TEAM_CT) ShowMainMenu(i);
      }
    }
  }
  PP_Guard = -1;
  PP_Prisoner = -1;
  simon = -1;
  if(PrestrelkaEnable)
  {
    PrestrelkaEnable = false;
    Format(Prestrelka_Wep,sizeof(Prestrelka_Wep), "");
  }
  if(MatrixEnable)
  {
    MatrixEnable = false;
    LoopClients(i)
    {
      if(IsValidClient(i))
      {
        Format(MatrixClientWeapon[i], sizeof(MatrixClientWeapon), "");
      }
    }
  }

  if(BoxRestrict)
  {
    DisableBox();
    BoxRestrict = false;
  }
  if(Box)
  {
    DisableBox();
    Box = false;
  }
  LoopClients(i)
  {
    if(IsValidClient(i))
    {
      if(GetClientTeam(i) == CS_TEAM_T)
      {
        if(IsClientAdmin(i)) BaseComm_SetClientMute(i, false);
        else BaseComm_SetClientMute(i, true);
      }
      else if(GetClientTeam(i) == CS_TEAM_CT) BaseComm_SetClientMute(i, false);
      else
      {
        if(GetClientTeam(i) == CS_TEAM_SPECTATOR)
        {
          if(IsClientAdmin(i)) BaseComm_SetClientMute(i, false);
          else BaseComm_SetClientMute(i, true);
        }
      }
    }
  }
  PrintToChatAll("%s Právě začalo %d. kolo",TAG,Days);
  /*if (GetRandomInt(1,100) < 10 || Days == 1 || Days == 2 || CountPlayersInTeam(CS_TEAM_CT) <= 0)
  {
    DisableSimon();
    OpenJailDoors();
    PrintToChatAll("%s Toto kolo je Volný den. Volný den trvá pouze 150 sekund!",TAG);
    StartGlobalFreeDay();
  }
  if(!GlobalFreeDay)
  {
    b_NoSimonVD = true;
    NoSimonVD = GetGameTime();
  }*/
  if(CountPlayersInTeam(CS_TEAM_T, true) == 1)
  {
    DisableSimon();
    PPEnabled = true;
    PrintToChatAll("%s PP Dostupné! Zvolíš si ho napsáním \x10/pp\x01 !",TAG);
  }
}
public Action EventCMD_SMenu(int client, int args)
{
  if(IsValidClient(client))
  {
    if(IsClientSimon(client)) SMenu(client);
    else PrintToChat(client, "%s Tento příkaz je dostupný pouze pro simona", TAG);
  }
}
public Action EventCMD_SSimon(int client, int args)
{
  if(IsValidClient(client))
  {
    if(ExistSimon()) PrintToChat(client, "%s Simon již existuje!", TAG);
    else
    {
      Menu SSimon = CreateMenu(h_SSimon);
      SSimon.SetTitle("Zvol hráče");
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
        {
          char userid[32];
          char username[MAX_NAME_LENGTH];
          GetClientName(i,username,sizeof(username));
          IntToString(GetClientUserId(i), userid,sizeof(userid));
          SSimon.AddItem(userid, username);
        }
      }
      SSimon.ExitButton = true;
      SSimon.Display(client,MENU_TIME_FOREVER);
    }
  }
  return Plugin_Handled;
}
public h_SSimon(Menu SSimon, MenuAction action, client, Position)
{
  if(action == MenuAction_Select)
  {
    char Item[32];
    char userid[32];
    SSimon.GetItem(Position, Item,sizeof(Item));
    LoopClients(i)
    {
      if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
      {
        IntToString(GetClientUserId(i), userid,sizeof(userid));
        if(StrEqual(Item, userid))
        {
          simon = i;
          PrintToChatAll("%s Admin \x10%N\x01 vybral \x10%N\x01 jako simona", TAG,client, simon);
          SetEntityRenderColor(simon, 0,0,255,255);
          CS_SetClientClanTag(simon, "[SIMON]");
          SimonColorFix = CreateTimer(2.0, Timer_SimonColorFix, GetClientUserId(simon),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
          SMenu(simon);
        }
      }
    }
  }
}
public Action EventCMD_RSimon(int client, int args)
{
  if(IsValidClient(client))
  {
    if(ExistSimon())
    {
      PrintToChatAll("%s Admin \x10%N\x01 vyhodil simona \x10%N\x01 z funkce", TAG, client, simon);
      CS_SetClientClanTag(simon, "");
      SetEntityRenderColor(simon);
      simon = -1;
    }
    else
    {
      PrintToChat(client, "%s Momentálně zde není žádný simon !", TAG);
    }
  }
  return Plugin_Handled;
}
public Action EventCMD_Simon(int client, int args)
{
  if(!SimonDisabled || !PPEnabled)
  {
    if(IsValidClient(client))
    {
      if(GetClientTeam(client) == CS_TEAM_CT)
      {
        if(!ExistSimon())
        {
          if(IsPlayerAlive(client))
          {
            CreateSimon(client);
          }
          else
          {
            PrintToChat(client, "%s Simonem se může stát pouze živý policisté", TAG);
          }
        }
        else
        {
          if(IsClientSimon(client)) SMenu(client);
          else PrintToChat(client, "%s Simon nyní je: %N", TAG, simon);
        }
      }
      else
      {
        PrintToChat(client, "%s Simonem se můžou stát pouze policisté", TAG);
      }
    }
  }
  return Plugin_Handled;
}
public CreateSimon(client)
{
  if(IsValidClient(client, true))
  {
    simon = client;
    PrintHintTextToAll("<font color='#FFFFFF' size='20'>%N</font><br><font color='#00FF00' size='30'>JE NYNI SIMON</font>", client);
    PrintToChatAll("*\x09%N je simon! Všichni poslouchají!", client);
    PrintToChatAll("*\x09%N je simon! Všichni poslouchají!", client);
    PrintToChatAll("*\x09%N je simon! Všichni poslouchají!", client);
    PrintToChatAll("*\x09%N je simon! Všichni poslouchají!", client);
    SetEntityRenderColor(client, 0,0,255,255);
    CS_SetClientClanTag(client, "[SIMON]");
    SMenu(client);
    SimonColorFix = CreateTimer(2.0, Timer_SimonColorFix, GetClientUserId(client),TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }
}
public Action Timer_EnableAlarm(Handle timer)
{
  if(Alarm) Alarm = false;
  else return Plugin_Stop;
  return Plugin_Continue;
}
public Action Timer_SimonColorFix(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    if(IsClientSimon(client))
    {
      CS_SetClientClanTag(client, "[SIMON]");
      SetEntityRenderColor(client, 0,0,255,255);
    }
    else return Plugin_Stop;
  }
  else  return Plugin_Stop;
  return Plugin_Continue;
}
public Action Timer_DeleteLight(Handle timer,any index)
{
	if(IsValidEntity(index))
	{
		AcceptEntityInput(index, "Kill");
	}
}
public Action Timer_Schovka(Handle timer)
{
  if(Schovka)
  {
    LoopClients(i)
    {
      if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T)
      {
        GivePlayerItem(i, "weapon_flashbang");
      }
    }
  }
  else return Plugin_Stop;
  return Plugin_Continue;
}
public Action EventSDK_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3])
{
  char s_weapon[32];
  if(IsValidEntity(weapon))
  {
    GetEntityClassname(weapon, s_weapon,sizeof(s_weapon));
  }
  if(!PPEnabled)
  {
    if(BoxRestrict)
    {
      if(IsValidClient(attacker, true) && IsValidClient(victim, true))
      {
        if(StrEqual(s_weapon, "weapon_knife"))
        {
          return Plugin_Continue;
        }
        else return Plugin_Handled;
      }
    }
    if(IsValidClient(attacker, true) && IsClientSimon(attacker))
    {
      if(GetClientButtons(attacker) & IN_USE)
      {
        return Plugin_Handled;
      }
    }
    if(IsValidClient(attacker, true) && IsValidClient(victim, true))
    {
      if(StrEqual(s_weapon, "weapon_knife"))
      {
        if(damage < 100 && GetClientTeam(attacker) == CS_TEAM_T)
        {
          damage = float(ClientKnifeDamage[attacker]);
          return Plugin_Changed;
        }
      }
      if(Grab[attacker] && (victim == GrabTarget[attacker] || attacker == GrabTarget[attacker]))
      {
        return Plugin_Handled;
      }
    }
    if(SchovkaOdpocet)
    {
      if(GetClientTeam(attacker) == CS_TEAM_T && GetClientTeam(victim) == CS_TEAM_CT) return Plugin_Handled;
    }
    if(Pauza) return Plugin_Handled;
  }
  else
  {
    if(victim != attacker && IsValidClient(victim, true) && IsValidClient(attacker, true) && victim == PP_Guard || victim == PP_Prisoner && attacker == PP_Guard || attacker == PP_Prisoner)
    {
      return Plugin_Continue;
    }
    else if(IsValidClient(victim, true) && IsValidClient(attacker, true) && PP_Chosen == PP_PROTIVSEM)
    {
      return Plugin_Continue;
    }
    else return Plugin_Handled;
  }
  return Plugin_Continue;
}
public Action EventSDK_SetTransmit(entity, client)
{
  if(IsClientInvisible[entity])
  {
    if(entity != client)
    {
      return Plugin_Handled;
    }
  }
  return Plugin_Continue;
}
public Action EventSDK_OnWeaponCanUse(client, weapon)
{
  if(IsValidEntity(weapon))
  {
    char s_weapon[32];
    GetEntityClassname(weapon, s_weapon, sizeof(s_weapon));
    if(IsValidClient(client, true))
    {
      if(GetClientTeam(client) == CS_TEAM_T)
      {
        if(StrEqual(s_weapon, "weapon_smokegrenade"))
        {
          return Plugin_Handled;
        }
      }
      else if(GetClientTeam(client) == CS_TEAM_CT)
      {
        if(StrEqual(s_weapon, "weapon_smokegrenade")) return Plugin_Handled;
        else if(StrEqual(s_weapon, "weapon_hegrenade")) return Plugin_Handled;
        else if(StrEqual(s_weapon, "weapon_decoy")) return Plugin_Handled;
        else if(StrEqual(s_weapon, "weapon_molotov")) return Plugin_Handled;
        else if(StrEqual(s_weapon, "weapon_incgrenade")) return Plugin_Handled;
      }
    }
    if(Schovka)
    {
      if(GetClientTeam(client) == CS_TEAM_T)
      {
        if(StrEqual(s_weapon, "weapon_flashbang") == false) return Plugin_Handled;
      }
    }
    if(PrestrelkaEnable)
    {
      if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
      {
        if(StrEqual(Prestrelka_Wep, ""))
        {
          return Plugin_Continue;
        }
        else if(StrEqual(Prestrelka_Wep, s_weapon))
        {
          return Plugin_Continue;
        }
        else if(StrEqual(Prestrelka_Wep, s_weapon))
        {
          return Plugin_Continue;
        }
        else
        {
          return Plugin_Handled;
        }
      }
    }
    else if(MatrixEnable)
    {
      if(GetClientTeam(client) == CS_TEAM_T && IsValidClient(client, true))
      {
        if(StrEqual(s_weapon, MatrixClientWeapon[client])) return Plugin_Continue;
        else return Plugin_Handled;
      }
      return Plugin_Continue;
    }
  }
  return Plugin_Continue;
}

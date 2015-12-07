public PP_Select(int client)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
  {
    if(PPEnabled)
    {
      if(PPAvailable)
      {
        Menu PPMenu = CreateMenu(h_PPMenu);
        PPMenu.SetTitle("Poslední přání");
        PPMenu.AddItem("freeday","Volný den");
        PPMenu.AddItem("vsguards","Proti všem dozorcům");
        PPMenu.AddItem("armagedon","Armagedon");
        PPMenu.AddItem("deagle","Deagle");
        PPMenu.AddItem("scout","Scout");
        PPMenu.AddItem("awp","AWP");
        PPMenu.ExitButton = true;
        PP_Prisoner = client;
        PPMenu.Display(client, MENU_TIME_FOREVER);
      }
      else
      {
        PrintToChat(client, "%s Poslední přání právě probíhá", TAG);
      }
    }
    else
    {
      PrintToChat(client, "%s Poslední přání není dostupné", TAG);
    }
  }
}
public h_PPMenu(Menu PPMenu, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
  {
    if(action == MenuAction_Select)
    {
      CreateTimer(1.0, TimerPP_TakeHP, _,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
      char Item[32];
      PPMenu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "freeday"))
      {
        PP_Chosen = PP_FREEDAY;
        PP_Start();
      }
      else if(StrEqual(Item, "vsguards"))
      {
        PP_Chosen = PP_PROTIVSEM;
        PP_Start();
      }
      else if(StrEqual(Item, "armagedon"))
      {
        PP_Chosen = PP_ARMAGEDON;
        PP_SelectGuard(PP_Prisoner);
      }
      else if(StrEqual(Item, "deagle"))
      {
        PP_Chosen = PP_DEAGLE;
        PP_SelectGuard(PP_Prisoner);
      }
      else if(StrEqual(Item, "scout"))
      {
        PP_Chosen = PP_SCOUT;
        PP_SelectGuard(PP_Prisoner);
      }
      else if(StrEqual(Item, "awp"))
      {
        PP_Chosen = PP_AWP;
        PP_SelectGuard(PP_Prisoner);
      }
    }
  }
}
public Action TimerPP_TakeHP(Handle timer)
{
  if(PPActive)
  {
    if(IsValidClient(PP_Guard, true)) ((GetClientHealth(PP_Guard) -1) < 0) ? SetEntityHealth(PP_Guard, GetClientHealth(PP_Guard)-1) : ForcePlayerSuicide(PP_Guard);
    else return Plugin_Stop;

    if(IsValidClient(PP_Prisoner, true)) ((GetClientHealth(PP_Prisoner) -1) < 0) ? SetEntityHealth(PP_Prisoner, GetClientHealth(PP_Prisoner)-1) : ForcePlayerSuicide(PP_Prisoner);
    else return Plugin_Stop;

    CreateTimer(1.0, TimerPP_TakeHP, _,TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
  }
  else return Plugin_Stop;
  return Plugin_Continue;
}
public PP_SelectGuard(int client)
{
  if(IsValidClient(client, true))
  {
    Menu PPSelectGuard = CreateMenu(h_PPSelectGuard);
    PPSelectGuard.SetTitle("Zvol dozorce");
    LoopClients(i)
    {
      if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
      {
        char userid[32];
        char username[MAX_NAME_LENGTH];
        GetClientName(i,username,sizeof(username));
        IntToString(GetClientUserId(i), userid,sizeof(userid));
        PPSelectGuard.AddItem(userid, username);
      }
    }
    PPSelectGuard.ExitBackButton = true;
    PPSelectGuard.Display(client, MENU_TIME_FOREVER);
  }
}
public h_PPSelectGuard(Menu PPSelectGuard, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
  {
    if(action == MenuAction_Select)
    {
      char Item[32];
      char userid[32];
      PPSelectGuard.GetItem(Position, Item,sizeof(Item));
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
        {
          IntToString(GetClientUserId(i), userid,sizeof(userid));
          if(StrEqual(Item, userid))
          {
            PP_Guard = i;
            break;
          }
        }
      }
      PP_Start();
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        PP_Select(client);
      }
    }
  }
}
public PP_Start()
{
  if(IsValidClient(PP_Prisoner, true) && PPEnabled)
  {
    SetEntityHealth(PP_Prisoner, 100);
    if(IsValidClient(PP_Guard, true)) SetEntityHealth(PP_Guard, 100);
    if(PP_Chosen == PP_FREEDAY)
    {
      PP_FreeDay = PP_Prisoner;
      PrintToChatAll("%s Hráč \x10%N\x01 si zvolil Volný den jako PP !", TAG, PP_Prisoner);
      ForcePlayerSuicide(PP_Prisoner);
    }
    else if(PP_Chosen == PP_PROTIVSEM)
    {
      PPAvailable = false;
      int ctcount = CountPlayersInTeam(CS_TEAM_CT, true);
      if(ctcount > 3)
      {
        SetEntityHealth(PP_Prisoner,ctcount*40);
      }
      else SetEntityHealth(PP_Prisoner, 100);
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_CT)
        {
          StripWeapons(i);
          GivePlayerItem(i, "weapon_deagle");
        }
      }
      StripWeapons(PP_Prisoner);
      int rand = GetRandomInt(1,3);
      switch (rand)
      {
        case 1: GivePlayerItem(PP_Prisoner, "weapon_m4a1");
        case 2: GivePlayerItem(PP_Prisoner, "weapon_ak47");
        case 3: GivePlayerItem(PP_Prisoner, "weapon_ump45");
      }
    }
    else if(PP_Chosen == PP_ARMAGEDON)
    {
      PPAvailable = false;
      PP_StartWithWeapon("weapon_negev", 1250);
    }
    else if(PP_Chosen == PP_DEAGLE)
    {
      PPAvailable = false;
      PP_StartWithWeapon("weapon_deagle");
    }
    else if(PP_Chosen == PP_SCOUT)
    {
      PPAvailable = false;
      PP_StartWithWeapon("weapon_ssg08");
    }
    else if(PP_Chosen == PP_AWP)
    {
      PPAvailable = false;
      PP_StartWithWeapon("weapon_awp");
    }
  }
}

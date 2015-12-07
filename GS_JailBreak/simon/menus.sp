public ShowSkinMenu(int client)
{
  if(IsValidClient(client, true) && !PPEnabled)
  {
    Menu SkinMenu = CreateMenu(h_SkinMenu);
    SkinMenu.SetTitle("Vyber vzhledu");
    SkinMenu.AddItem("vipmodel","VIP skin");
    SkinMenu.AddItem("nonvip","Normální skin");
    SkinMenu.ExitButton = true;
    SkinMenu.Display(client,MENU_TIME_FOREVER);
  }
}
public h_SkinMenu(Menu SkinMenu, MenuAction action, client, Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      SkinMenu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "vipmodel"))
      {

      }
      else if(StrEqual(Item, "nonvip"))
      {

      }
    }
  }
}
public ShowMainMenu(int client)
{
  if(IsValidClient(client, true) && !PPEnabled)
  {
    Menu MainMenu = CreateMenu(h_MainMenu);
    MainMenu.SetTitle("Hlavní menu");
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      MainMenu.AddItem("ctevipshop","Herní obchod pro EVIP",IsPlayerEVIP(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
      MainMenu.AddItem("ctvzhled","Vybrat vzhled", IsPlayerVIP(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
      MainMenu.AddItem("pravidla","Pravidla");
    }
    else if(GetClientTeam(client) == CS_TEAM_T)
    {
      MainMenu.AddItem("tshop","Herní obchod");
      MainMenu.AddItem("tvzhled","Vybrat vzhled", IsPlayerVIP(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
      MainMenu.AddItem("pravidla","Pravidla");
    }
    MainMenu.ExitButton = true;
    MainMenu.Display(client,MENU_TIME_FOREVER);
  }
}
public h_MainMenu(Menu MainMenu, MenuAction action, client, Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      MainMenu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "ctevipshop")) ShowCTShop(client);
      else if(StrEqual(Item, "tshop")) ShowTShop(client);
      else if(StrEqual(Item, "ctvzhled")){}
      else if(StrEqual(Item, "tvzhled")){}
      else if(StrEqual(Item, "pravidla")) ShowMOTDPanel(client, "www.GameSites.cz", "http://fastdl.gamesites.cz/global/motd/pravidla_jb.html", MOTDPANEL_TYPE_URL);
    }
  }
}
public ShowTShop(int client)
{
  if(!PPEnabled)
  {
    char buffer[32];
    Menu TShop = CreateMenu(h_TShop);
    Format(buffer,sizeof(buffer), "T Obchod [%d$]", GetPlayerMoney(client));
    TShop.SetTitle(buffer);
    Format(buffer,sizeof(buffer), "Gut Knife [%d$]", TSHOP_GUTCOST);
    if(ClientKnifeDamage[client] != DMG_GUT)
    {
      TShop.AddItem("gut", buffer, (GetPlayerMoney(client) < TSHOP_GUTCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    else TShop.AddItem("gut", buffer, ITEMDRAW_DISABLED);
    Format(buffer,sizeof(buffer), "Bayonet Knife [%d$]", TSHOP_BAYONETCOST);
    if(ClientKnifeDamage[client] != DMG_BAYONET)
    {
      TShop.AddItem("bayonet", buffer, (GetPlayerMoney(client) < TSHOP_BAYONETCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    else TShop.AddItem("bayonet", buffer, ITEMDRAW_DISABLED);
    Format(buffer,sizeof(buffer), "Flip Knife [%d$]", TSHOP_FLIPCOST);
    if(ClientKnifeDamage[client] != DMG_FLIP)
    {
      TShop.AddItem("flip", buffer, (GetPlayerMoney(client) < TSHOP_FLIPCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    else TShop.AddItem("flip", buffer, ITEMDRAW_DISABLED);
    Format(buffer,sizeof(buffer), "Rychlost [%d$]", TSHOP_RYCHLOSTCOST);
    TShop.AddItem("speed", buffer, (GetPlayerMoney(client) < TSHOP_RYCHLOSTCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Volný den [%d$]", TSHOP_VOLNYDENCOST);
    TShop.AddItem("freeday", buffer, (GetPlayerMoney(client) < TSHOP_VOLNYDENCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Neviditelnost [%d$]", TSHOP_NEVIDITELNOSTCOST);
    TShop.AddItem("invisible", buffer, (GetPlayerMoney(client) < TSHOP_NEVIDITELNOSTCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Loterie [%d$]", TSHOP_LOTERIECOST);
    TShop.AddItem("loterie", buffer, (GetPlayerMoney(client) < TSHOP_LOTERIECOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Granáty [%d$]", TSHOP_GRANATYCOST);
    TShop.AddItem("granaty", buffer, (GetPlayerMoney(client) < TSHOP_GRANATYCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Převlek dozorce [%d$]", TSHOP_DOZORCECOST);
    TShop.AddItem("dozorce", buffer, (GetPlayerMoney(client) < TSHOP_DOZORCECOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    TShop.ExitButton = true;
    TShop.Display(client,MENU_TIME_FOREVER);
  }
  else PrintToChat(client, "%s Shop není dostupný!", TAG);

}
public h_TShop(Menu TShop, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T && !PPEnabled)
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      TShop.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "gut"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_GUTCOST);
        ClientKnifeDamage[client] = DMG_GUT;
      }
      else if(StrEqual(Item, "bayonet"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_BAYONETCOST);
        ClientKnifeDamage[client] = DMG_BAYONET;
      }
      else if(StrEqual(Item, "flip"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_FLIPCOST);
        ClientKnifeDamage[client] = DMG_FLIP;
      }
      else if(StrEqual(Item, "speed"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_RYCHLOSTCOST);
        SetClientSpeed(client,1.4);
      }
      else if(StrEqual(Item, "loterie"))
      {
        int rand = GetRandomInt(0,30);
        PrintToChat(client, "%s Vyhrál jsi v loterii \x10%d$!!", TAG, rand);
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_LOTERIECOST+rand);
      }
      else if(StrEqual(Item, "granaty"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_GRANATYCOST);
        GivePlayerItem(client, "weapon_flashbang");
        GivePlayerItem(client, "weapon_flashbang");
        GivePlayerItem(client, "weapon_hegrenade");
      }
      else if(StrEqual(Item, "invisible"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_NEVIDITELNOSTCOST);
        IsClientInvisible[client] = true;
        ClientInvisibleStartTime[client] = GetGameTime();
      }
      else if(StrEqual(Item, "freeday"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_VOLNYDENCOST);
        PrintToChatAll("%s Hráči %N si zakoupil volný den a celé kolo nemusí poslouchat Simona!", TAG, client);
        GiveClientFreeDay(client, -1.0);
      }
      else if(StrEqual(Item, "dozorce"))
      {
        SetPlayerMoney(client, GetPlayerMoney(client)-TSHOP_DOZORCECOST);
        //SetEntityModel(client, "");
        int wep = GivePlayerItem(client,"weapon_m4a1");
        Weapon_SetAmmoCounts(wep,1,0);
      }
    }
  }
}
public ShowCTShop(int client)
{
  if(!PPEnabled)
  {
    char buffer[32];
    Menu CTShop = CreateMenu(h_CTShop);
    Format(buffer,sizeof(buffer), "CT Obchod [%d$]", GetPlayerMoney(client));
    CTShop.SetTitle(buffer);
    CTShop.AddItem("selectwep", "Výběr zbraně",WeaponChooseAllowed[client]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
    Format(buffer,sizeof(buffer), "Život [%d$]",CTSHOP_ZIVOTYCOST);
    if(GetPlayerMoney(client) >= CTSHOP_ZIVOTYCOST)
    {
      if(!HealthBought[client]) CTShop.AddItem("health", buffer);
      else CTShop.AddItem("health", buffer, ITEMDRAW_DISABLED);
    }
    else CTShop.AddItem("health", buffer, ITEMDRAW_DISABLED);
    Format(buffer,sizeof(buffer), "Gravitace [%d$]",CTSHOP_GRAVITACECOST);
    CTShop.AddItem("gravity", buffer, (GetPlayerMoney(client) < CTSHOP_GRAVITACECOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    Format(buffer,sizeof(buffer), "Rychlost [%d$]",CTSHOP_SPEEDCOST);
    CTShop.AddItem("speed", buffer, (GetPlayerMoney(client) < CTSHOP_SPEEDCOST)?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    CTShop.ExitButton = true;
    CTShop.Display(client,MENU_TIME_FOREVER);
  }
  else PrintToChat(client, "%s Shop není dostupný!", TAG);

}
public h_CTShop(Menu CTShop, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_CT && !PPEnabled)
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      CTShop.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "selectwep")) WepMenu(client);
      else if(StrEqual(Item, "health"))
      {
        HealthBought[client] = true;
        SetEntityHealth(client, 150);
        SetPlayerMoney(client, GetPlayerMoney(client)-CTSHOP_ZIVOTYCOST);
      }
      else if(StrEqual(Item, "gravity"))
      {
        SetEntityGravity(client, 0.6);
        SetPlayerMoney(client, GetPlayerMoney(client)-CTSHOP_GRAVITACECOST);
      }
      else if(StrEqual(Item, "speed"))
      {
        SetClientSpeed(client,1.5);
        SetPlayerMoney(client, GetPlayerMoney(client)-CTSHOP_SPEEDCOST);
      }
    }
  }
}
public SMenu(int client)
{
  char buffer[32];
  Menu SimonMenu = CreateMenu(h_SMenu);
  SimonMenu.SetTitle("Simon Menu");
  SimonMenu.AddItem("selectwep", "Vybrat zbraň",(WeaponChooseAllowed[client])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer,sizeof(buffer), "%s", (JailDoors) ? "Zavřít cely":"Otevřít cely");
  SimonMenu.AddItem("openjail", buffer);
  if(CountPlayersInTeam(CS_TEAM_T, true) > 0) SimonMenu.AddItem("freeday", "Dát volný den");
  else SimonMenu.AddItem("freeday", "Dát volný den", ITEMDRAW_DISABLED);
  SimonMenu.AddItem("gamemodes", "Herní módy");
  SimonMenu.AddItem("others", "Ostatní");
  SimonMenu.ExitButton = true;
  SimonMenu.Display(client, MENU_TIME_FOREVER);
}
public h_SMenu(Menu SimonMenu, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      SimonMenu.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "selectwep")) WepMenu(client);
      else if(StrEqual(Item, "openjail")) OpenJail(client);
      else if(StrEqual(Item, "armory"))
      {
        int entity = -1;
        for(int i; i < sizeof(DoorTypes); i++)
        {
          while ((entity = FindEntityByClassname(entity, DoorTypes[i])) != INVALID_ENT_REFERENCE)
          {
            int hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
            if(hammerid == CurrentArmoryDoorID)
            {
              AcceptEntityInput(entity, "Toggle", -1, -1);
            }
          }
        }
        SMenu(client);
      }
      else if(StrEqual(Item, "freeday")) DatFreeDay(client);
      else if(StrEqual(Item, "gamemodes")) GameMenu(client);
      else if(StrEqual(Item, "others")) OtherMenu(client);
    }
  }
}
public DatFreeDay(int client)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    Menu FreeDay = CreateMenu(h_FreeDay);
    FreeDay.SetTitle("Dát volný den hráči");
    LoopClients(i)
    {
      if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T && !HasClientFreeDay(i))
      {
        char userid[32];
        char username[MAX_NAME_LENGTH];
        GetClientName(i,username,sizeof(username));
        IntToString(GetClientUserId(i), userid,sizeof(userid));
        FreeDay.AddItem(userid, username);
      }
    }
    FreeDay.ExitBackButton = true;
    FreeDay.Display(client,MENU_TIME_FOREVER);
  }
}
public h_FreeDay(Menu FreeDay, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[32];
      char userid[32];
      FreeDay.GetItem(Position, Item,sizeof(Item));
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T && !HasClientFreeDay(i))
        {
          IntToString(GetClientUserId(i), userid,sizeof(userid));
          if(StrEqual(Item, userid))
          {
            char buffer[6];
            if(IsClientAdmin(client)) Format(buffer,sizeof(buffer), "Admin");
            if(IsClientSimon(client)) Format(buffer,sizeof(buffer), "Simon");
            PrintToChatAll("%s %s dal hráči %N volný den!", TAG, buffer, i);
            GiveClientFreeDay(i,150.0);
            DatFreeDay(client);
          }
        }
      }
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        SMenu(client);
      }
    }
  }
}
public OpenJail(int client)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    GameEnabled = false;
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
    SMenu(client);
  }
}
public OtherMenu(int client)
{
  char buffer[64];
  Menu Other = CreateMenu(h_Other);
  Other.SetTitle("Ostatní");
  Format(buffer,sizeof(buffer), "Mikrofon %s", (Mic) ? "[Vypnout]":"[Zapnout]");
  Other.AddItem("mikrofon", buffer);
  Format(buffer,sizeof(buffer), "Stopky %s", (Stopky) ? "[Vypnout]":"[Zapnout]");
  Other.AddItem("stopky", buffer);
  Format(buffer,sizeof(buffer), "Stopy Simona %s", (StopySimona)?"[Vypnout]":"[Zapnout]");
  Other.AddItem("stopy", buffer);
  //Format(buffer,sizeof(buffer), "Noblock %s", (Noblock)?"[Vypnout]":"[Zapnout]");
  //Other.AddItem("noblock", buffer);
  if(CurrentArmoryDoorID != -1) Other.AddItem("armory", "Ovládání dvěrí zbrojnice");
  Other.AddItem("kostka","Kostka");
  Other.AddItem("priklady","Příklady");
  Other.AddItem("gravitace","Gravitace");
  Other.ExitBackButton = true;
  Other.Display(client, MENU_TIME_FOREVER);
}
public h_Other(Menu Other, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      Other.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "priklady")) PrikladyMenu(client);
      else if(StrEqual(Item, "kostka")) KostkaMenu(client);
      else if(StrEqual(Item, "gravitace")) GravitaceMenu(client);
      else if(StrEqual(Item, "armory"))
      {
        int entity = -1;
        for(int i; i < sizeof(DoorTypes); i++)
        {
          while ((entity = FindEntityByClassname(entity, DoorTypes[i])) != INVALID_ENT_REFERENCE)
          {
            int hammerid = GetEntProp(entity, Prop_Data, "m_iHammerID");
            if(hammerid == CurrentArmoryDoorID)
            {
              AcceptEntityInput(entity, "Toggle");
            }
          }
        }
        OtherMenu(client);
      }
      /*else if(StrEqual(Item, "noblock"))
      {
        if(Noblock) DisableNoBlock();
        else EnableNoBlock();
        OtherMenu(client);
      }*/
      else if(StrEqual(Item, "stopy"))
      {
        Stopy = 0;
        StopySimona = !StopySimona;
        OtherMenu(client);
      }
      else if(StrEqual(Item, "stopky"))
      {
        if(Stopky)
        {
          EmitSoundToAllAny(GONG);
          Stopky = false;
          PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYPNUL STOPKY</font>\n<font color='#FFFFFF' size='30'>CAS: %0.02f</font>", s_Timeleft);
        }
        else
        {
          EmitSoundToAllAny(GONG);
          Stopky = true;
          StopkyTime = GetGameTime();
        }
        OtherMenu(client);
      }
      else if(StrEqual(Item, "mikrofon"))
      {
        if(Mic)
        {
          PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENÍ</font>\n<font color='#FFFFFF' size='30'>MIKROFONY VYPNUTY</font>");
          Mic = false;
          LoopClients(i)
          if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T)
          {
            BaseComm_SetClientMute(i, true);
          }
        }
        else
        {
          PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENÍ</font>\n<font color='#FFFFFF' size='30'>MIKROFONY ZAPNUTY</font>");
          Mic = true;
          LoopClients(i)
          if(IsValidClient(i) && GetClientTeam(i) == CS_TEAM_T)
          {
            BaseComm_SetClientMute(i, false);
          }
        }
        OtherMenu(client);
      }
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        SMenu(client);
      }
    }
  }
}
public GravitaceMenu(int client)
{
  Menu Gravitace = CreateMenu(h_Gravitace);
  Gravitace.SetTitle("Gravitace");
  Gravitace.AddItem("mirna","Mírná gravitace");
  Gravitace.AddItem("stredni","Střední gravitace");
  Gravitace.AddItem("velka","Velká gravitace");
  Gravitace.AddItem("normalni","Normální gravitace");
  Gravitace.ExitBackButton = true;
  Gravitace.Display(client, MENU_TIME_FOREVER);
}
public h_Gravitace(Menu Gravitace, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      float gravity;
      Gravitace.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "mirna")) gravity = 0.2;
      else if(StrEqual(Item, "stredni")) gravity = 0.4;
      else if(StrEqual(Item, "velka")) gravity = 0.6;
      else if(StrEqual(Item, "normalni")) gravity = 1.0;
      LoopClients(i)
      {
        if(IsValidClient(i, true) && GetClientTeam(i) == CS_TEAM_T)
        {
          SetEntityGravity(i, gravity);
        }
      }
      GravitaceMenu(client);
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        OtherMenu(client);
      }
    }
  }
}
public PrikladyMenu(int client)
{
  Menu Priklady = CreateMenu(h_Priklady);
  Priklady.SetTitle("Příklady");
  Priklady.AddItem("scitani","Sčítání");
  Priklady.AddItem("odecitani","Odečítání");
  Priklady.AddItem("nasobeni","Násobení");
  Priklady.AddItem("deleni","Dělení");
  Priklady.ExitBackButton = true;
  Priklady.Display(client, MENU_TIME_FOREVER);
}
public h_Priklady(Menu Priklady, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      int priklad1 = GetRandomInt(0 , 70);
      int priklad2 = GetRandomInt(0 , 70);
      int priklad3 = GetRandomInt(1 , 15);
      int priklad4 = GetRandomInt(1 , 15);
      char Item[20];
      Priklady.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "scitani"))
      {
        int total = priklad1 + priklad2;
        PrintToChatAll( "*\x09[Příklady] Kolik je %d + %d",priklad1,priklad2);
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTÁ KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d + %d</font>",priklad1,priklad2);
        PrintToChat(client,"Skrytá odpověď - Výsledek příkladu je: %d",total);
        PrikladyMenu(client);
      }
      else if(StrEqual(Item, "odecitani"))
      {
        int total = priklad1 - priklad2;
        PrintToChatAll( "*\x09[Příklady] Kolik je %d - %d",priklad1,priklad2);
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTÁ KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d - %d</font>",priklad1,priklad2);
        PrintToChat(client,"Skrytá odpověď - Výsledek příkladu je: %d",total);
        PrikladyMenu(client);
      }
      else if(StrEqual(Item, "nasobeni"))
      {
        int total = priklad3 * priklad4;
        PrintToChatAll( "*\x09[Příklady] Kolik je %d * %d",priklad3,priklad4);
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTÁ KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d * %d</font>",priklad3,priklad4);
        PrintToChat(client,"Skrytá odpověď - Výsledek příkladu je: %d",total);
        PrikladyMenu(client);
      }
      else if(StrEqual(Item, "deleni"))
      {
        int vysledek1 = priklad3 * priklad4;
        int total = vysledek1 / priklad3;
        PrintToChatAll( "*\x09[Příklady] Kolik je %d / %d",vysledek1,priklad3);
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON SE PTÁ KOLIK JE</font><br><font color='#FFFFFF' size='30'>%d / %d</font>",vysledek1,priklad3);
        PrintToChat(client,"Skrytá odpověď - Výsledek příkladu je: %d",total);
        PrikladyMenu(client);
      }
      PrikladyMenu(client);
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        OtherMenu(client);
      }
    }
  }
}

public KostkaMenu(int client)
{
  Menu Kostka = CreateMenu(h_Kostka);
  Kostka.SetTitle("Hod kostkou");
  Kostka.AddItem("6","Kostka 6 čísel");
  Kostka.AddItem("12","Kostka 12 čísel");
  Kostka.AddItem("24","Kostka 24 čísel");
  Kostka.AddItem("32","Kostka 32 čísel");
  Kostka.AddItem("64","Kostka 64 čísel");
  Kostka.ExitBackButton = true;
  Kostka.Display(client, MENU_TIME_FOREVER);
}
public h_Kostka(Menu Kostka, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      Kostka.GetItem(Position, Item,sizeof(Item));
      int i_Kostka = StringToInt(Item);
      int iRand = GetRandomInt(1, i_Kostka);
      PrintToChatAll( "*\x09[Kostka] Při hodu kostkou %s padlo číslo: %i",Item,iRand);
      PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON HODIL KOSTKOU %s</font>\n<font color='#FFFFFF' size='30'>PADLO ČÍSLO: %i</font>",Item,iRand);
      KostkaMenu(client);
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        OtherMenu(client);
      }
    }
  }
}
public GameMenu(int client)
{
  char buffer[128];
  Menu GameModesMenu = CreateMenu(h_GameModes);
  GameModesMenu.SetTitle("Herní mody");
  GameModesMenu.AddItem("prestrelka", "Přestřelka", (GameEnabled)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  GameModesMenu.AddItem("metrix", "Metrix", (GameEnabled)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  GameModesMenu.AddItem("zombie", "Zombie", (GameEnabled)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  GameModesMenu.AddItem("schovka", "Schovka", (GameEnabled)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "Fotbal [%s]", (Fotbal) ? "Vypnout" : "Zapnout");
  GameModesMenu.AddItem("fotbal", buffer);
  Format(buffer, sizeof(buffer), "Box [%s]", (Box || BoxRestrict) ? "Vypnout" : "Vybrat typ");
  GameModesMenu.AddItem("box", buffer);
  GameModesMenu.ExitBackButton = true;
  GameModesMenu.Display(client, MENU_TIME_FOREVER);
}
public h_GameModes(Menu GameModesMenu, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      GameModesMenu.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "prestrelka"))  PrestrelkaMenu(client);
      else if(StrEqual(Item, "schovka"))
      {
        EmitSoundToAllAny(SCHOVKA);
        GameRules_SetProp("m_iRoundTime", (60*4), 4, 0, true);
        PerformSchovka(client);
      }
      else if(StrEqual(Item, "metrix"))
      {
        EmitSoundToAllAny(MATRIX);
        GameRules_SetProp("m_iRoundTime", (60*4), 4, 0, true);
        DisableSimon();
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#CC33CC' size='30'><i>MATRIX MOD</i></font>");
        MatrixEnable = true;
        LoopClients(i)
        {
          if(IsValidClient(i, true))  MetrixMenu(i);
        }
      }
      else if(StrEqual(Item, "zombie"))
      {
        EmitSoundToAllAny(ZOMBIE);
        GameRules_SetProp("m_iRoundTime", (60*4), 4, 0, true);
        DisableSimon();
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font><br><font color='#FF0000' size='30'><i>ZOMBIE MOD</i></font>");
      }
      else if(StrEqual(Item, "fotbal"))
      {
        if(Fotbal)
        {
          Fotbal = false;
        }
        else
        {
          Fotbal = true;
        }
        GameMenu(client);
      }
      else if(StrEqual(Item, "box"))
      {
        if(Box || BoxRestrict)
        {
          DisableBox();
          if(Box)
          {
            Box = false;
            PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYPNUL CLASSIC BOX</font>");
          }
          else if(BoxRestrict)
          {
            BoxRestrict = false;
            PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON VYPNUL RESTRICS BOX</font>");
          }
          GameMenu(client);
        }
        else
        {
          BoxMenu(client);
        }
      }
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        SMenu(client);
      }
    }
  }
}
public BoxMenu(int client)
{
  Menu MenuBox = CreateMenu(h_MenuBox);
  MenuBox.SetTitle("Vyber druh boxu");
  MenuBox.AddItem("classic", "Classic box");
  MenuBox.AddItem("restrics", "Restrics box");
  MenuBox.ExitBackButton = true;
  MenuBox.Display(client,MENU_TIME_FOREVER);
}
public h_MenuBox(Menu MenuBox, MenuAction action, client, Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      MenuBox.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "classic"))
      {
        EnableBox();
        Box = true;
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZAPNUL CLASSIC BOX</font>");
        GameMenu(client);
      }
      else if(StrEqual(Item, "restrics"))
      {
        EnableBox();
        BoxRestrict = true;
        PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON ZAPNUL RESTRICS BOX</font>");
        GameMenu(client);
      }
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        GameMenu(client);
      }
    }
  }
}
public MetrixMenu(int client)
{
  Menu Matrix = CreateMenu(h_Matrix);
  Matrix.SetTitle("Matrix - Zvol si charakter");
  if(GetClientTeam(client) == CS_TEAM_T)
  {
    Matrix.AddItem("neo", "Neo");
    Matrix.AddItem("trinity", "Trinity");
    Matrix.AddItem("morpheus", "Morpheus");
  }
  else if(GetClientTeam(client) == CS_TEAM_CT)
  {
    Matrix.AddItem("smith", "Agent Smith");
    Matrix.AddItem("soldier", "Soldier");
  }
  Matrix.ExitButton = false;
  Matrix.Display(client,MENU_TIME_FOREVER);
}
public h_Matrix(Menu Matrix, MenuAction action, client, Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      Matrix.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "neo"))
      {
        Matrix_SetUpClient(client, "weapon_deagle", 300, 2.5, 0.3);
      }
      else if(StrEqual(Item, "trinity"))
      {
        Matrix_SetUpClient(client, "weapon_elite", 400, 2.0, 0.2);
      }
      else if(StrEqual(Item, "morpheus"))
      {
        Matrix_SetUpClient(client, "weapon_p250", 500, 1.5, 0.4);
      }
      else if(StrEqual(Item, "smith"))
      {
        Matrix_SetUpClient(client, "weapon_deagle", 1000, 2.5, 0.2);
      }
      else if(StrEqual(Item, "soldier"))
      {
        Matrix_SetUpClient(client, "weapon_elite", 1300, 1.5, 0.4);
      }
    }
  }
}
public PrestrelkaMenu(int client)
{
  Menu Prestrelka = CreateMenu(h_Prestrelka);
  Prestrelka.SetTitle("Přestřelka");
  Prestrelka.AddItem("vyberzbrani", "Výběr zbraní");
  Prestrelka.AddItem("nahodnazbran", "Náhodná zbraň");
  Prestrelka.AddItem("weapon_m4a1", "Pouze M4A4");
  Prestrelka.AddItem("weapon_ak47", "Pouze AK47");
  Prestrelka.AddItem("weapon_ssg08", "Pouze Scout");
  Prestrelka.ExitBackButton = true;
  Prestrelka.Display(client, MENU_TIME_FOREVER);
}
public h_Prestrelka(Menu Prestrelka, MenuAction action, client, Position)
{
  if(IsValidClient(client, true) && IsClientSimon(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      Prestrelka.GetItem(Position,Item,sizeof(Item));
      if(StrEqual(Item, "vyberzbrani"))
      {
        EmitSoundToAllAny(PRESTRELKA);
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font>\n<font color='#6699CC' size='30'><i>PŘESTŘELKA (VÝBĚR)</i></font>");
        PrestrelkaEnable = true;
        LoopClients(i)
        {
          if(IsValidClient(i, true))
          {
            StripWeapons(i);
            Pretrelka_VyberZbrani_Primary(i);
          }
        }
      }
      else if(StrEqual(Item, "nahodnazbran"))
      {
        EmitSoundToAllAny(PRESTRELKA);
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font>\n<font color='#6699CC' size='30'><i>PŘESTŘELKA (NÁHODNÁ)</i></font>");
        PrestrelkaEnable = true;
        LoopClients(i)
        {
          if(IsValidClient(i, true))
          {
            StripWeapons(i);
            GivePlayerItem(i,s_weaponlistclass_random[GetRandomInt(0,sizeof(s_weaponlistclass_random)-1)]);
          }
        }
      }
      else if(StrEqual(Item, "weapon_m4a1"))
      {
        EmitSoundToAllAny(PRESTRELKA);
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font>\n<font color='#6699CC' size='30'><i>PŘESTŘELKA (M4)</i></font>");
        Prestrelka_GivePlayerWeapon(Item);
      }
      else if(StrEqual(Item, "weapon_ak47"))
      {
        EmitSoundToAllAny(PRESTRELKA_AK);
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font>\n<font color='#6699CC' size='30'><i>PŘESTŘELKA (AK47)</i></font>");
        Prestrelka_GivePlayerWeapon(Item);
      }
      else if(StrEqual(Item, "weapon_ssg08"))
      {
        EmitSoundToAllAny(PRESTRELKA_SCOUT);
        PrintHintTextToAll("<font color='#00FF00' size='17'>SIMON SPUSTIL</font>\n<font color='#6699CC' size='30'><i>PŘESTŘELKA (SCOUT)</i></font>");
        Prestrelka_GivePlayerWeapon(Item);
      }
      GameRules_SetProp("m_iRoundTime", (60*4), 4, 0, true);
      DisableSimon();
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        GameMenu(client);
      }
    }
  }
}
public Pretrelka_VyberZbrani_Primary(int client)
{
  Menu VyberZbraniPrim = CreateMenu(h_VyberZbraniPrim);
  VyberZbraniPrim.SetTitle("Vyber si primární zbraň");
  for(int wep; wep < sizeof(prestrelka_weaponlistclass); wep++)
  {
    VyberZbraniPrim.AddItem(prestrelka_weaponlistclass[wep],prestrelka_weaponlistnames[wep]);
  }
  VyberZbraniPrim.ExitButton = false;
  VyberZbraniPrim.Display(client, MENU_TIME_FOREVER);
}
public h_VyberZbraniPrim(Menu VyberZbraniPrim, MenuAction action, client, Position)
{
  if(action == MenuAction_Select)
  {
    if(IsValidClient(client, true))
    {
      char Item[20];
      VyberZbraniPrim.GetItem(Position,Item,sizeof(Item));
      GivePlayerItem(client, Item);
      Pretrelka_VyberZbrani_Secondary(client);
    }
  }
}
public Pretrelka_VyberZbrani_Secondary(int client)
{
  Menu VyberZbraniSecon = CreateMenu(h_VyberZbraniSecon);
  VyberZbraniSecon.SetTitle("Vyber si sekundární zbraň");
  for(int wep; wep < sizeof(prestrelka_weaponlistclass_secondary); wep++)
  {
    VyberZbraniSecon.AddItem(prestrelka_weaponlistclass_secondary[wep],prestrelka_weaponlistnames_secondary[wep]);
  }
  VyberZbraniSecon.ExitButton = false;
  VyberZbraniSecon.Display(client, MENU_TIME_FOREVER);
}
public h_VyberZbraniSecon(Menu VyberZbraniSecon, MenuAction action, client, Position)
{
  if(action == MenuAction_Select)
  {
    if(IsValidClient(client, true))
    {
      char Item[20];
      VyberZbraniSecon.GetItem(Position,Item,sizeof(Item));
      GivePlayerItem(client, Item);
    }
  }
}
public WepMenu(int client)
{
  char buffer[64];
  Menu WeaponMenu = CreateMenu(h_WepMenu);
  WeaponMenu.SetTitle("Vybrat zbraň");
  for(int wep; wep < sizeof(s_weaponlistclass);wep++)
  {
    Format(buffer,sizeof(buffer), "%s+DEAGLE",s_weaponlistnames[wep]);
    WeaponMenu.AddItem(s_weaponlistclass[wep], buffer);
  }
  WeaponMenu.ExitButton = true;
  WeaponMenu.Display(client, MENU_TIME_FOREVER);

}
public h_WepMenu(Menu WeaponMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select)
  {
    if(IsValidClient(client, true) && (IsClientSimon(client) || GetClientTeam(client) == CS_TEAM_CT))
    {
      char Item[20];
      WeaponMenu.GetItem(Position,Item,sizeof(Item));
      StripWeapons(client);
      GivePlayerItem(client,"weapon_deagle");
      GivePlayerItem(client,Item);
      WeaponChooseAllowed[client] = false;
      if(IsClientSimon(client)) SMenu(client);
    }
  }
}

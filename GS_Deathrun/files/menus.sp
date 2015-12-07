public ShowJokerMenu(client)
{
  char buffer[256];
  Format(buffer,sizeof(buffer),"--- Joker Menu --- \n-------------------------------");
  Menu JokerMenu = CreateMenu(h_JokerMenu);
  JokerMenu.SetTitle(buffer);

  if(!joker_speedup && joker_bhop) JokerMenu.AddItem("toggle", "Schopnost [AutoBhop]\n -------------------------------");
  if(joker_speedup && !joker_bhop) JokerMenu.AddItem("toggle", "Schopnost [SpeedUp+]\n -------------------------------");

  if(!fr_enable) JokerMenu.AddItem("fr", "FreeRUN");
  else if(fr_enable) JokerMenu.AddItem("fr", "FreeRUN",ITEMDRAW_DISABLED);
  JokerMenu.Display(client, MENU_TIME_FOREVER);
  JokerMenu.ExitButton = false;
}
public h_JokerMenu(Handle JokerMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && GetClientTeam(client) == CS_TEAM_T && IsValidClient(client) && IsClientJoker(client))
  {
    char Item[20];
    GetMenuItem(JokerMenu, Position, Item, sizeof(Item));
    {
      if(StrEqual(Item, "toggle"))
      {
        if(joker_bhop) joker_bhop = false, joker_speedup = true;
        else joker_bhop = true, joker_speedup = false;
      }
      if(StrEqual(Item, "fr"))
      {
        Event_Freerun(client);
      }
    }
    ShowJokerMenu(client);
  }
}
public ShowBatmanMenu(client)
{
  char buffer[256];
  Format(buffer,sizeof(buffer),"--- Batman Menu --- \n --------------------");
  Menu Batmanmenu = CreateMenu(h_Batmanmenu);
  Batmanmenu.SetTitle(buffer);

  if(!b_CTDoubleJump[client] && !b_CTBhop[client]) Batmanmenu.AddItem("bhop", "AutoBhop");
  if(!b_CTDoubleJump[client] && b_CTBhop[client]) Batmanmenu.AddItem("bhop", "AutoBhop [Aktivováno]",ITEMDRAW_DISABLED);
  if(b_CTDoubleJump[client] && !b_CTBhop[client]) Batmanmenu.AddItem("bhop", "AutoBhop",ITEMDRAW_DISABLED);

  Format(buffer,sizeof(buffer),"DoubleJump \n --------------------");
  if(!b_CTDoubleJump[client] && !b_CTBhop[client]) Batmanmenu.AddItem("doublejump", buffer);
  Format(buffer,sizeof(buffer),"DoubleJump [Aktivováno]\n --------------------");
  if(b_CTDoubleJump[client] && !b_CTBhop[client]) Batmanmenu.AddItem("doublejump", buffer,ITEMDRAW_DISABLED);
  Format(buffer,sizeof(buffer),"DoubleJump \n --------------------");
  if(!b_CTDoubleJump[client] && b_CTBhop[client]) Batmanmenu.AddItem("doublejump", buffer,ITEMDRAW_DISABLED);
  if(!b_HidePlayers[client]) Batmanmenu.AddItem("hide", "Skrýt spoluhráče [Vypnuto]");
  else Batmanmenu.AddItem("hide", "Skrýt spoluhráče [Zapnuto]");
  Batmanmenu.Display(client, MENU_TIME_FOREVER);
  Batmanmenu.ExitButton = false;
}
public h_Batmanmenu(Handle Batmanmenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && GetClientTeam(client) == CS_TEAM_CT && IsValidClient(client))
  {
    char Item[20];
    GetMenuItem(Batmanmenu, Position, Item, sizeof(Item));
    {
      if(StrEqual(Item, "bhop"))
      {
        b_CTBhop[client] = true;
      }
      if(StrEqual(Item, "doublejump"))
      {
        b_CTDoubleJump[client] = true;
      }
      if(StrEqual(Item, "hide"))
      {
        if(!b_HidePlayers[client]) b_HidePlayers[client] = true;
        else b_HidePlayers[client] = false;

      }
    }
  }
}
public ShowHelpMenu(client)
{
  char buffer[256];
  Format(buffer,sizeof(buffer),"--- Nápověda --- \n --------------------------------------------");
  Format(buffer,sizeof(buffer),"%s \n !joker - Zobrazí joker menu",buffer);
  Format(buffer,sizeof(buffer),"%s \n !fr/!freerun - Spustí FreeRUN kolo",buffer);
  Format(buffer,sizeof(buffer),"%s \n !music - Vypne nebo Zapne roundsounds",buffer);
  Format(buffer,sizeof(buffer),"%s \n !rs - Vymaže skore \n --------------------------------------------",buffer);
  Menu HelpMenu = CreateMenu(h_HelpMenu);
  HelpMenu.SetTitle(buffer);
  HelpMenu.AddItem("exit", "Exit");
  HelpMenu.ExitButton = false;
  HelpMenu.Display(client, MENU_TIME_FOREVER);
}
public h_HelpMenu(Handle HelpMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && GetClientTeam(client) == CS_TEAM_T && IsValidClient(client) && IsClientJoker(client))
  {
    char Item[20];
    GetMenuItem(HelpMenu, Position, Item, sizeof(Item));
    {
    }
  }
}
public ShowPravidlaMenu(client)
{
  char buffer[1024];
  Format(buffer,sizeof(buffer),"--- Pravidla --- \n--------------------------------------------");
  Format(buffer,sizeof(buffer),"%s \n - Nesmíš nadávat ani jakýmkoli způsobem ponižovat ostatní hráče.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Nesmíš cheatovat nebo využívat jiných podpůrných programů.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Nesmíš využívat bugů mapy ve svůj prospěch.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Nesmíš spamovat pasti na mapě více jak jednou s výjimkou točitých pastí a výbušných (barely)",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Nesmíš si zkracovat mapu ani se o to pokoušet.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Vždy když najdeš jakýkoli bug, tak si ho nenecháš pro sebe, ale napíšeš nám ho na naše forum.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Za CT, tudíž Anti-Joker team nesmíš schválně zdržovat hru.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Za Jokera je tvojí povinností spouštět pasti a atrakce, nesmíš svévolně nechávat CT (Anti-Jokerteam) procházet.",buffer);
  Format(buffer,sizeof(buffer),"%s \n - Poslední a zlaté pravidlo, nikdy žádným způsobem schválně nekaž ani nebuguj hru.",buffer);
  Menu PravidlaMenu = CreateMenu(h_PravidlaMenu);
  PravidlaMenu.SetTitle(buffer);
  PravidlaMenu.AddItem("exit", "Exit");
  PravidlaMenu.ExitButton = false;
  PravidlaMenu.Display(client, MENU_TIME_FOREVER);
}
public h_PravidlaMenu(Handle PravidlaMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && GetClientTeam(client) == CS_TEAM_T && IsValidClient(client) && IsClientJoker(client))
  {
    char Item[20];
    GetMenuItem(PravidlaMenu, Position, Item, sizeof(Item));
    {
    }
  }
}

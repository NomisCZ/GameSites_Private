public ShowTrailMenu(client)
{
  Menu TrailMenu = CreateMenu(h_TrailMenu);
  TrailMenu.SetTitle("-- Trail Menu --");
  if(IsTrailEnabled(client)) TrailMenu.AddItem("toggle_global", "Vypnout traily");
  else TrailMenu.AddItem("toggle_global", "Zapnout traily");
  TrailMenu.AddItem("trail_color", "Změnit trail");
  TrailMenu.ExitButton = true;
  TrailMenu.Display(client, MENU_TIME_FOREVER);
}
public h_TrailMenu(Handle TrailMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && IsValidClient(client))
  {
    char Item[20];
    GetMenuItem(TrailMenu, Position, Item, sizeof(Item));
    {
      if(StrEqual(Item, "toggle_global"))
      {
        if(IsTrailEnabled(client))
        {
          SetClientCookie(client, g_hClientTrailEnabled, "1");
          CPrintToChat(client,"%s Traily budou plně vypnuty na začátku dalšího kola",s_Tag);
        }
        else
        {
          SetClientCookie(client, g_hClientTrailEnabled, "0");
          CPrintToChat(client,"%s Traily byly zapnuty",s_Tag);
        }
        ShowTrailMenu(client);
      }
      else if(StrEqual(Item, "trail_color"))
      {
        ShowTrailColorMenu(client);
      }
    }
  }
}
public ShowTrailColorMenu(client)
{
  Menu TrailColorMenu = CreateMenu(h_TrailColorMenu);
  TrailColorMenu.SetTitle("-- Trail Color Menu --");
  TrailColorMenu.AddItem("0", "Žádný trail");
  TrailColorMenu.AddItem("1", "Červený trail");
  TrailColorMenu.AddItem("2", "Zelený trail");
  TrailColorMenu.AddItem("3", "Modrý trail");
  TrailColorMenu.AddItem("4", "Zeleno-žlutý) trail");
  TrailColorMenu.AddItem("5", "Zlatý trail");
  TrailColorMenu.AddItem("6", "Světle růžový trail");
  TrailColorMenu.AddItem("7", "Růžový trail");
  TrailColorMenu.ExitButton = true;
  TrailColorMenu.Display(client, MENU_TIME_FOREVER);
}
public h_TrailColorMenu(Handle TrailColorMenu, MenuAction action, client, Position)
{
  if(action == MenuAction_Select && IsValidClient(client))
  {
    char Item[20];
    GetMenuItem(TrailColorMenu, Position, Item, sizeof(Item));
    {
      SetClientCookie(client, g_hClientTrail, Item);
    }
  }
}

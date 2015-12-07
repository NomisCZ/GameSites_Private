public Action Event_OnPlayerTeamJoin(client, const char[] command, args)
{
  char arg[3];
  GetCmdArg(1, arg, sizeof(arg));
  if(arg[0] == '0')
  {
    if(IsValidClient(client))
    {
      ShowVGUIPanel(client, "team");
      return Plugin_Handled;
    }
  }
  if(StringToInt(arg) == CS_TEAM_T)
  {
    return Plugin_Handled;
  }
  return Plugin_Continue;
}
public Action Event_OnPlayerTeam(Handle event, const char[] name, bool dontbroadcast)
{
  int team = GetEventInt(event, "team");
  if(team == CS_TEAM_T)
  {
    return Plugin_Handled;
  }
  dontbroadcast = true;
  return Plugin_Changed;
}

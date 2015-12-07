public Action OnPlayerRunCmd(client, &buttons, &impulse, float vel[3], float angles[3], &weapon)
{
  if(AutoBhop)
  {
    if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
    {
      int index = GetEntProp(client, Prop_Data, "m_nWaterLevel");
      int water = EntIndexToEntRef(index);
      if (water != INVALID_ENT_REFERENCE)
      {
        if (IsPlayerAlive(client))
        {
          if (buttons & IN_JUMP)
          {
            if (!(GetClientWaterLevel(client) > 1))
            {
              if (!(GetEntityMoveType(client) & MOVETYPE_LADDER))
              {
                SetEntPropFloat(client, Prop_Send, "m_flStamina", 0.0);
                if (!(GetEntityFlags(client) & FL_ONGROUND))
                {
                  buttons &= ~IN_JUMP;
                }
              }
            }
          }
        }
      }
    }
  }
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T)
  {
    if(IsClientInvisible[client])
    {
      float timeleft = ClientInvisibleStartTime[client] - GetGameTime() + 15.0;
      if(timeleft < 0.01)
      {
        IsClientInvisible[client] = false;
      }
    }
  }
  if(IsValidClient(client, true) && GetClientTeam(client) == CS_TEAM_T && HasClientFreeDay(client))
  {
    float timeleft = ClientFreeDayStartTime[client] - GetGameTime() + ClientFreeDayTime[client];
    if(timeleft < 0.01 && timeleft > -0.5)
    {

      PrintToChatAll("%s Hráči \x10%N\x01 skončil volný den a musí se zapojit do hry! ", TAG, client);
      RemoveClientFreeDay(client);
    }
  }
  if(IsValidClient(client) && Grab[client])
  {
    if(buttons & IN_ATTACK) GrabDistance[client] += 10.0;
    else if(buttons & IN_ATTACK2) GrabDistance[client] -= 10.0;
    else if(buttons & IN_RELOAD)
    {
      if(IsValidClient(Grab[client], true))
      {
        Grab[client] = false;
        char classname[32];
        GetEntityClassname(GrabTarget[client], classname, sizeof(classname));
        if(StrEqual(classname, "player")) ForcePlayerSuicide(GrabTarget[client]);
        char steamid[32];
        char steamid1[32];
        GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
        GetClientAuthId(GrabTarget[client], AuthId_Engine, steamid1, sizeof(steamid1));
        LogToFile(logfile, "Admin: %N (%s), Zabil v grabu hráče: %N (%s)", client,steamid, GrabTarget[client],steamid1);
        GrabTarget[client] = -1;
      }
    }
    MovePlayer(client);
  }
}

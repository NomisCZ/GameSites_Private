public Action OnPlayerRunCmd(client, &buttons, &impulse, float vel[3], float angles[3], &weapon)
{
  if(IsValidClient(client))
  {
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      if(b_ClientRespawn[client])
      {
        float timeleft = (f_ClientRespawnTime[client] - GetGameTime() + 5.0);
        if(timeleft > 0.01)
        {
          PrintHintText(client, "<font color='#f29f00'>Budeš respawnut za: </font><font color='#00ff00'>%0.01f</font> \n <font color='#f29f00'>Zbývající životy: %d</font>",timeleft, i_ClientLifes[client]);
        }
        else if(timeleft < 0.01)
        {
          CS_RespawnPlayer(client);
          i_ClientLifes[client]--;
          b_ClientRespawn[client] = false;
        }
      }
    }
  }
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      if(b_CTBhop[client])
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
      else if(b_CTDoubleJump[client])
      {
        int f_CurFlags = GetEntityFlags(client);
        int b_CurButtons = GetClientButtons(client);
        if (i_LastFlags[client] & FL_ONGROUND)
        {
          if (!(f_CurFlags & FL_ONGROUND) && !(i_LastButtons[client] & IN_JUMP) && b_CurButtons & IN_JUMP)
          {
            i_JumpsCount[client]++;
          }
        }
        else if (f_CurFlags & FL_ONGROUND)
        {
          i_JumpsCount[client] = 0;
        }
        else if (!(i_LastButtons[client] & IN_JUMP) && b_CurButtons & IN_JUMP)
        {
          int maxjump = 1;
          if ( 1 <= i_JumpsCount[client] <= maxjump)
          {
            i_JumpsCount[client]++;
            float vVel[3];
            GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
            vVel[2] = 250.0;
            TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
          }
        }
        i_LastFlags[client]	= f_CurFlags;
        i_LastButtons[client]	= b_CurButtons;
      }
    }
    else if(GetClientTeam(client) == CS_TEAM_T && IsClientJoker(client) && joker_bhop)
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
}

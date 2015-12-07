public CreateBeacon(client)
{
  int userid = GetClientUserId(client);
  CreateTimer(1.0, Timer_Beacon, userid, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public KillBeacon(client)
{
  if (IsValidClient(client) && IsValidClient(GrabTarget[client]))
  {
    SetEntityRenderColor(GrabTarget[client], 255, 255, 255, 255);
  }
}
public Action Timer_Beacon(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if (IsValidClient(GrabTarget[client], true))
  {
    float vec[3];
    GetClientAbsOrigin(GrabTarget[client], vec);
    vec[2] += 10;

    TE_SetupBeamPoints(vec, 20.0, g_BeamSprite, 0, 0, 0, 0.1, 3.0, 3.0, 10, 0.0, {255,0,0,0}, 0);
		TE_SendToAll();
  }
  else
  {
    KillBeacon(client);
    return Plugin_Stop;
  }
  return Plugin_Continue;
}

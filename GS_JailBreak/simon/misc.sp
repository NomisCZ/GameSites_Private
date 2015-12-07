#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++)

stock bool IsValidClient(int client, bool alive = false)
{
  if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (alive == false || IsPlayerAlive(client))) return true;
  return false;
}
stock bool IsClientSimon(int client)
{
  if(client == simon) return true;
  return false;
}
stock bool IsClientAdmin(int client)
{
  if (GetAdminFlag(GetUserAdmin(client), Admin_Generic)) return true;
  return false;
}
stock bool IsPlayerVIP(int client)
{
  if (GetAdminFlag(GetUserAdmin(client), Admin_Reservation)) return true;
  return false;
}
stock bool IsPlayerEVIP(int client)
{
  if (GetAdminFlag(GetUserAdmin(client), Admin_Reservation)) return true;
  return false;
}
stock bool ExistSimon()
{
  if(simon != -1) return true;
  return false;
}
stock EnableNoBlock()
{
  PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENÍ</font>\n<font color='#FFFFFF' size='30'>NOBLOCK ZAPNUT</font>");
  LoopClients(i)
  {
    if (IsValidClient(i, true))
    {
      SetEntData(i, NoBlockOffSet, 2, 4, true);
    }
  }
  Noblock = true;
}
stock DisableNoBlock()
{
  PrintHintTextToAll("<font color='#00FF00' size='20'>SIMON UPRAVIL NASTAVENÍ</font>\n<font color='#FFFFFF' size='30'>NOBLOCK VYPNUT</font>");
  LoopClients(i)
  {
    if(IsValidClient(i))
    {
      SetEntData(i, NoBlockOffSet, 5, 4, true);
    }
  }
  Noblock = false;
}
stock bool HasClientFreeDay(int client)
{
  if(HasFreeDay[client]) return true;
  return false;
}
stock StartGlobalFreeDay(float time = 90.0)
{
  GlobalFreeDay = true;
  GlobalFreeDayTime = time;
  GlobalFreeDayStartTime = GetGameTime();
}
stock GetClientWaterLevel(client)
{
  return GetEntProp(client, Prop_Send, "m_nWaterLevel");
}
stock SetCvar(char[] scvar, char[] svalue)
{
	SetConVarString(FindConVar(scvar), svalue, true);
}

stock GiveClientFreeDay(int client, float time)
{
  if(IsValidClient(client, true))
  {
    if(time != -1.0) SetEntityRenderColor(client, 255,140,0,255);
    else SetEntityRenderColor(client, 204,0,204,255);
    ClientFreeDayTime[client] = time;
    ClientFreeDayStartTime[client] = GetGameTime();
    HasFreeDay[client] = true;

  }
}
stock RemoveClientFreeDay(int client)
{
  if(IsValidClient(client))
  {
    HasFreeDay[client] = false;
    SetEntityRenderColor(client);
  }
}
stock RemoveAllFreeDays()
{
  LoopClients(i)
  {
    if(IsValidClient(i))
    {
      HasFreeDay[i] = false;
      SetEntityRenderColor(i);
    }
  }
}
stock CountPlayersInTeam(int team, bool alive = false, bool wfd = false)
{
  int count = 0;
  LoopClients(i)
  {
    if(IsValidClient(i, alive) && GetClientTeam(i) == team)
    {
      count++;
    }
  }
  return count;
}
stock BlindClient(client,const int amount)
{
	int targets[2];
	targets[0] = client;

	int duration = 1536;
	int holdtime = 1536;

	int flags;
	if (amount == 0)
	{
		flags = (0x0001 | 0x0010);
	}
	else
	{
		flags = (0x0002 | 0x0008);
	}

	int color[4] = { 0,0,0,0 };
	color[3] = amount;
	Handle message = StartMessageEx(GetUserMessageId("Fade"), targets, 1);
	if (GetUserMessageType() == UM_Protobuf)
	{
		PbSetInt(message, "duration", duration);
		PbSetInt(message, "hold_time", holdtime);
		PbSetInt(message, "flags", flags);
		PbSetColor(message, "clr", color);
	}
	EndMessage();
}
stock RemoveHandle(&Handle:handle)
{
	if(handle != INVALID_HANDLE)
	{
		KillTimer(handle);
		handle = INVALID_HANDLE;
	}
}
stock StripWeapons(int client)
{
	int wepIdx;
	for (int x = 0; x <= 5; x++)
	{
		if (x != 2 && (wepIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEdict(wepIdx);
		}
	}
}
stock Prestrelka_GivePlayerWeapon(const char[] weapon)
{
  PrestrelkaEnable = true;
  Format(Prestrelka_Wep,sizeof(Prestrelka_Wep), weapon);
  LoopClients(i)
  {
    if(IsValidClient(i, true))
    {
      StripWeapons(i);
      GivePlayerItem(i, weapon);
    }
  }
}
stock SetClientSpeed(client,const float speed)
{
    SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue",speed);
}
stock Matrix_SetUpClient(int client, const char[] classname,const int health,const float speed,const float gravity)
{
  StripWeapons(client);
  GivePlayerItem(client, classname);
  SetEntityHealth(client, health);
  SetClientSpeed(client,speed);
  SetEntityGravity(client, gravity);
  Format(MatrixClientWeapon[client], sizeof(MatrixClientWeapon), classname);
}
stock LightCreate(float pos[3], bool random = false)
{
    int iEntity = CreateEntityByName("light_dynamic");
    DispatchKeyValue(iEntity, "inner_cone", "0");
    DispatchKeyValue(iEntity, "cone", "80");
    DispatchKeyValue(iEntity, "brightness", "1");
    DispatchKeyValueFloat(iEntity, "spotlight_radius", 150.0);
    DispatchKeyValue(iEntity, "pitch", "90");
    DispatchKeyValue(iEntity, "style", "1");
    if(random)
    {
      int rand1 = GetRandomInt(1,255);
      int rand2 = GetRandomInt(1,255);
      int rand3 = GetRandomInt(1,255);
      char color[32];
      Format(color, sizeof(color), "%d %d %d 255", rand1, rand2, rand3);
      DispatchKeyValue(iEntity, "_light", color);
    }
    else DispatchKeyValue(iEntity, "_light", "78 157 120 255");
    DispatchKeyValueFloat(iEntity, "distance", 128.0);
    CreateTimer(4.0, Timer_DeleteLight, iEntity, TIMER_FLAG_NO_MAPCHANGE);
    DispatchSpawn(iEntity);
    TeleportEntity(iEntity, pos, NULL_VECTOR, NULL_VECTOR);
    AcceptEntityInput(iEntity, "TurnOn");
}
stock CenterClientView(int client, float point[3])
{
  float angles[3];
  float clientEyes[3];
  float resultant[3];
  GetClientEyePosition(client, clientEyes);
  MakeVectorFromPoints(point, clientEyes, resultant);
  GetVectorAngles(resultant, angles);
  if (angles[0] >= 270)
  {
    angles[0] -= 270;
    angles[0] = (90 - angles[0]);
  }
  else if (angles[0] <= 90) angles[0] *= -1;
  angles[1] -= 180;
  TeleportEntity(client, NULL_VECTOR, angles, NULL_VECTOR);
}
stock AddInFrontOf(float vecOrigin[3], float vecAngle[3], float units, float output[3])
{
	float vecAngVectors[3];
	vecAngVectors = vecAngle;
	GetAngleVectors(vecAngVectors, vecAngVectors, NULL_VECTOR, NULL_VECTOR);
	for (int i; i < 3; i++) output[i] = vecOrigin[i] + (vecAngVectors[i] * units);

}

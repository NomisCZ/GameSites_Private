stock CreateEntity(client)
{

	float vec[3];
	GetClientEyePosition(client, vec);
	vec[2] -= 40.0;
	int ent = CreateEntityByName("env_sprite");
	SetEntityRenderMode(ent, RENDER_NONE);
	TeleportEntity(ent, vec, Float:{0.0,0.0,0.0}, NULL_VECTOR);
	DispatchSpawn(ent);
	TeleportEntity(ent, vec, NULL_VECTOR, NULL_VECTOR);
	SetVariantString("!activator");
	AcceptEntityInput(ent, "SetParent", client);
	return ent;
}
stock RemoveEntity(entity)
{
	if(IsValidEntity(entity))
	{
		AcceptEntityInput(entity, "Kill");
		entity = -1;
	}
}
stock ResetHandle(&Handle: handle)
{
	if (handle != INVALID_HANDLE)
	{
		CloseHandle(handle);
		handle = INVALID_HANDLE;
	}
}
stock bool IsTrailSelected(client)
{
	char sCookieValue[11];
	GetClientCookie(client, g_hClientTrail, sCookieValue, sizeof(sCookieValue));
	if(StringToInt(sCookieValue) > 0) return true;
	return false;
}
stock bool IsTrailEnabled(client)
{
	char sCookieValue[11];
	GetClientCookie(client, g_hClientTrailEnabled, sCookieValue, sizeof(sCookieValue));
	if(StringToInt(sCookieValue) == 0) return true;
	return false;
}
stock GetClientTrailColor(client)
{
	char sCookieValue[11];
	GetClientCookie(client, g_hClientTrail, sCookieValue, sizeof(sCookieValue));
	int color = StringToInt(sCookieValue);
	if(StrEqual(sCookieValue,"0")) i_ClientColor[client] = {0,0,0,0};
	switch(color)
	{
		case 1: i_ClientColor[client] = {255,0,0,255}; // Červený
		case 2: i_ClientColor[client] = {0,255,0,255}; // Zelený
		case 3: i_ClientColor[client] = {0,0,205,255}; // Modrý
		case 4: i_ClientColor[client] = {124,252,0,255}; // Zeleno-žlutý
		case 5: i_ClientColor[client] = {255,215,0,255}; // Zlatá
		case 6: i_ClientColor[client] = {178,34,34,255}; // Světle růžový
		case 7: i_ClientColor[client] = {255,20,147,255}; // Růžová
	}
	return i_ClientColor[client];
}

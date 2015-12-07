#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++)
#define MODEL_LASERBEAM "materials/sprites/laserbeam.vmt"

#define s_Tag "[{Lightblue}GameSites{default}]"


//int i_ClientSpriteIndex[MAXPLAYERS+1];
Handle g_hClientTrail;
Handle g_hClientTrailEnabled;

Handle h_trailTimers[MAXPLAYERS+1] = {INVALID_HANDLE,...};
int i_ModelIndex;
int i_Entity[MAXPLAYERS+1] = -1;



int i_ClientColor[MAXPLAYERS+1][4];

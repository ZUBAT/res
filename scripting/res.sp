#include <sourcemod> 
#include <sdktools> 
#include <emitsoundany> 
new SoundValue[MAXPLAYERS];
#undef REQUIRE_PLUGIN
#include <updater>

#define UPDATE_URL    "https://raw.githubusercontent.com/ZUBAT/res/master/updatefile.txt"
#define VER "1.2.0"

new String:SoundF[][] = //Название файлов треков 
{ 
    "1", 
    "2", 
    "3", 
    "4", 
    "5", 
    "6", 
    "7", 
    "8", 
    "9", 
    "10", 
    "11", 
    "12", 
    "13", 
    "14", 
    "15", 
    "16"    
}



public Plugin:myinfo =  
{  
    name = "RoundEndSound",  
    author = "ZUBAT",  
    description = "Playing sounds on end round.",  
    version = VER,  
}  

public OnPluginStart()  
{ 
	HookEvent("round_end", RoundEnd); 
	if (LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
} 
public OnLibraryAdded(const String:name[])
{
    if (StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
}
public OnClientConnected(client)
{
	SoundValue[client] = 0;
}

public OnMapStart() 
{ 
    decl String:Sound[256]; 
    
    for(new i, iSize = sizeof(SoundF); i < iSize; ++i) 
    { 
        FormatEx(Sound, sizeof(Sound), "sound/zubat/%s.mp3", SoundF[i]); 
        if(FileExists(Sound))
        {
            AddFileToDownloadsTable(Sound); 
            FormatEx(Sound, sizeof(Sound), "zubat/%s.mp3", SoundF[i]); 
            PrecacheSoundAny(Sound);
        }
    } 
} 

public RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)  
{ 
    EmitSoundV();
}  

EmitSoundV()
{
	for(new client=1; client<=MaxClients; client++)
	{
		if(SoundValue[client] == 0 && IsClientInGame(client))
		{
			new i = GetRandomInt(0, sizeof(SoundF)-1);  
			decl String:Sound[256]; 
			FormatEx(Sound, sizeof(Sound), "zubat/%s.mp3", SoundF[i]); 
			EmitSoundToClientAny(client, Sound); 
			 
		}
	}
}
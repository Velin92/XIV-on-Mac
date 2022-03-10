//
//  Steamworks.mm
//  
//
//  Created by Marc-Aurel Zent on 08.03.22.
//

#include <cstdlib>
#include <iostream>
#include "Headers/steam_api.h"
#include "Steamworks.h"

@implementation Steamworks : NSObject

- (id)init {
    if (self = [super init]) {
        putenv((char*)"SteamAppId=39210");
        putenv((char*)"SteamGameId=39210");
        _initSuccess = SteamAPI_Init();
    }
    return self;
}

- (void)dealloc {
    SteamAPI_Shutdown();
}

- (NSData *)authSessionTicket {
    if (!_initSuccess) {
        if (!(_initSuccess = SteamAPI_Init())) {
            return NULL;
        }
    }
    HAuthTicket m_hAuthTicket;
    char rgchToken[1024];
    uint32 unTokenLen = 0;
    m_hAuthTicket = SteamUser()->GetAuthSessionTicket( rgchToken, sizeof( rgchToken ), &unTokenLen );
    if ( unTokenLen < 1 )
        return NULL;
    return [NSData dataWithBytes:rgchToken length:unTokenLen];
}

- (uint32)serverRealTime {
    if (!_initSuccess)
        return 0;
    return SteamUtils()->GetServerRealTime();
}

@end
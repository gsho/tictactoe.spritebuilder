//  Constants.h
// Constants used in Tic Tac Slam


typedef enum {
    
    kNoSceneUninitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kHighScoresScene=3,
    kIntroScene=4,
    kLevelCompleteScene=5,
    kGameLevel1=101,
    kGameLevel2=102,
    kGameLevel3=103,
    kGameLevel4=104,
    kGameLevel5=105,
    kCutSceneForLevel2=201,
    kHUDLayer=202,
    kGameLayer=203,
    kAttemptsLabel=204,
    kElapsedTime=205,
    kScoreLabel=206,
    kGameCompleted=207
    
} SceneTypes;

typedef enum {
    
    kLinkTypeBookSite,
    kLinkTypeDeveloperSiteRod,
    kLinkTypeDeveloperSiteRay,
    kLinkTypeArtistSite,
    kLinkTypeMusicianSite
    
} LinkTypes;

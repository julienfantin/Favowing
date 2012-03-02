//
//  AppDelegate+Authentication.m
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWAppDelegate+API.h"
#import <objc/runtime.h>

#pragma mark - Authentication

#define kFWClientKey 0
#define kFWClientSecret 0
#define kFWRedirect @""

@interface FWAppDelegate (Authentication) <SCSoundCloudAPIAuthenticationDelegate>
@end

@implementation FWAppDelegate (Authentication)

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
    return [[FWAppDelegate api] handleRedirectURL:url];
}

- (void)soundCloudAPIDidAuthenticate;
{
    // big cheers!! the user sucesfully signed in
}

- (void)soundCloudAPIDidResetAuthentication;
{
    // the user did signed off
}

- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
{
    // inform your user and let him retry the authentication
}

@end

static char kFWSCAPI;

@implementation FWAppDelegate (API)

+ (SCSoundCloudAPI *)api
{
    @synchronized(self) {
        
        SCSoundCloudAPI *api = objc_getAssociatedObject([self class], &kFWSCAPI);
        
        if (api == nil)
        {
            // Init API object
            
            NSURL *redirectURL = [NSURL URLWithString:kFWRedirect];
            
            SCSoundCloudAPIConfiguration *apiConfig = [SCSoundCloudAPIConfiguration configurationForProductionWithClientID:kFWClientKey
                                                                                                              clientSecret:kFWClientSecret
                                                                                                               redirectURL:redirectURL];
            
            FWAppDelegate *__self = (FWAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            api = [[SCSoundCloudAPI alloc] initWithDelegate:__self
                                     authenticationDelegate:__self
                                           apiConfiguration:apiConfig];
            
            objc_setAssociatedObject([self class], &kFWSCAPI, api, OBJC_ASSOCIATION_RETAIN);
        }
        
        return api;
    }
}

@end


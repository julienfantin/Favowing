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

#define kFWClientKey @"39748626815d5841b6962200991ff5dc"
#define kFWClientSecret @"5864912c87c2b7cdf3ae01cae48f13b9"
#define kFWRedirect @"http://furious-stone-8299.herokuapp.com/callback.html"

@interface FWAppDelegate (Authentication) <SCSoundCloudAPIAuthenticationDelegate>
@end

@implementation FWAppDelegate (Authentication)

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
//{
//    return [[FWAppDelegate api] handleRedirectURL:url];
//}

- (void)soundCloudAPIDidAuthenticate
{
    NSLog(@"%@", NSStringFromSelector(_cmd));    
    
//    [[[self class] api] performMethod:@"GET" onResource:@"/me/favorites" withParameters:nil context:nil userInfo:nil];
}

- (void)soundCloudAPIDidResetAuthentication
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
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

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFailWithError:(NSError *)error context:(id)context userInfo:(id)userInfo
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#import "FWObject.h"
- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didFinishWithData:(NSData *)data context:(id)context userInfo:(id)userInfo
{
    NSLog(@"%@\n%@", NSStringFromSelector(_cmd), [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    [FWObject objectsWithData:data];
}

- (void)soundCloudAPI:(SCSoundCloudAPI *)soundCloudAPI didReceiveData:(NSData *)data context:(id)context userInfo:(id)userInfo
{
    
}

@end


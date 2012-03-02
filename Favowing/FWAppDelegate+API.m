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

//- (void)soundCloudAPIPreparedAuthorizationURL:(NSURL *)authorizationURL;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
{
    return [[FWAppDelegate api] handleRedirectURL:url];
}

- (void)soundCloudAPIDidAuthenticate
{
    NSLog(@"soundCloudAPIDidAuthenticate");
}

- (void)soundCloudAPIDidResetAuthentication
{
    NSLog(@"soundCloudAPIDidResetAuthentication");
}

- (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
{
    NSLog(@"soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;");
}

#pragma mark - Login View Controller

//- (void)soundCloudAPIWillDisplayLoginViewController:(SCLoginViewController *)soundCloudViewController
//{
//
//}
//
//- (void)soundCloudAPIDisplayViewController:(UIViewController *)soundCloudViewController
//{
//    [self.rootViewController presentModalViewController:soundCloudViewController animated:YES];    
//}

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


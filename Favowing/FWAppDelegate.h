//
//  FWAppDelegate.h
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWUser.h"

@interface FWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) FWUser *user;

+ (FWUser *)user;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

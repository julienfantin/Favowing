//
//  FWFavortiesOperation.h
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWAppDelegate+API.h"
#import "FWUser.h"

@interface FWFavortiesOperation : NSOperation <SCRequestContext>

- (id)initWithUser:(FWUser *)aUser;

@property (strong, nonatomic) FWUser *user;

@end

//
//  FWFollowingsOperation.h
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"
#import "FWUser.h"

@interface FWFollowingsOperation : FWOperation

- (id)initWithUser:(FWUser *)aUser;
@property (strong, nonatomic) FWUser *user;

@end

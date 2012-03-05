//
//  FWFavoritersOperation.h
//  Favowing
//
//  Created by Julien Fantin on 3/5/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWOperation.h"
#import "FWTrack.h"

@interface FWFavoritersOperation : FWOperation

- (id)initWithTrack:(FWTrack *)aTrack;
@property (strong, nonatomic) FWTrack *track;

@end

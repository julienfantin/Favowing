//
//  FWTrack.h
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWObject.h"
#import "SCAPI.h"

@interface FWTrack : FWObject

@property (strong, nonatomic) NSArray *favoriters;

@property (readonly, nonatomic) NSString *artist;
@property (readonly, nonatomic) NSString *title;
@property (readonly, nonatomic) BOOL isUserFavorite;
@property (readonly, nonatomic) BOOL isStreamable;
@property (readonly, nonatomic) SCAudioStream *audioStream;

@end

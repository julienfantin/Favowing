//
//  FWTrack.h
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FWSoundCloudClient <NSObject>
//- (void)
@end

@interface FWObject : NSObject

+ (id)objectsWithData:(NSData *)data;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSNumber *uid;


@end

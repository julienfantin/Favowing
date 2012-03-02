//
//  FWTrack.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWObject.h"

@interface FWObject ()
@property (strong, nonatomic) NSDictionary *data;
@end

@implementation FWObject

@synthesize data;

+ (id)objectsWithData:(NSData *)data
{
    NSError *error;
    id collection = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error) {
        // TODO
        NSLog(@"%@", error);
    }
    
    id instances = [NSMutableArray arrayWithCapacity:[collection count]];

    for (NSDictionary *dict in collection) {
        id instance = [[[self class] alloc] initWithDictionary:dict];
        [instances addObject:instance];
    }
    
    return instances;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{    
    self = [[self class] alloc];
    
    if (self) {
        self.data = dictionary;
    }
    
    return self;
}

#pragma mark - KVC

- (id)valueForUndefinedKey:(NSString *)key
{
    return [self.data objectForKey:key];
}

#pragma mark - Properties

- (NSNumber *)uid
{
    return [self.data objectForKey:@"id"];
}

@end
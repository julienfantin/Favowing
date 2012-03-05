//
//  FWTrack.m
//  Favowing
//
//  Created by Julien Fantin on 3/2/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWObject.h"

@interface FWObject ()
@property (strong, nonatomic) NSDictionary *dictionary;
@end

@implementation FWObject

@synthesize dictionary = _dictionary;

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
        self.dictionary = dictionary;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    FWObject *copy = [[[self class] allocWithZone:zone] initWithDictionary:self.dictionary];
    return copy;
}

#pragma mark - Identity

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[FWObject class]] == NO) {
        return NO;
    }

    // Ref comparison
    if (self == object) {
        return YES;
    }
    
    // UID comparison
    return [self.uid isEqual:[(FWObject *)object uid]];
}

- (NSUInteger)hash
{
    return self.dictionary.hash;
}

#pragma mark - KVC

- (id)valueForKey:(NSString *)key
{
    return [self.dictionary valueForKey:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{
    return [self.dictionary valueForKeyPath:keyPath];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [self.dictionary objectForKey:key];
}

#pragma mark - Properties

- (NSNumber *)uid
{
    return [self.dictionary objectForKey:@"id"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@\n%@", [super description], self.dictionary];
}

@end
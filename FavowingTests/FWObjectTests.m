//
//  FWObjectTests.m
//  FavowingTests
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWObjectTests.h"


@implementation FWObjectTests

@synthesize object;

- (NSDictionary *)dictionary
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"TrackFixture" ofType:@"json"];
    STAssertNotNil(file, @"No such file %@", file);
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:file];
    STAssertTrue([data length], @"No data");
    
    NSError *error;
    id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    STAssertNotNil(dict, @"Parsing failed");
    
    return dict;
}

- (void)setUp
{
    [super setUp];

    NSDictionary *dict = [self dictionary];
    self.object = [[FWObject alloc] initWithDictionary:dict];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testInitWithDictionary
{
    STAssertNotNil(self.object, @"Should create an object with a dictionary");
}

- (void)testAccessPropertiesWithKVC
{
    NSNumber *objectId = [self.object valueForKey:@"id"];
    STAssertEquals([objectId intValue], 38355820, @"Should access properties transparently");
    
}

- (void)testAccessPropertiesDinamically
{
    NSNumber *objectId = self.object.uid;
    STAssertEquals([objectId intValue], 38355820, @"Should access properties transparently");
}

- (void)testObjectsWithData
{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"FavoritesFixture" ofType:@"json"];
    STAssertNotNil(file, @"No such file %@", file);
        
    NSData *data = [[NSData alloc] initWithContentsOfFile:file];
    STAssertTrue([data length], @"No data");
        
    NSArray *objects = [FWObject objectsWithData:data];
    STAssertEquals([objects count], (NSUInteger)50, @"Should init a collection of objects using raw json data");
    
    FWObject *firstObject = [objects objectAtIndex:0];
    STAssertEquals([firstObject.uid intValue], 38355820, @"Should access properties transparently");
}

@end

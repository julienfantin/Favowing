//
//  FWRootViewController.m
//  Favowing
//
//  Created by Julien Fantin on 3/6/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWRootViewController.h"
#import "FWAppDelegate+API.h"
#import "FWFavoritesOperation.h"
#import "FWFollowingsOperation.h"
#import "FWRecommendationViewController.h"

@implementation FWRootViewController

@synthesize user;
@synthesize queue;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidAuthenticate) name:kSoundCloudAPIDidAuthenticateNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userDidAuthenticate
{
    FWFavoritesOperation *operation = [[FWFavoritesOperation alloc] initWithUser:self.user];
    operation.delegate = self;
    operation.fetchAll = YES;
    
    FWFollowingsOperation *operation2 = [[FWFollowingsOperation alloc] initWithUser:self.user];
    operation2.fetchAll = YES;
    
    [operation addDependency:operation2];

    [self.queue addOperation:operation];
    [self.queue addOperation:operation2];
}

- (void)operationDidFinish:(FWOperation *)operation
{
    [self performSegueWithIdentifier:@"userDidAuthenticate" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"userDidAuthenticate"]){
        FWRecommendationViewController *destination = (FWRecommendationViewController *)segue.destinationViewController;
        destination.queue = self.queue;
        destination.user = self.user;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

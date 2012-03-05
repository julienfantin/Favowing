//
//  FWMasterViewController.m
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavoritesViewController.h"
#import "FWAppDelegate+API.h"
#import "FWRecommendationViewController.h"
#import "FWUser.h"
#import "FWTrack.h"
#import "FWFavoritesOperation.h"
#import "FWRecommendationOperation.h"
#import "FWFollowingsOperation.h"

@interface FWFavoritesViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation FWFavoritesViewController

@synthesize user;
@synthesize queue;

@synthesize detailViewController = _detailViewController;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.user isEqual:[FWAppDelegate user]]) {
        self.title = @"My Favorites";
    }
    else {
        self.title = [NSString stringWithFormat:@"%@'s Favorites", self.user.name];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidAuthenticate) name:kSoundCloudAPIDidAuthenticateNotification object:nil];
    
    self.detailViewController = (FWRecommendationViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)userDidAuthenticate
{
    FWFavoritesOperation *operation = [[FWFavoritesOperation alloc] initWithUser:self.user];
    operation.delegate = self;
    operation.fetchAll = YES;
    [self.queue addOperation:operation];
    
    FWFollowingsOperation *operation2 = [[FWFollowingsOperation alloc] initWithUser:self.user];
    operation2.fetchAll = YES;
    [self.queue addOperation:operation2];
}

#pragma mark - <FWOperationDelegate>

- (void)operationDidFinish:(FWOperation *)operation
{
    [self.tableView reloadData];
}

- (void)operationDidFail:(FWOperation *)operation
{
    NSAssert(NO, @"BOOM");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.user.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FWTrack *track = [self.user.favorites objectAtIndex:indexPath.row];
        [[segue destinationViewController] setUser:self.user];
        [[segue destinationViewController] setTrack:track];
        [segue.destinationViewController setQueue:self.queue];
    }
}    

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FWTrack *track = [self.user.favorites objectAtIndex:indexPath.row];
    cell.textLabel.text = track.title;
}

@end

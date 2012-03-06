//
//  FWMasterViewController.m
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWFavoritesViewController.h"
#import "FWRecommendationViewController.h"
#import "FWUser.h"
#import "FWTrack.h"
#import "FWRecommendationOperation.h"

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

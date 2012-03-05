//
//  FWDetailViewController.m
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWRecommendationViewController.h"
#import "FWRecommendationOperation.h"

@interface FWRecommendationViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) NSArray *recommendations;
@property (nonatomic) NSUInteger shownPages;
@end

@implementation FWRecommendationViewController

@synthesize user = _user;
@synthesize track = _track;
@synthesize queue;
@synthesize recommendations;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize shownPages;

#pragma mark - Managing the detail item

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

    self.shownPages = 1;

    self.title = @"You may also like";
    FWRecommendationOperation *operation = [[FWRecommendationOperation alloc] initWithTrack:self.track andUser:self.user];
    operation.delegate = self;
    [self.queue addOperation:operation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - <FWOperationDelegate>

- (void)operationDidFail:(FWOperation *)operation
{
    
}

- (void)operationDidFinish:(FWOperation *)operation
{
    if ([operation isKindOfClass:[FWRecommendationOperation class]]) {
        self.recommendations = [(FWRecommendationOperation *)operation recommendations];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)MIN(self.shownPages * kFWRecommendationPageCount, self.recommendations.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shownPages * kFWRecommendationPageCount == indexPath.row + 1) {
        self.shownPages++;
        [self.tableView reloadData];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FWTrack *track = [self.recommendations objectAtIndex:indexPath.row];
    cell.textLabel.text = track.title;
}

@end

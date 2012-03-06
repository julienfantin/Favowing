//
//  FWDetailViewController.m
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import "FWRecommendationViewController.h"
#import "FWFavoritesViewController.h"
#import "FWRecommendationOperation.h"

@interface FWRecommendationViewController ()
@property (strong, nonatomic) FWTrack *track;
@property (strong, nonatomic) NSMutableSet *recommendedTracks;
- (void)configureView;
@end

@implementation FWRecommendationViewController

@synthesize user = _user;
@synthesize seedTrack = _seedTrack;
@synthesize track = _track;
@synthesize recommendations;
@synthesize queue;
@synthesize recommendedTracks;
@synthesize likeButton;
@synthesize followButton;
@synthesize imageView;
@synthesize artistLabel;
@synthesize trackLabel;
@synthesize descriptionLabel;

#pragma mark - Managing the detail item

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = @"Recommendations";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.recommendations != nil) {
        return;
    }
    
    NSSet *favorites = [NSSet setWithArray:self.user.favorites];
    self.seedTrack = [favorites anyObject];
    FWRecommendationOperation *operation = [[FWRecommendationOperation alloc] initWithTrack:self.seedTrack andUser:self.user];
    operation.delegate = self;
    [self.queue addOperation:operation];
}

- (void)viewDidUnload {
    [self setLikeButton:nil];
    [self setFollowButton:nil];
    [self setImageView:nil];
    [self setArtistLabel:nil];
    [self setTrackLabel:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
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

#pragma mark - <FWOperationDelegate>

- (void)operationDidFail:(FWOperation *)operation
{
    //
}

- (void)operationDidFinish:(FWOperation *)operation
{
    if ([operation isKindOfClass:[FWRecommendationOperation class]]) {
        self.recommendations = [(FWRecommendationOperation *)operation recommendations];
    }
    
    [self configureView];
}

- (void)configureView
{
    if (self.track != nil) {
        [self.recommendedTracks addObject:self.track];
        [self.track.audioStream pause];
    }
    
    // Filter out the tracks we've already recommended
    NSMutableSet *tracks = [NSMutableSet setWithArray:self.recommendations];
    [tracks minusSet:self.recommendedTracks];

    self.track = [tracks anyObject];;
    
    self.artistLabel.text = self.track.user.name;
    self.trackLabel.text = self.track.title;
    
    [self.track.audioStream play];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pickSeedTrack"]){
        FWFavoritesViewController *vc = (FWFavoritesViewController *)[segue destinationViewController];
        vc.user = self.user;
        vc.queue = self.queue;
    }
}

@end

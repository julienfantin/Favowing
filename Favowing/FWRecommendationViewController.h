//
//  FWDetailViewController.h
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWUser.h"
#import "FWTrack.h"
#import "FWOperation.h"

#define kFWRecommendationPageCount 25

@interface FWRecommendationViewController : UIViewController <UISplitViewControllerDelegate,
                                                              FWOperationDelegate>

@property (strong, nonatomic) FWUser *user;
@property (strong, nonatomic) NSOperationQueue *queue;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;

@end

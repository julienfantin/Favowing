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

@interface FWRecommendationViewController : UITableViewController <UISplitViewControllerDelegate,
                                                                   FWOperationDelegate>

@property (strong, nonatomic) FWUser *user;
@property (strong, nonatomic) FWTrack *track;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

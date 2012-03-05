//
//  FWMasterViewController.h
//  Favowing
//
//  Created by Julien Fantin on 3/1/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWOperation.h"
@class FWRecommendationViewController;
@class FWUser;

@interface FWFavoritesViewController : UITableViewController <FWOperationDelegate>

@property (strong, nonatomic) FWRecommendationViewController *detailViewController;
@property (strong, nonatomic) FWUser *user;
@property (strong, nonatomic) NSOperationQueue *queue;

@end

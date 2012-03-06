//
//  FWRootViewController.h
//  Favowing
//
//  Created by Julien Fantin on 3/6/12.
//  Copyright (c) 2012 C6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWOperation.h"
@class FWUser;

@interface FWRootViewController : UIViewController <FWOperationDelegate>

@property (strong, nonatomic) FWUser *user;
@property (strong, nonatomic) NSOperationQueue *queue;

- (void)doSegue:(id)sender;

@end

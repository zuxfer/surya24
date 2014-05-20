//
//  MasterViewController.h
//  surya24
//
//  Created by Surya on 12/05/14.
//  Copyright (c) 2014 zemoso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController {
    NSArray *tweets;
    NSArray *formats;
    NSString *id_str;
    IBOutlet UIImageView *profileImage1;


}

- (void)fetchTweets;


@end

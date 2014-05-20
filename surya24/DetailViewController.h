//
//  DetailViewController.h
//  surya24
//
//  Created by Surya on 12/05/14.
//  Copyright (c) 2014 zemoso. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *profileImage;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *tweetLabel;
    IBOutlet UIImageView *tweetImage;
    NSArray *formats;
}

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

//
//  DetailViewController.m
//  surya24
//
//  Created by Surya on 12/05/14.
//  Copyright (c) 2014 zemoso. All rights reserved.
//

#import "DetailViewController.h"
#import "CoreText/CoreText.h"

@interface DetailViewController ()
- (void)configureView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    //tweetImage.hidden = YES;
    if (self.detailItem) {
        NSDictionary *tweet = self.detailItem;
        
        NSData* styles = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: @"file:///Users/surya/Desktop/Apps/surya24/surya24/style.json"]];
        
        //https1://raw.githubusercontent.com/EngForDev/Simple-Twitter-Bot/master/python-twitter-0.6/testdata/public_timeline.json
        
        NSError* error;
        
        formats = [NSJSONSerialization JSONObjectWithData:styles
                                                  options:kNilOptions
                                                    error:&error];
        
        NSDictionary *format = [formats objectAtIndex:0];
        NSString *usernamecolor = [format objectForKey:@"usernamecolor"];
        NSString *tweetcolor = [format objectForKey:@"tweetcolor"];
        NSString *hashtagcolor = [format objectForKey:@"hashtagcolor"];
        NSString *urlcolor = [format objectForKey:@"urlcolor"];
        NSString *mentioncolor = [format objectForKey:@"mentioncolor"];
        NSString *tweetfont = [format objectForKey:@"tweetfont"];
        NSString *tweetsize = [format objectForKey:@"tweetsize"];
        NSString *usernamefont = [format objectForKey:@"usernamefont"];
        NSString *usernamesize = [format objectForKey:@"usernamesize"];
        
        
        
        
        SEL tweetselector = NSSelectorFromString(tweetcolor);
        SEL usernameselector = NSSelectorFromString(usernamecolor);
        SEL hashtagselector = NSSelectorFromString(hashtagcolor);
        SEL urlselector = NSSelectorFromString(urlcolor);
        SEL mentionselector = NSSelectorFromString(mentioncolor);
        UIFont *mytweetFont = [ UIFont fontWithName: tweetfont size: [tweetsize intValue] ];
        UIFont *myusernameFont = [ UIFont fontWithName: usernamefont size: [usernamesize intValue] ];
        
        
        NSString *text = [[tweet objectForKey:@"user"] objectForKey:@"name"];
        NSString *name = [tweet objectForKey:@"text"];
        
        tweetLabel.lineBreakMode = UILineBreakModeWordWrap;
        tweetLabel.numberOfLines = 0;

        NSArray *split = [name componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
        NSString *res = [split componentsJoinedByString:@" "];
        NSArray *words = [res componentsSeparatedByString:@" "];
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:name];

        
        nameLabel.textColor = [UIColor performSelector:usernameselector];
        tweetLabel.textColor = [UIColor performSelector:tweetselector];
        nameLabel.font = myusernameFont;
        tweetLabel.font = mytweetFont;
        
        for (NSString *word in words) {

            if ([word hasPrefix:@"#"]) {
                // Colour your 'word' here
                NSRange matchRange = [name rangeOfString:word];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:hashtagselector] range:matchRange];
                // Remember to import CoreText framework (the constant is defined there)
                
            }
            
            if ([word hasPrefix:@"@"]) {
                // Colour your 'word' here
                NSRange matchRange = [name rangeOfString:word];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:mentionselector] range:matchRange];
                // Remember to import CoreText framework (the constant is defined there)
                
            }
            if ([word hasPrefix:@"http"]) {
                // Colour your 'word' here
                NSRange matchRange = [name rangeOfString:word];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:urlselector] range:matchRange];

                // Remember to import CoreText framework (the constant is defined there)
                
            }
        }
        

        
        nameLabel.text = text;
        tweetLabel.attributedText = attrString;
        

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
            imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_normal"
                                                           withString:@""];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                profileImage.image = [UIImage imageWithData:data];
            });
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

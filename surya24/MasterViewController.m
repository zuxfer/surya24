//
//  MasterViewController.m
//  surya24
//
//  Created by Surya on 12/05/14.
//  Copyright (c) 2014 zemoso. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    UIActivityIndicatorView *_indicator;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame = CGRectMake(10.0, 10.0, 30, 30.0);
    _indicator.center = self.view.center;
    [self.view addSubview:_indicator];
    [_indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;


}
-(void)viewWillAppear:(BOOL)animated{
    
    [self readCache];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self fetchTweets];
}
-(void)readCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"tweetdata.json"];
    //id_str = @"NIL";
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (fileExists) {
        NSData *existingData = [NSData dataWithContentsOfFile:filePath];
        tweets = [NSJSONSerialization JSONObjectWithData:existingData options:kNilOptions error:nil];
        id_str = [[tweets objectAtIndex:0] objectForKey:@"id_str"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)fetchTweets
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://zuxfer.com/tweets/littleApp.php"]];
        
        //https1://raw.githubusercontent.com/EngForDev/Simple-Twitter-Bot/master/python-twitter-0.6/testdata/public_timeline.json
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];

        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"tweetdata.json"];
        
        [data writeToFile:filePath atomically:YES];
        NSError* error;
        
        tweets = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        NSString *id_str1 = [[tweets objectAtIndex:0] objectForKey:@"id_str"];
        
        [self hideProgressIndicator];
        if(id_str != id_str1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    });
    [self showProgressIndicator];
    
}

- (void)showProgressIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator startAnimating];
    });
   
}

- (void)hideProgressIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicator stopAnimating];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
    NSString *text = [tweet objectForKey:@"text"];
    NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
        //imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"_normal"
          //                                   withString:@""];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:data];
        });
    });
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
    cell.textLabel.font = myusernameFont;
    cell.detailTextLabel.font = mytweetFont;
    

    
    NSArray *split = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    split = [split filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    NSString *res = [split componentsJoinedByString:@" "];
    NSArray *words = [res componentsSeparatedByString:@" "];
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:text];
    
    for (NSString *word in words) {
        
        if ([word hasPrefix:@"#"]) {
            // Colour your 'word' here
            NSRange matchRange = [text rangeOfString:word];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:hashtagselector] range:matchRange];
            // Remember to import CoreText framework (the constant is defined there)
            
        }
        
        if ([word hasPrefix:@"@"]) {
            // Colour your 'word' here
            NSRange matchRange = [text rangeOfString:word];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:mentionselector] range:matchRange];
            // Remember to import CoreText framework (the constant is defined there)
            
        }
        if ([word hasPrefix:@"http"]) {
            // Colour your 'word' here
            NSRange matchRange = [text rangeOfString:word];
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor performSelector:urlselector] range:matchRange];
            // Remember to import CoreText framework (the constant is defined there)
            
        }
    }
    
    

    
    cell.textLabel.text = name;
    cell.textLabel.textColor = [UIColor performSelector:usernameselector];
    cell.detailTextLabel.textColor = [UIColor performSelector:tweetselector];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", text];
    cell.detailTextLabel.attributedText = attrString;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showTweet"]) {
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        NSDictionary *tweet = [tweets objectAtIndex:row];
        
        DetailViewController *detailController = segue.destinationViewController;
        detailController.detailItem = tweet;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end

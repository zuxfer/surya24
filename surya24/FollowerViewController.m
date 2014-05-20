//
//  FollowerViewController.m
//  surya24
//
//  Created by Surya on 13/05/14.
//  Copyright (c) 2014 zemoso. All rights reserved.
//

#import "FollowerViewController.h"


@interface FollowerViewController ()

@end

@implementation FollowerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchFollowers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchFollowers
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"file:///Users/surya/Desktop/Apps/surya24/surya24/friendslist.json"]];
        
        //https1://raw.githubusercontent.com/EngForDev/Simple-Twitter-Bot/master/python-twitter-0.6/testdata/public_timeline.json
        
        NSError* error;
        
        followers = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"fUsername";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  

    NSDictionary *tweet1 = [followers objectAtIndex:0];
    NSArray *tweet2 = [tweet1 objectForKey:@"users"];
    NSDictionary *tweet = [tweet2 objectAtIndex:indexPath.row];
    NSString *name = [tweet objectForKey:@"name"];
    //NSString *arr1 = [[tweet objectForKey:@"ids"] objectAtIndex:indexPath.row];
    //NSInteger text = arr1[indexPath.row];
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.zuxfer.com/p.php?id=%@", arr1]];;
    //NSData *data = [NSData dataWithContentsOfURL:url];
    
    // Assuming data is in UTF8.
   // NSString *string = [NSString stringWithUTF8String:[data bytes]];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@", string];
    cell.textLabel.text = name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@", arr1];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}



@end

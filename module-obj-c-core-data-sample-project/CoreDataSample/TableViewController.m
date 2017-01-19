//
//  TableViewController.m
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "TableViewController.h"

NSString *const kCDSCellIdentifier = @"Cell";
NSString *const kCDSSegueIdentifierUserView = @"UserView";

@interface TableViewController ()

@property (nonatomic) NSInteger row;
@property (strong, nonatomic) NSArray *userList;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation TableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Initialization of private attributes
    self.row = -1;
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.context = delegate.managedObjectContext;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.locale = [NSLocale currentLocale];
    
    // UITableView
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Fetch User instances
    self.userList = [self fetchUserInstances];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)deleteUserInstanceAtRow:(NSInteger)row {
    NSError *error;
    
    [self.context deleteObject:[self.userList objectAtIndex:row]];
    
    if (![self.context save:&error]) {
        NSLog(@"Error occured during Core Data instance deletion: %@", [error localizedDescription]);
    }
}

- (NSArray *)fetchUserInstances {
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kCDSEntityUser];
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"Fetched successfully");
    } else {
        NSLog(@"Error occured during Core Data fetching: %@", [error localizedDescription]);
    }
    
    return results;
}

- (NSArray *)sortUserInstancesAsAscending:(BOOL)ascending {
    NSError *error;
    NSArray *results;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:ascending];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kCDSEntityUser];
    request.sortDescriptors = @[sort];
    results = [self.context executeFetchRequest:request error:&error];
    
    if (!error) {
        NSLog(@"Fetched successfully");
    } else {
        NSLog(@"Error occured during Core Data fetching: %@", [error localizedDescription]);
        
        return nil;
    }
    
    return results;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCDSCellIdentifier
                                                            forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kCDSCellIdentifier];
    }
    
    User *user = [self.userList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Hobby: %@", user.hobby ? user.hobby.name : @"None"];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.row = indexPath.row;
    
    // Move to User view
    [self performSegueWithIdentifier:kCDSSegueIdentifierUserView sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Delete User instance from database
        [self deleteUserInstanceAtRow:indexPath.row];
        
        // Update User List array
        self.userList = [self fetchUserInstances];
        
        [self.tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCDSSegueIdentifierUserView]) {
        BOOL hasUser = self.row > -1;
        ViewController *controller = (ViewController *)[segue destinationViewController];
        controller.user = hasUser ? [self.userList objectAtIndex:self.row] : nil;
        controller.title = hasUser ? @"Update User" : @"Add User";
    }
}

#pragma mark - UIBarButtonItem Actions

- (IBAction)onAddBarButtonClick:(id)sender {
    self.row = -1;
    
    [self performSegueWithIdentifier:kCDSSegueIdentifierUserView sender:self];
}

- (IBAction)onSortBarButtonClick:(id)sender {
    BOOL ascending = [self.sortBarButton.title isEqualToString:@"A-Z"];
    self.userList = [self sortUserInstancesAsAscending:ascending];
    self.sortBarButton.title = ascending ? @"Z-A" : @"A-Z";
    
    // Reload Table
    [self.tableView reloadData];
}

@end

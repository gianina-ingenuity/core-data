//
//  TableViewController.h
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface TableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortBarButton;

- (IBAction)onAddBarButtonClick:(id)sender;
- (IBAction)onSortBarButtonClick:(id)sender;

@end

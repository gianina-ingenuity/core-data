//
//  ViewController.h
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Hobby.h"
#import "User.h"

extern NSString *const kCDSEntityUser;
extern NSString *const kCDSEntityHobby;

@interface ViewController : UIViewController

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *hobbiesTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)onSaveBarButtonClick:(id)sender;

@end


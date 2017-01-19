//
//  ViewController.m
//  CoreDataSample
//
//  Created by Jason Jon E. Carreos on 08/08/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ViewController.h"

NSString *const kCDSEntityUser = @"User";
NSString *const kCDSEntityHobby = @"Hobby";

@interface ViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize private properties
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.context = delegate.managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Populate form
    [self populateUserFormWithUserInfo:self.user];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Reset form
    [self populateUserFormWithUserInfo:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (Hobby *)addNewHobbyInstanceWithName:(NSString *)name {
    NSError *error;
    
    // Create a Hobby instance
    Hobby *hobby = [self createEntityInstanceForName:kCDSEntityHobby];
    hobby.name = name;
    
    // Save User instance
    if (![self.context save:&error]) {
        NSLog(@"Error occured during Core Data saving: %@", [error localizedDescription]);
    } else {
        NSLog(@"Hobby successfully saved");
    }
    
    return hobby;
}

- (void)addNewUserInstance {
    NSError *error;
    
    // Create a User instance
    User *user = [self createEntityInstanceForName:kCDSEntityUser];
    user.firstName = self.firstNameTextField.text;
    user.lastName = self.lastNameTextField.text;
    user.birthDate = self.datePicker.date;
    
    // Add Hobby
    if (self.hobbiesTextField.text.length > 0) {
        user.hobby = [self checkHobbyInstanceWithName:self.hobbiesTextField.text];
    }
    
    // Save User instance
    if (![self.context save:&error]) {
        NSLog(@"Error occured during Core Data saving: %@", [error localizedDescription]);
    } else {
        NSLog(@"User successfully saved");
    }
}

- (Hobby *)checkHobbyInstanceWithName:(NSString *)name {
    NSError *error;
    NSArray *results;
    NSFetchRequest *request;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE [c] %@", name];
    
    request = [NSFetchRequest fetchRequestWithEntityName:kCDSEntityHobby];
    request.predicate = predicate;
    
    results = [self.context executeFetchRequest:request error:&error];
    
    return results && results.count > 0 ? [results firstObject] : [self addNewHobbyInstanceWithName:name];
}
                    
- (__kindof NSManagedObject *)createEntityInstanceForName:(NSString *)name {
    return [NSEntityDescription insertNewObjectForEntityForName:name
                                         inManagedObjectContext:self.context];
}

- (void)populateUserFormWithUserInfo:(BOOL)hasUser {
    self.firstNameTextField.text = hasUser ? self.user.firstName : @"";
    self.lastNameTextField.text = hasUser ? self.user.lastName : @"";
    self.hobbiesTextField.text = hasUser ? self.user.hobby.name : @"";
    
    [self.datePicker setDate:hasUser ? self.user.birthDate : [NSDate date]];
}

- (void)updateUserInstance {
    NSError *error;
    
    // Update a User instance
    self.user.firstName = self.firstNameTextField.text;
    self.user.lastName = self.lastNameTextField.text;
    self.user.birthDate = self.datePicker.date;
    
    // Update Hobby
    if (self.hobbiesTextField.text.length > 0) {
        self.user.hobby = [self checkHobbyInstanceWithName:self.hobbiesTextField.text];
    }
    
    // Save User instance
    if (![self.context save:&error]) {
        NSLog(@"Error occured during Core Data saving: %@", [error localizedDescription]);
    }
}

#pragma mark - UIBarButtonItem Actions

- (IBAction)onSaveBarButtonClick:(id)sender {
    // Validate if the First and Last name text fields are empty
    if (self.firstNameTextField.text.length == 0 || self.lastNameTextField.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:@"Fill out necessary information."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil]];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        
        return;
    }
    
    if (self.user) {
        [self updateUserInstance];
    } else {
        [self addNewUserInstance];
    }
    
    // Back to User List view
    [self.navigationController popViewControllerAnimated:YES];
}

@end

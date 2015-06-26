//
//  FISViewController.m
//  validatedSignUp
//
//  Created by Joe Burgess on 7/2/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSArray *arrayOfFields;
@property (nonatomic) NSInteger count;

@end

@implementation FISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.count = 0;
    self.firstName.delegate = self;
    self.lastName.delegate = self;
    self.email.delegate = self;
    self.userName.delegate = self;
    self.password.delegate = self;
    self.arrayOfFields = @[self.firstName, self.lastName, self.email, self.userName, self.password];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.password)
    {
        if ([self validatePassword])
        {
            [textField resignFirstResponder];
            self.submitButton.enabled = YES;
        }
        else{
            [self errorWithMessage:@"Passwords must be at least 6 characters" onTextField:textField];
        }
    }
    else if (textField == self.email)
    {
        if ([self validateEmail:textField.text])
        {
            self.count ++;
            [self nextTextField];
        }
        else{
            [self errorWithMessage:@"Enter a valid email" onTextField:textField];
        }
        
    }
    else
    {
        if ([self validateName:textField])
        {
            [textField resignFirstResponder];
            self.count ++;
            [self nextTextField];
        }
        else
        {
            [self errorWithMessage:@"Enter a valid name" onTextField:textField];
        }
    }
    return NO;
}

-(void)nextTextField
{
    UITextField *nextField = self.arrayOfFields[self.count];
    nextField.enabled = YES;
    [nextField becomeFirstResponder];
}

#pragma mark - Validation Methods
-(BOOL)validateName:(UITextField *)textField
{
    NSCharacterSet *onlyLetters = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *textFieldString = [NSCharacterSet characterSetWithCharactersInString:textField.text];
    
    if ((textField.text.length > 0) && ([onlyLetters isSupersetOfSet:textFieldString]))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)validatePassword
{
    if (self.password.text.length > 6)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - Error Message Method
-(void)errorWithMessage:(NSString *)message onTextField:(UITextField *)textField
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *clear = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        textField.text = @"";
    }];
    
    [alert addAction:clear];
    [alert addAction:ok];
    
    return [self presentViewController:alert animated:YES completion:nil];
}



@end

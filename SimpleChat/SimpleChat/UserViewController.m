//
//  UserViewController.m
//  SimpleChat
//
//  Created by Wendy H. Chun on 5/25/15.
//  Copyright (c) 2015 Wendy H. Chun. All rights reserved.
//

#import "UserViewController.h"
#import "ViewController.h"

@interface UserViewController ()
@end

@implementation UserViewController

@synthesize userField;
@synthesize userButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [userButton setEnabled:NO];
    
    [[self userField] becomeFirstResponder];
    [userField addTarget:self action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ChatViewController"]) {
        ViewController *vc = [segue destinationViewController];
        vc.name = self.userField.text;
    }
}

- (void)textFieldDidChange {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *newStr = [userField.text stringByTrimmingCharactersInSet:whitespace];    
    if ([newStr length] == 0)
        [userButton setEnabled:NO];
    else
        [userButton setEnabled:YES];
}

@end
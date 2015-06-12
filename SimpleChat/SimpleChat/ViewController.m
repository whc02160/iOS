//
//  ViewController.m
//  SimpleChat
//
//  Created by Wendy H. Chun on 5/25/15.
//  Copyright (c) 2015 Wendy H. Chun. All rights reserved.
//

#import "ViewController.h"

#define firechatNS @"https://crackling-inferno-4363.firebaseio.com"

@interface ViewController ()
@property (nonatomic) BOOL newMessagesOnTop;
@end

@implementation ViewController

@synthesize chatUser;
@synthesize chatField;
@synthesize chatTable;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chat = [[NSMutableArray alloc] init];
    self.firebase = [[Firebase alloc] initWithUrl:firechatNS];
    [chatUser setTitle:self.name forState:UIControlStateNormal];
    
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)
     {
        [self.chat insertObject:snapshot.value atIndex:0];
        
        if (!initialAdds)
            [chatTable reloadData];
    }];
    
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [chatTable reloadData];
        initialAdds = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    
    [[self.firebase childByAutoId] setValue:@{@"name" : self.name, @"text": aTextField.text}];
    
    [aTextField setText:@""];
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return [self.chat count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    NSString *text = chatMessage[@"text"];
    
    const CGFloat TEXT_LABEL_WIDTH = 260;
    CGSize constraint = CGSizeMake(TEXT_LABEL_WIDTH, 20000);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping]; // requires iOS 6+
    const CGFloat CELL_CONTENT_MARGIN = 22;
    CGFloat height = MAX(CELL_CONTENT_MARGIN + size.height, 44);
    
    return height;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary* chatMessage = [self.chat objectAtIndex:index.row];
    
    cell.textLabel.text = chatMessage[@"text"];
    cell.detailTextLabel.text = chatMessage[@"name"];
    [cell.detailTextLabel setTextColor:[UIColor blueColor]];
    
    return cell;
}

//// Subscribe to keyboard show/hide notifications.
//- (void)viewWillAppear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(keyboardWillShow:)
//     name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(keyboardWillHide:)
//     name:UIKeyboardWillHideNotification object:nil];
//}
//
//// Unsubscribe from keyboard show/hide notifications.
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
//
//// Setup keyboard handlers to slide the view containing the table view and
//// text field upwards when the keyboard shows, and downwards when it hides.
//- (void)keyboardWillShow:(NSNotification*)notification
//{
//    [self moveView:[notification userInfo] up:YES];
//}
//
//- (void)keyboardWillHide:(NSNotification*)notification
//{
//    [self moveView:[notification userInfo] up:NO];
//}
//
//- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
//{
//    CGRect keyboardEndFrame;
//    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
//     getValue:&keyboardEndFrame];
//    
//    UIViewAnimationCurve animationCurve;
//    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
//     getValue:&animationCurve];
//    
//    NSTimeInterval animationDuration;
//    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
//     getValue:&animationDuration];
//    
//    // Get the correct keyboard size to we slide the right amount.
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
//    
//    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
//    int y = keyboardFrame.size.height * (up ? -1 : 1);
//    self.view.frame = CGRectOffset(self.view.frame, 0, y);
//    
//    [UIView commitAnimations];
//}
//
//// This method will be called when the user touches on the tableView, at
//// which point we will hide the keyboard (if open). This method is called
//// because UITouchTableView.m calls nextResponder in its touch handler.
//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    if ([chatField isFirstResponder]) {
//        [chatField resignFirstResponder];
//    }
//}

@end
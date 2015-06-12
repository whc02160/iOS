//
//  ViewController.h
//  SimpleChat
//
//  Created by Wendy H. Chun on 5/25/15.
//  Copyright (c) 2015 Wendy H. Chun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* firebase;

@property (weak, nonatomic) IBOutlet UIButton *chatUser;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (weak, nonatomic) IBOutlet UITextField *chatField;

@end


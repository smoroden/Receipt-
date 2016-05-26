//
//  ViewController.m
//  Receipts++
//
//  Created by Zach Smoroden on 2016-05-26.
//  Copyright © 2016 Zach Smoroden. All rights reserved.
//

#import "ViewController.h"


static NSString * const kReceiptCellReuseIdentifier = @"Cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation ViewController

#pragma mark - ViewController Lifecycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Actions -
- (IBAction)addReceipt:(UIButton*)sender {
}

#pragma mark - UITableViewDataSource - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
}


#pragma mark - UITableViewDelegate -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kReceiptCellReuseIdentifier];
    
    cell.textLabel.text = @"test";
    
    return cell;
}

@end

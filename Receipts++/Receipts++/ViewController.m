//
//  ViewController.m
//  Receipts++
//
//  Created by Zach Smoroden on 2016-05-26.
//  Copyright © 2016 Zach Smoroden. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Receipt.h"
#import "Tag.h"


static NSString * const kReceiptCellReuseIdentifier = @"Cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *receipts;

@end



@implementation ViewController

#pragma mark - ViewController Lifecycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshReceipts];
    
    [self newReciept];
    
}

#pragma mark - General Methods -
-(void)refreshReceipts {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"", ];
//    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    self.receipts = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.receipts == nil) {
        NSLog(@"Error making the fetch");
    }
    
    [self.tableView reloadData];
}

-(void)newReciept {
    
    Receipt *newReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    
    newReceipt.note = @"a test note";
    newReceipt.amount = 50.0;
//    newReceipt.tags
    
    NSError *error;
    
    [self.managedObjectContext save:&error];
    
    
}

#pragma mark - Actions -
- (IBAction)addReceipt:(UIButton*)sender {
}

#pragma mark - UITableViewDataSource - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.receipts.count;
}


#pragma mark - UITableViewDelegate -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kReceiptCellReuseIdentifier];
    
    Receipt *receipt = self.receipts[indexPath.row];
    cell.textLabel.text = receipt.note;
    
    return cell;
}

@end

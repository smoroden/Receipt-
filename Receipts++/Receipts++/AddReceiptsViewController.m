//
//  AddReceiptsViewController.m
//  Receipts++
//
//  Created by Zach Smoroden on 2016-05-26.
//  Copyright © 2016 Zach Smoroden. All rights reserved.
//

#import "AddReceiptsViewController.h"
#import <CoreData/CoreData.h>
#import "Tag.h"
#import "Receipt.h"

static NSString * const kCategoryCellReuseIdentifier = @"CategoryCell";


@interface AddReceiptsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@property (nonatomic) NSArray *tags;

@end

@implementation AddReceiptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.amountTextField.delegate = self;
    self.descriptionTextField.delegate = self;
}


#pragma mark - UITableViewDataSource -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.tags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.tags == nil) {
        return 0;
        
    }
    
    return self.tags.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCategoryCellReuseIdentifier];
    
    Tag *tag = self.tags[indexPath.row];
    
    cell.textLabel.text = tag.tagName;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Category";
}

#pragma mark - Actions -
- (IBAction)addReceipt:(UIButton *)sender {
    
    Receipt *newReceipt = [NSEntityDescription insertNewObjectForEntityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    
    newReceipt.note = self.descriptionTextField.text;
    newReceipt.amount = [self.amountTextField.text doubleValue];
    newReceipt.timeStamp = self.datePicker.date;
    
    NSMutableSet *tagsToAdd = [NSMutableSet set];
    
    for (NSIndexPath *path in [self.categoryTableView indexPathsForSelectedRows]) {
        [tagsToAdd addObject:self.tags[path.row]];
    }
    
    [newReceipt addTags:tagsToAdd];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    
    if(!error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}
- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return [textField resignFirstResponder];
}

#pragma mark - General Methods -

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

@end

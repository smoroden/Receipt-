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
#import "AddReceiptsViewController.h"

static NSString * const kReceiptCellReuseIdentifier = @"Cell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *receipts;
@property (nonatomic) NSArray *tags;

@end



@implementation ViewController

#pragma mark - ViewController Lifecycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(![defaults boolForKey:@"hasSetupTags"]) {
        [self setupTags];
        [defaults setBool:YES forKey:@"hasSetupTags"];
    }
    
   
    [self loadTags];
    
    [self refreshReceipts];
    
    
    
    [self newReciept];
    
    
    
}

#pragma mark - Segues -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddReceiptSegue"]) {
        AddReceiptsViewController *destinationVC = segue.destinationViewController;
        
        destinationVC.managedObjectContext = self.managedObjectContext;
    }
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
    
    newReceipt.timeStamp = [[NSDate date]timeIntervalSinceReferenceDate] ;
    
    [newReceipt addTagsObject:self.tags[arc4random_uniform(self.tags.count)]];
    
    [self save];
    
    [self refreshReceipts];
    
    
}

-(void)setupTags {
    
    NSArray *names = @[@"Business", @"Personal", @"Family"];
    
    for (NSString *name in names) {
        Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
        newTag.tagName = name;
    }
    [self save];
    
}

-(void)loadTags {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"", ];
//    [fetchRequest setPredicate:predicate];
//    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tagName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    self.tags = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.tags == nil) {
        NSLog(@"error fetching tags");
    }
}

-(void)save {
    NSError *error;
    
    [self.managedObjectContext save:&error];
    
    if(error)
        NSLog(@"There was an error: %@", error.description);
}

#pragma mark - Actions -
- (IBAction)addReceipt:(UIButton*)sender {
}

#pragma mark - UITableViewDataSource - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tags.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    Tag *tag = self.tags[section];
    
    return tag.tagName;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Tag *tag = self.tags[section];
    return tag.receipts.count;
}




#pragma mark - UITableViewDelegate -

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kReceiptCellReuseIdentifier];
    
    Tag *currentTag = self.tags[indexPath.section];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receipt" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY tags.tagName like %@", currentTag.tagName];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching the receipts for tag");
    }
    
    Receipt *receipt = fetchedObjects[indexPath.row];
    cell.textLabel.text = receipt.note;
    
    return cell;
}

@end

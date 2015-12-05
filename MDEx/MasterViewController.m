//
//  MasterViewController.m
//  MDEx
//
//  Created by Michael Sevy on 12/3/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Color.h"
#import "VenueData.h"


@interface MasterViewController ()

@property NSMutableArray *objects;

@property NSArray *venues;
@property NSMutableArray *pertinentData;


@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    self.tableView.delegate = self;

    self.venues = [NSArray new];
    self.pertinentData = [NSMutableArray new];

    self.navigationController.hidesBarsOnSwipe = YES;
    self.navigationItem.title = @"NFL 12";
    [self.navigationController.navigationBar setBarTintColor:[Color nflBlue]];

    self.automaticallyAdjustsScrollViewInsets = NO;


//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[Color nflBlue]];

    [self getNflData];
}



//- (void)insertNewObject:(id)sender {
//    if (!self.objects) {
//        self.objects = [[NSMutableArray alloc] init];
//    }
//    [self.objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        VenueData *ven = [self.pertinentData objectAtIndex:indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];

        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.sAddress = ven.streetNo;
        controller.sCityStateZip = ven.cityStateZip;
        controller.sName = ven.venueName;
        controller.sImageData = ven.imageData;
        controller.sSchdeule = ven.schedules;

    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pertinentData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    VenueData *venue = [self.pertinentData objectAtIndex:indexPath.row];

    cell.textLabel.text = venue.venueName;
    cell.detailTextLabel.text = venue.address;
    cell.imageView.image = [UIImage imageWithData:venue.imageData];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}


#pragma mark -- helpers
-(void)getNflData{

    NSString *urlString = [NSString stringWithFormat:@"https://s3.amazonaws.com/jon-hancock-phunware/nflapi-static.json"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData * _Nullable data,
                                NSURLResponse * _Nullable response,
                                NSError * _Nullable error) {
                if (!error) {

                    self.venues = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];

                    for (NSDictionary *item in self.venues) {

                        VenueData *ven = [VenueData new];

                        NSString *name = item[@"name"];
                        NSString *address = item[@"address"];
                        NSString *image = item[@"image_url"];
                        NSString *city = item[@"city"];
                        NSString *state = item[@"state"];
                        NSString *zip = item[@"zip"];
                        NSString *addressCityStateZip = [NSString stringWithFormat:@"%@, %@, %@ %@", address, city, state, zip];
                        NSString *cityStateZip = [NSString stringWithFormat:@"%@, %@ %@", city, state, zip];
                        NSArray *array = item[@"schedule"];

                        ven.streetNo = address;
                        ven.address = addressCityStateZip;
                        ven.cityStateZip = cityStateZip;
                        ven.schedules = array;
                        ven.venueName = name;
                        ven.imageURLString = image;
                        [ven convertStringToData:image];

                        [self.pertinentData addObject:ven];

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                }
            }]
     resume];
}

@end










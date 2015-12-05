//
//  DetailViewController.h
//  MDEx
//
//  Created by Michael Sevy on 12/3/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property NSString *sName;
@property NSString *sAddress;
@property NSString *sCityStateZip;
@property NSData *sImageData;
@property NSArray *sSchdeule;
@property (nonatomic, strong) NSString *detailItem;



@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (weak, nonatomic) IBOutlet UITextView *scheduleTextView;

@end


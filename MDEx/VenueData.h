//
//  VenueData.h
//  MDEx
//
//  Created by Michael Sevy on 12/5/15.
//  Copyright © 2015 Michael Sevy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueData : NSObject

@property NSString *venueName;
@property NSString *address;
@property NSString *streetNo;
@property NSString *cityStateZip;
@property NSString *imageURLString;
@property NSData *imageData;
@property NSArray *schedules;

-(NSData *)convertStringToData:(NSString *)urlString;


@end

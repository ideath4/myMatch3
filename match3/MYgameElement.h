//
//  MYgameElement.h
//  match3
//
//  Created by Иван on 28.11.14.
//  Copyright (c) 2014 MY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYgameElement : NSObject
@property int type;
@property bool selected;
@property CGImageRef image;
+(MYgameElement*) initRandomElement;
@end

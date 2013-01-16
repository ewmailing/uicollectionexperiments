//
//  CloseButton.m
//  CollectionViewExample
//
//  Created by Eric Wing on 11/18/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CloseButton.h"

@implementation CloseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) close:(id)the_sender
{
	[[self itemView] removeFromSuperview];
}

@end

//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  BeCollectionCell.m
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/8.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "BeCollectionCell.h"
#import "TestCell.h"

#pragma mark -

@implementation BeCollectionCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

@synthesize subCells  = _subCells;
@synthesize hasCount  = _hasCount;

- (void)load
{
    _subCells = [[NSMutableArray alloc] init];
}

- (void)unload
{
    _subCells = nil;
}

-(void) setLines: (int) lineCount
{
    if(_hasCount) return;
    
    int sum_height =0;
    
    for (int i = 0; i < lineCount; i++) {
        TestCell* testCell = [[TestCell alloc] init];
        testCell.frame = CGRectMake(0, 0 + i * 40, 40, 40);
        sum_height += 40;
        
        [self addSubview:testCell];
    }
    self.frame = CGRectMake(0, 0, 40, sum_height);
    
    self.RELAYOUT();
    
    _hasCount = YES;
}

- (void)dataDidChanged
{
    // TODO: fill data
}

- (void)layoutDidFinish
{
    // TODO: custom layout here
}


@end

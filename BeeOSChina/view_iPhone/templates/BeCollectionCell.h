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
//  BeCollectionCell.h
//  BeeOSChina
//
//  Created by Yu Zhang on 14/12/8.
//  Copyright (c) 2014年 Yu Zhang. All rights reserved.
//

#import "Bee.h"

#pragma mark -

@interface BeCollectionCell : BeeUICell
@property (retain,nonatomic)  NSMutableArray *        subCells;
@property (nonatomic)         BOOL                    hasCount;

-(void) setLines: (int)       lineCount;
@end

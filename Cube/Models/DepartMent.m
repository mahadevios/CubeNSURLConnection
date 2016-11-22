//
//  DepartMent.m
//  Cube
//
//  Created by mac on 29/08/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import "DepartMent.h"

@implementation DepartMent
@synthesize Id,departmentName;


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[ NSString stringWithFormat:@"%ld",self.Id] forKey:@"Id"];
        [aCoder encodeObject:self.departmentName forKey:@"departmentName"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        //self=[aDecoder decodeObjectForKey:@"userObject"];
        self.Id = [[aDecoder decodeObjectForKey:@"Id"]longLongValue];
        self.departmentName=[aDecoder decodeObjectForKey:@"departmentName"];
        
        
    }
    return self;

    }
@end

//
//  GifCell.m
//  PlayGif
//
//  Created by sunkai on 16/11/20.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "GifCell.h"
#import "YYWebImage.h"
#import "YYAnimatedImageView.h"

@implementation GifCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setValue:[[YYAnimatedImageView alloc] init] forKey:@"imageView"];
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.drawsAsynchronously = YES;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

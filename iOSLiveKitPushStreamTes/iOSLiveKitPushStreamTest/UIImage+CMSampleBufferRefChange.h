//
//  UIImage+CMSampleBufferRefChange.h
//  
//
//  Created by sunkai on 16/10/26.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (CMSampleBufferRefChange)

- (UIImage *)sampleBufferToImage:(CMSampleBufferRef)sampleBuffer;

@end

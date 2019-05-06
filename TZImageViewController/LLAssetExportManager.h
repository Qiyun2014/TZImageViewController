//
//  YYAssetExportManager.h
//  
//
//  Created by yryz on 2019/5/6.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LLAssertExpoerHandle) (int status, float progress, NSString *output, UIImage * _Nullable thumbImage);

@interface LLAssetExportManager : NSObject

// For AVAsset
+ (void)exportSessionWithAVAsset:(AVAsset *)asset completion:(LLAssertExpoerHandle)completion;

// For PHAsset
+ (void)exportSessionWithPHAsset:(PHAsset *)asset completion:(LLAssertExpoerHandle)completion;

@end

NS_ASSUME_NONNULL_END

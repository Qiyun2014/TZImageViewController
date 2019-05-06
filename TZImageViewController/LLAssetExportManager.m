
//
//  YYAssetExportManager.m
//  
//
//  Created by yryz on 2019/5/6.
//

#import "LLAssetExportManager.h"

@implementation LLAssetExportManager

+ (void)exportSession:(AVAssetExportSession *)session completion:(LLAssertExpoerHandle)completion{
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));

    session.outputFileType = AVFileTypeQuickTimeMovie;
    session.outputURL = [NSURL fileURLWithPath:[self createTempFileWithFormat:@"mp4"]];
    session.shouldOptimizeForNetworkUse = YES;
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        switch (session.status) {
                case AVAssetExportSessionStatusUnknown:
                    NSLog(@"Unknown status ...");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    NSLog(@"Waiting ...");
                    break;
                case AVAssetExportSessionStatusExporting:
                    NSLog(@"Exporting ...");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Completed ...");
                    break;
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Failed ...");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Cancelled ...");
                    break;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_source_cancel(timer);
            if (completion) {
                completion(session.status, .0f, session.outputURL.absoluteString, [LLAssetExportManager firstTimeOfThumbnailWithUrl:session.outputURL]);
            }
        });
    }];
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (completion) {
            completion(AVAssetExportSessionStatusExporting, session.progress, session.outputURL.absoluteString, NULL);
        }
    });
    dispatch_resume(timer);
}


+ (void)exportSessionWithAVAsset:(AVAsset *)asset completion:(LLAssertExpoerHandle)completion{
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    [LLAssetExportManager exportSession:session completion:completion];
}


+ (void)exportSessionWithPHAsset:(PHAsset *)asset completion:(LLAssertExpoerHandle)completion{
    
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        NSLog(@"progress = %.2f", progress);
    };
    
    [manager requestExportSessionForVideo:asset options:options exportPreset:AVAssetExportPresetMediumQuality resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
        [LLAssetExportManager exportSession:exportSession completion:completion];
    }];
}


// create temp file to save the media file
+ (NSString *)createTempFileWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd-HH-mm-ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%ld-%@.%@",random(),dateTime, format];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = paths.firstObject;
    NSString *file = [docDir stringByAppendingPathComponent:fileName];
    return file;
}

+ (UIImage *)firstTimeOfThumbnailWithUrl:(NSURL *)url{
    
    AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
    /* Converts a CMTime to seconds. */
    Float64 durationSeconds = CMTimeGetSeconds([anAsset duration]);
    if (durationSeconds) {
        /* video duration with location 0 */
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:anAsset];
        imageGenerator.appliesPreferredTrackTransform = YES;
        /* The time at which the image of the asset is to be created. */
        CGImageRef imgRef = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 30) actualTime:NULL error:nil];
        return [[UIImage alloc] initWithCGImage:imgRef scale:UIViewContentModeScaleAspectFit orientation:UIImageOrientationUp];
    }else
        return nil;
}

@end

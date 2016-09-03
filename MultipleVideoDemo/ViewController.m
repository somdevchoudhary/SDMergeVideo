//
//  ViewController.m
//  MultipleVideoDemo
//
//  Created by Somdev Choudhary on 03/09/16.
//  Copyright © 2016 Somdev Choudhary. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    NSURL *videoUrl1;
    NSURL *videoUrl2;
    
    AVPlayer *player1;
    AVPlayer *player2;
    
    AVPlayerLayer *playerLayer1;
    AVPlayerLayer *playerLayer2;
    NSMutableArray *layerInstructionsArray;
    
    AVAsset *firstAsset;
    AVAsset *secondAsset;
    

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    layerInstructionsArray = [[NSMutableArray alloc]init];
    
    [self createPathForVideoFolder]; // call create folder method
    [self createPathForMergedVideoFolder]; // call merge video folder method
    
    // Do any additional setup after loading the view, typically from a nib.
}

//***************************** Creating Folder in Document Directory ***************************************************

-(void)createPathForVideoFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
   NSString *dataPath = [documentsDirectory stringByAppendingString:@"/CapturedVideos"];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:dataPath]) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

-(void)createPathForMergedVideoFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingString:@"/MergedVideos"];
    
    NSError *error;
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:dataPath]) {
        
        [[NSFileManager defaultManager]createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}

//***********************************************************************************************************************

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
  // ********************************* For getting last two files from Document Directory ****************************
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
   NSString *folderPath = [documentDirectory stringByAppendingString:@"/CapturedVideos"];
    
  
   NSFileManager *fileManager = [NSFileManager defaultManager];
    
   NSArray *files = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    
    if (files.count > 0)
    {
        
        if (files.count == 1) {
            
            NSString *aPath = [files objectAtIndex:0];
            
            aPath = [NSString stringWithFormat:@"/%@",aPath];
            
           NSString *fullpath = [folderPath stringByAppendingPathComponent:aPath];
            videoUrl1 =[NSURL fileURLWithPath:fullpath];
        }
        else if(files.count >1)
        {
            deleteBtn.hidden = NO;
            mergeBtn.hidden = NO;
            playBtn.hidden = NO;
            
            NSString *lastObj = [files lastObject];
            
            NSInteger secondLastIndex = [files indexOfObject:lastObj];
            
            lastObj = [NSString stringWithFormat:@"/%@",lastObj];
            
            NSString *fullpath = [folderPath stringByAppendingPathComponent:lastObj];
            videoUrl2 =[NSURL fileURLWithPath:fullpath];
            
            
           NSString  *aPath = [files objectAtIndex:secondLastIndex-1];
            
            aPath = [NSString stringWithFormat:@"/%@",aPath];
            
            NSString *fullpath1 = [folderPath stringByAppendingPathComponent:aPath];
            videoUrl1 =[NSURL fileURLWithPath:fullpath1];
            
            
            AVAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl1 options:nil];
            
            firstAsset = asset;
            
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
            player1 = [AVPlayer playerWithPlayerItem:playerItem];
            
            playerLayer1  = [AVPlayerLayer playerLayerWithPlayer:player1];
            
            
            [playerLayer1 setFrame:leftView.bounds];
         playerLayer1.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [leftView.layer addSublayer:playerLayer1];
            
            [player1 play];
            
            
            AVAsset *asset2 = [AVURLAsset URLAssetWithURL:videoUrl2 options:nil];
            secondAsset = asset2;
            AVPlayerItem *playerItem2 = [AVPlayerItem playerItemWithAsset:asset2];
            player2 = [AVPlayer playerWithPlayerItem:playerItem2];
            
            playerLayer2  = [AVPlayerLayer playerLayerWithPlayer:player2];
            
            
            [playerLayer2 setFrame:rightView.bounds];
            playerLayer2.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [rightView.layer addSublayer:playerLayer2];
            
            [player2 play];

        }
        
    }
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button Action Performed

-(IBAction)playMergeVideo_btnTapped:(id)sender
{
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDir = [pathArr objectAtIndex:0];
    
    NSString *folderPath = [documentDir stringByAppendingString:@"/MergedVideos"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    
    if (files.count > 0)
    {
        NSString *aPath = [files lastObject];
        
        aPath = [NSString stringWithFormat:@"/%@",aPath];
        
        NSString *fullpath = [folderPath stringByAppendingPathComponent:aPath];
        
        NSURL *videoURL =[NSURL fileURLWithPath:fullpath];

        self.playerViewController = [[AVPlayerViewController alloc]init];
        
        [self.playerViewController.contentOverlayView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        
        self.playerViewController.player = player;        
        
        [self presentViewController:self.playerViewController animated:YES completion:nil];
        
        [self.playerViewController.player play];

        
    }
}

-(IBAction)captureVideo_btnTapped:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, nil];
        
        picker.mediaTypes = mediaTypes;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertController *cntlr = [UIAlertController alertControllerWithTitle:@"Alert!!" message:@"There's no camera on this device!" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        }];
        [cntlr addAction:okAction];
    
        [self presentViewController:cntlr animated:YES completion:nil];
    }
}

-(IBAction)delete_btnTapped:(id)sender   // To delete Files in document directory
{
    mergeBtn.hidden = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *folderPath = [documentDirectory stringByAppendingString:@"/CapturedVideos/"];
    
    NSString *mergedFolderPath = [documentDirectory stringByAppendingString:@"/MergedVideos/"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error = nil;
    
     NSArray *filesArr = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    
    NSArray *mergedFilesArr = [fileManager contentsOfDirectoryAtPath:mergedFolderPath error:nil];
    
    
    if (filesArr.count ==1) {
        
        [playerLayer1 removeFromSuperlayer];
    }
    else if (filesArr.count >1)
    {
        [playerLayer1 removeFromSuperlayer];
        [playerLayer2 removeFromSuperlayer];
    }
    
    
    for (NSString *file in filesArr) {
        
        deleteBtn.hidden = YES;        
        NSString *toDeletePath = [NSString stringWithFormat:@"%@%@",folderPath,file];
        
        BOOL success = [fileManager removeItemAtPath:toDeletePath error:&error];
        if (!success || error) {
            // it failed.
        }
    }
    
    for (NSString *mergeFile in mergedFilesArr) {
        
        deleteBtn.hidden = YES;
        NSString *toDeletePath = [NSString stringWithFormat:@"%@%@",mergedFolderPath,mergeFile];
        
        BOOL success = [fileManager removeItemAtPath:toDeletePath error:&error];
        if (!success || error) {
            // it failed.
        }
    }
}

-(IBAction)merge_btnTapped:(id)sender
{
    if(layerInstructionsArray.count>0)
        [layerInstructionsArray removeAllObjects];
    
    __block CMTime cursorTime = kCMTimeZero;
    CMTime videoDuration = firstAsset.duration;
    CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero,videoDuration);
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *videoAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    [videoTrack insertTimeRange:videoTimeRange ofTrack:videoAssetTrack atTime:kCMTimeZero error:nil];
    
    AVAssetTrack *audioAssetTrack =  [[firstAsset tracksWithMediaType:AVMediaTypeAudio]firstObject];
    [audioTrack insertTimeRange:videoTimeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:nil];
    
    cursorTime = CMTimeAdd(cursorTime,videoDuration);
    //cursorTime = CMTimeAdd(cursorTime,transitionDuration);
    
    
    AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
    BOOL  isFirstAssetPortrait_  = NO;
    CGAffineTransform firstTransform = videoAssetTrack.preferredTransform;
    if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
    if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
    if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
    if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
    
    CGFloat FirstAssetScaleToFitRatio = 320.0/videoAssetTrack.naturalSize.width;
    if(isFirstAssetPortrait_){
        FirstAssetScaleToFitRatio = 320.0/videoAssetTrack.naturalSize.height;
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(videoAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
    }else{
        CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
        [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(videoAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    }
    [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
    [layerInstructionsArray addObject:FirstlayerInstruction];
    
//    [FirstlayerInstruction setOpacityRampFromStartOpacity:1.f toEndOpacity:0.1f timeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)];
    
    AVMutableCompositionTrack *videoTrack2 = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *videoAssetTrack2 = [[secondAsset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    [videoTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero,secondAsset.duration) ofTrack:videoAssetTrack2 atTime:cursorTime error:nil];
    
    AVMutableCompositionTrack *audioTrack2 = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *audioAssetTrack2 = [[secondAsset tracksWithMediaType:AVMediaTypeAudio]firstObject];
    [audioTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero,secondAsset.duration) ofTrack:audioAssetTrack2 atTime:cursorTime error:nil];
    
    cursorTime = CMTimeAdd(cursorTime, secondAsset.duration);
    CMTimeShow(cursorTime);
    
    AVMutableVideoCompositionLayerInstruction *otherLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack2];
    
    UIImageOrientation secondAssetOrientation_  = UIImageOrientationUp;
    BOOL  isSecondAssetPortrait_  = NO;
    CGAffineTransform secondTransform = videoAssetTrack2.preferredTransform;
    if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {secondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
    if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {secondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
    if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {secondAssetOrientation_ =  UIImageOrientationUp;}
    if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {secondAssetOrientation_ = UIImageOrientationDown;}
    CGFloat SecondAssetScaleToFitRatio = 320.0/videoAssetTrack2.naturalSize.width;
    if(isSecondAssetPortrait_){
        SecondAssetScaleToFitRatio = 320.0/videoAssetTrack2.naturalSize.height;
        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
        [otherLayerInstruction setTransform:CGAffineTransformConcat(videoAssetTrack2.preferredTransform, SecondAssetScaleFactor) atTime:kCMTimeZero];
    }else{
        CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
        [otherLayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(videoAssetTrack2.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
    }
    [otherLayerInstruction setOpacity:0.0 atTime:cursorTime];
    [layerInstructionsArray addObject:otherLayerInstruction];
    
//    [otherLayerInstruction setOpacityRampFromStartOpacity:1.f toEndOpacity:0.1f timeRange:CMTimeRangeMake(CMTimeSubtract(cursorTime, asset.duration), asset.duration)];
    
    
    AVMutableVideoCompositionInstruction *MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, cursorTime);
    MainInstruction.layerInstructions = layerInstructionsArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //play composition with avplayer
        [self exportComposition:composition withInstruction:MainInstruction];
        
    });
    

 
}

-(void)exportComposition:(AVMutableComposition*)composition_ withInstruction:(AVMutableVideoCompositionInstruction*)mainInstruction{
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%lld.mov",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
    
    NSString *pathStr = [@"/MergedVideos/" stringByAppendingString:timeStr];
    
    
    NSString *outputpathofmovie = [documentsDirectory stringByAppendingString:pathStr];
  

    NSURL *url = [NSURL fileURLWithPath:outputpathofmovie];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition_ presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.videoComposition = MainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             switch ([exporter status]) {
                     
                 case AVAssetExportSessionStatusFailed:
                     
                   
                     NSLog(@"Export failed: %@", [exporter error]);
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     
                     
                     NSLog(@"Export canceled");
                     break;
                     
                 default:
                 {
                     mergeBtn.hidden = YES;
                     playBtn.hidden = NO;

                     NSLog(@"NONE");
                     NSLog(@"%ld",(long)exporter.status);
                     //                            [AppHelper saveToUserDefaults:furl.path withKey:@"videoURL"];
                     // asset_ = [AVURLAsset assetWithURL:furl];
                     UISaveVideoAtPathToSavedPhotosAlbum (url.path, nil, nil, nil);
                     
                     
                     UIAlertController *cntlr = [UIAlertController alertControllerWithTitle:@"Success!!" message:@"Video Merged" preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     [cntlr addAction:okAction];
                     
                     [self presentViewController:cntlr animated:YES completion:nil];
                     
                 }
                 
             }
         });
     }];
}



#pragma mark - Delegate Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // user hit cancel
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSURL *capturedMovie = [info objectForKey:UIImagePickerControllerMediaURL];
  
    
    NSData *videoData = [NSData dataWithContentsOfURL:capturedMovie];
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *timeStr = [NSString stringWithFormat:@"%lld.mov",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue]];
    
    NSString *pathStr = [@"/CapturedVideos/" stringByAppendingString:timeStr];
    
    NSString *outputpathofmovie = [docsDir stringByAppendingString:pathStr];
   

  BOOL success =  [videoData writeToFile:outputpathofmovie atomically:YES];
    
    NSLog(@"Result = %d",success);
    
 //   UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);  // To save video in device Photos
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end

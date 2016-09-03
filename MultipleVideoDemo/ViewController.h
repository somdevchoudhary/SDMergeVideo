//
//  ViewController.h
//  MultipleVideoDemo
//
//  Created by Somdev Choudhary on 03/09/16.
//  Copyright © 2016 Somdev Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *leftView;
    IBOutlet UIView *rightView;
    IBOutlet UIButton *deleteBtn;
    IBOutlet UIButton *mergeBtn;
    IBOutlet UIButton *playBtn;
}

@property(nonatomic,strong)AVPlayerViewController *playerViewController;

-(IBAction)captureVideo_btnTapped:(id)sender;
-(IBAction)delete_btnTapped:(id)sender;
-(IBAction)merge_btnTapped:(id)sender;
-(IBAction)playMergeVideo_btnTapped:(id)sender;

@end


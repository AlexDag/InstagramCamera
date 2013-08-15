//
//  SSCameraViewController.h
//  SmartStuffSwap
//
//  Created by Alex on 6/11/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ALAsset+SSAssetEqual.h"
#import "SSUtils.h"
#import "UIImageView+GeometryConversion.h"


@interface SSCameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,
                                                        UITableViewDataSource,UITableViewDelegate>




//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)btnChoosephoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnGallery;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbltext;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;


@property(weak,nonatomic) id ownerImage;
@property(assign,nonatomic) SEL imageSetterSelector;
@property(weak,nonatomic) NSString *acceptSegue;

@property (weak, nonatomic) IBOutlet UIImageView *imageShooter;

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UIView *line4;
@property (weak, nonatomic) IBOutlet UIButton *btnGrid;
@property (weak, nonatomic) IBOutlet UIButton *btnFlashSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnDevice;
@property (weak, nonatomic) IBOutlet UIImageView *imageScanPhoto;



@property (weak, nonatomic) IBOutlet UIView *pnlLibrary;
@property (weak, nonatomic) IBOutlet UIView *pnlCamera;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imagePhotoDone;
@property (weak, nonatomic) IBOutlet UIView *viewCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnOKAcceptGallery;

- (IBAction)btnTakePhoto:(id)sender;
- (IBAction)bntAcceptPhotoDone:(id)sender;
- (IBAction)showGrid:(id)sender;
- (IBAction)btnFlashClick:(UIButton *)sender;
- (IBAction)btnCameraInputChange:(id)sender;
- (IBAction)btnCameraClick:(id)sender;

- (IBAction)btnCameraFromphotoDoneClick:(UIButton *)sender;
- (IBAction)btnAddphotoFromDoneClick:(id)sender;

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer;
- (IBAction)handlePanImageGallery:(UIPanGestureRecognizer *)recognizer;
//- (IBAction)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (IBAction)btnBackCamera:(id)sender;
//- (IBAction)btnPhotoGallery:(id)sender;
- (IBAction)btnAcceptGalleryClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhotoGallery;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollLibrary;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewcameraButtons;

@property (weak, nonatomic) IBOutlet UIView *viewLeft;
@property (weak, nonatomic) IBOutlet UIView *viewRight;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoLibrary;
@property (weak, nonatomic) IBOutlet UIView *viewPhotoDone;
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPhotoGallerySelected;





@end

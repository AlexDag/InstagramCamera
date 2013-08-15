//
//  SSCameraViewController.m
//  SmartStuffSwap
//
//  Created by Alex on 6/11/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//

#import "SSCameraViewController.h"
//#import "SSParentImageViewController.h"
#import "SSAddObjectViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>
#import "SSAssetLibraryFactory.h"

#define deltax ((int)330)


#define animationTime ((float)0.6)
#define deltaY ((int)300)

// pan - stop Y coordinat
#define deltaYpan ((int)30)

#define kIMAGE_ROW_COUNT ((int)4)

#define kIMAGE_GALLERY_WIDTH ((int)320)
#define kIMAGE_GALLERY_HEIGHT ((int)310)
#define kIMAGE_GALLERY_CROP_SIZE ((int)310)

//#define X_Init_IMAGE_GALLERY ((int)0)
//#define Y_Init_IMAGE_GALLERY ((int)50)


//#define USER_KEY_ASSET @"assetSelected"
#define kSHOW_GRID_KEY @"showGrid"


@interface SSCameraViewController ()

@end

@implementation SSCameraViewController{
 
    BOOL deviceBack ;
    
    AVCaptureDevice *deviceObject;
    AVCaptureSession *session;
    AVCaptureDeviceInput *input;
    AVCaptureStillImageOutput *stillImageOutput;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
                //photo library
   // NSMutableArray *dataArray;

        // y init coord _pnlLibrary
    CGFloat initY;
    ALAsset  *assetSelected;
  
    
    CGPoint contentOff;
 
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
       [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
        [self sessionClear];
      
    
}




-(void)viewDidAppear:(BOOL)animated{
    [self imageSessionPrepare:[self getDefaultDevice]];
         
}



- (void)viewDidLoad
{
    [super viewDidLoad];
     [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
    
   if(!IS_IPHONE_5){
       //CGRect rectView = _pnlCamera.frame;
       CGRect rectView = _viewcameraButtons.frame;
       rectView.origin.y = _pnlCamera.frame.origin.y+_pnlCamera.frame.size.height;
       rectView.size.height= kIPHONE_HEIGHT - rectView.origin.y;
       _viewcameraButtons.frame = rectView;
       
        rectView = _tableView.frame;
       rectView.origin.y = _pnlCamera.frame.origin.y+_pnlCamera.frame.size.height;
       rectView.size.height= kIPHONE_HEIGHT - rectView.origin.y;
       _tableView.frame = rectView;
       
       
       
       
       
       int btntakephotosize=60;
       int btnAlbumsize=40;
       
       [SSUtils setCenterObjectForParent:_viewcameraButtons object:_btnTakePhoto size:btntakephotosize onlyVertical:FALSE];
       [SSUtils setCenterObjectForParent:_viewcameraButtons object:_btnGallery size:btnAlbumsize onlyVertical:TRUE];
    }
    
    
    
    SSAssetLibraryFactory *alibrary =[SSAssetLibraryFactory sharedManager];
    
    if (alibrary.galleryBtnImage==nil){
        
        if([alibrary.dataArray count]>0) {
            
            UIImage *image = [UIImage imageWithCGImage:[[alibrary.dataArray objectAtIndex:0 ] thumbnail ]];
            alibrary.galleryBtnImage = image;
            
        }

    }
    
    [self performSelector:@selector(setBtnGalleryImage:) withObject:alibrary.galleryBtnImage];
    
    if([alibrary.dataArray count]>0)
        assetSelected = [alibrary.dataArray  objectAtIndex:0];
    
    [_tableView reloadData];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
*/
    
    
    
    
//dataArray = [[SSAssetLibraryFactory sharedManager] dataArray];
    
    
    _tableView.hidden = TRUE;
      initY = _pnlLibrary.frame.origin.y;
    
    _viewCamera.hidden = false;
    _viewPhotoLibrary.hidden=true;
 
   
    
    _tableView.rowHeight = 80;
    
    CGRect rect =    _viewHeader.frame;
    rect.origin.y = 0;
    _viewHeader.frame = rect;
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackCamera:(id)sender {
    
    [[self navigationController]popViewControllerAnimated:YES];
}

-(void)setBtnGalleryImage:(UIImage*)image{
    if(image)
       [_btnGallery setBackgroundImage:image forState:UIControlStateNormal];
    
   
}

- (IBAction)btnTakePhoto:(id)sender {
    
   
    
     //  NSLog(@"enter take");
    
    _btnTakePhoto.enabled = false;
    
    _imageShooter.hidden = FALSE;
    
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}

//    NSLog(@" capture connection end");
    
   
    
    // save image
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                         completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (imageDataSampleBuffer != NULL) {
                  NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                  UIImage *image = [[UIImage alloc] initWithData:imageData];
                 //_imageView.image = image;
                [_imagePhotoDone setImage:[ image copy]];
                
               [[SSAssetLibraryFactory sharedManager] savePhotoInAlbumStuffSwap:image.CGImage  orientation:(ALAssetOrientation)[image imageOrientation]];
                [self sessionClear];
                [self animationFromCameraToPhotoDone];
 
            } else if (error) {
               
                   NSLog(@" capture error :%@",error);
               }
    }];

    
      
      
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    UIViewController *viewTarget = [segue destinationViewController];
    if ([viewTarget isKindOfClass:[SSAddObjectViewController class]]) {
        SSAddObjectViewController *view = (SSAddObjectViewController*)viewTarget;
        [view setSelImage:sender];
        
       // view.txtStr = @"aaaaaaaaa";
        
    } else {
        NSLog(@" image  does not  assigned ");  
    }
}

-(void)setShowGridValue:(BOOL)value{
    _line1.hidden = value;
    _line2.hidden = value;
    _line3.hidden = value;
    _line4.hidden = value;
    
}

- (IBAction)showGrid:(id)sender {
    _line1.hidden = !_line1.hidden;
    _line2.hidden = !_line2.hidden;
    _line3.hidden = !_line3.hidden;
    _line4.hidden = !_line4.hidden;
    
    BOOL showgrid = _line1.hidden;
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:showgrid forKey:kSHOW_GRID_KEY];
    [userdefaults synchronize];
    
}

- (IBAction)btnFlashClick:(UIButton *)sender {

    
    if (!deviceObject.flashAvailable) 
        return;
    
    
    
    NSError* err = nil;
    BOOL lockAcquired = [deviceObject lockForConfiguration:&err];
    
    if (lockAcquired) {
        
        switch (sender.tag) {
            case 0:
                sender.tag=1;
                [deviceObject setFlashMode:AVCaptureFlashModeOn];
                [sender  setBackgroundImage:[UIImage imageNamed:@"flash-camera-on.png"] forState:UIControlStateNormal];
                break;
            case 1:
                sender.tag=2;
                [deviceObject setFlashMode:AVCaptureFlashModeAuto];
                [sender  setBackgroundImage:[UIImage imageNamed:@"flash-camera-auto.png"] forState:UIControlStateNormal];
                break;
                
                
            case 2:
                sender.tag=0;
                [deviceObject setFlashMode:AVCaptureFlashModeOff];
                [sender  setBackgroundImage:[UIImage imageNamed:@"flash-camera-off.png"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        
       
        
        
        [deviceObject unlockForConfiguration];
    }


}





- (IBAction)btnCameraInputChange:(id)sender {
    [self imageSessionPrepare:[self changeDevice]];
}


#pragma mark animation

#pragma mark from camera to Done
-(void)animationFromCameraToPhotoDone{
    
     // [self.view bringSubviewToFront:_viewPhotoDone];
    
    [UIView animateWithDuration:animationTime
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect rect = _viewCamera.frame;
                         rect.origin.x = -320;
                         _viewCamera.frame = rect;
                         
                          rect = _viewPhotoDone.frame;
                         rect.origin.x = 0;
                         _viewPhotoDone.frame = rect;
                         
                         
                         
                        //_viewCamera.hidden = true;
                         //_viewcameraButtons.hidden=TRUE;
                         //_btnBack.hidden=TRUE;
                         
                     }
                     completion:^(BOOL finished){
                         [[SSAssetLibraryFactory sharedManager]startLoadAsset];
                    }];
    
 //   NSLog(@"  animation end...... ");
    
}
#pragma mark from Done to Camwera
-(void)animationFromDoneToCamera{
    
  
    
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                        
                         
                         CGRect rect = _viewCamera.frame;
                         rect.origin.x = 0;
                         _viewCamera.frame = rect;

                         
                         
                        rect = _viewPhotoDone.frame;
                         rect.origin.x = 320;
                         _viewPhotoDone.frame = rect;
                         
                         //_viewCamera.hidden = false;
                        // _viewcameraButtons.hidden=false;
                         //_btnBack.hidden=false;
                         
                     }
                     completion:^(BOOL finished){
                        [self imageSessionPrepare:[self getDefaultDevice]];

                     }];
}




#pragma mark            from camera to library
- (IBAction)btnChoosephoto:(id)sender {
    
    BOOL forbiddenAccess = [SSUtils getForbiddenAlbumAccess];
    
   if(forbiddenAccess){
        [SSUtils showAlertMessage:@" Приложение не имеет доступа к Альбому \n Проверить: \n Settings-Privacy-Photos"];
        return;
    }
  
    
   [self sessionClear];
    
        
    _viewPhotoLibrary.hidden=false;
    
       // draw selected image
    [_tableView reloadData];
    
       // first enter not make coorect scroll image
    _scrollPhotoGallerySelected.hidden = true;
    if(assetSelected)
        [self performSelector:@selector(showImageGalleryByAsset) withObject:nil afterDelay:0.0];

    
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect rect = _btnCamera.frame;
                         rect.origin.x = 5;
                         _btnCamera.frame = rect;
                         
                          rect = _btnOKAcceptGallery.frame;
                         rect.origin.x -=deltax ;
                         _btnOKAcceptGallery.frame = rect;
                         
                         
                         rect = _btnBack.frame;
                         rect.origin.x -=deltax;
                         _btnBack.frame = rect;
                         
                         
                         rect = _pnlCamera.frame;
                         rect.origin.x -=deltax;
                         _pnlCamera.frame = rect;
                         
                         rect = _btnFlashSetting.frame;
                         rect.origin.x -=deltax;
                         _btnFlashSetting.frame = rect;
                         
                         rect = _btnGrid.frame;
                         rect.origin.x -=deltax;
                         _btnGrid.frame = rect;
                         
                         rect = _btnDevice.frame;
                         rect.origin.x -=deltax;
                         _btnDevice.frame = rect;
                         
                         
                         
                         rect = _pnlLibrary.frame;
                         rect.origin.x =0;
                         _pnlLibrary.frame = rect;
                         
                         rect = _viewcameraButtons.frame;
                         rect.origin.y +=deltaY;
                         _viewcameraButtons.frame = rect;
                         
                         
                         _tableView.hidden=FALSE;
                         
                         
                                                 
                     }
                     completion:^(BOOL finished){
                     }];
    
    
    if(assetSelected)
        [self performSelector:@selector(showImageGalleryByAsset) withObject:nil afterDelay:0.1];

    _scrollPhotoGallerySelected.hidden = false;
}


-(void)changeContentOff{
    NSLog(@" before %f",_scrollPhotoGallerySelected.contentOffset.y);
    
    [ _scrollPhotoGallerySelected setContentOffset: contentOff];
    NSLog(@" after %f",_scrollPhotoGallerySelected.contentOffset.y);
}


#pragma mark -          from library to camera
- (IBAction)btnCameraClick:(id)sender {
    
    _imageShooter.hidden=FALSE;
    _viewPhotoLibrary.hidden=true;
    
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGRect rect = _btnCamera.frame;
                         rect.origin.x += deltax;
                         _btnCamera.frame = rect;
                         
                         rect = _btnOKAcceptGallery.frame;
                         rect.origin.x +=deltax ;
                         _btnOKAcceptGallery.frame = rect;

                         
                         rect = _btnBack.frame;
                         rect.origin.x +=deltax;
                         _btnBack.frame = rect;
                         
                         
                         rect = _pnlCamera.frame;
                         rect.origin.x +=deltax;
                         _pnlCamera.frame = rect;
                         
                         rect = _btnFlashSetting.frame;
                         rect.origin.x +=deltax;
                         _btnFlashSetting.frame = rect;
                         
                         rect = _btnGrid.frame;
                         rect.origin.x +=deltax;
                         _btnGrid.frame = rect;
                         
                         rect = _btnDevice.frame;
                         rect.origin.x +=deltax;
                         _btnDevice.frame = rect;
                         
                         
                         
                         rect = _pnlLibrary.frame;
                         rect.origin.x +=deltax;
                         _pnlLibrary.frame = rect;
                         
                         rect = _viewcameraButtons.frame;
                         rect.origin.y -=deltaY;
                         _viewcameraButtons.frame = rect;
                         
                         _tableView.hidden = TRUE;
                         
                     }
                     completion:^(BOOL finished){
                      //   NSLog(@"Done!");
                          [self imageSessionPrepare:[self getDefaultDevice]];
                     }];

   

    
}

- (IBAction)btnCameraFromphotoDoneClick:(UIButton *)sender {
    [self animationFromDoneToCamera];
}

- (IBAction)btnAddphotoFromDoneClick:(id)sender {
    
}



#pragma mark - image blocks
-(void)sessionClear{
    [session  stopRunning];
    [session removeInput:input];
    [session  removeOutput:stillImageOutput];
    
    
    if(captureVideoPreviewLayer)
        [captureVideoPreviewLayer  removeFromSuperlayer];
    
}


-(AVCaptureDevice*)getDefaultDevice{
  
    
    AVCaptureDevice *captureDevice =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if(captureDevice.position== AVCaptureDevicePositionBack) {
            deviceBack = TRUE;
    }
    else
        if(captureDevice.position== AVCaptureDevicePositionFront) {
            deviceBack = FALSE;
        }
    
    
    deviceObject = captureDevice;
    return  captureDevice;
}



-(AVCaptureDevice*)changeDevice{
    [self sessionClear];
   
    //  look at all the video devices and get the first one that's on the front
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    
  
    
    for (AVCaptureDevice *device_ in videoDevices)
    {
        
     //   NSLog(@"  pos %d",device_.position);
        
        if ( !deviceBack && device_.position == AVCaptureDevicePositionBack)
        {
            captureDevice = device_;
            deviceBack = TRUE;
            break;
        }
        
        else
            if ( deviceBack && device_.position == AVCaptureDevicePositionFront)
            {
                captureDevice = device_;
                deviceBack = FALSE;
                break;
                
            }
    }
    
    deviceObject = captureDevice;
    return  captureDevice;
}

-(void)imageSessionPrepare:(AVCaptureDevice*)device{
    _imageShooter.hidden = FALSE;
    
    if(!session){
        session = [[AVCaptureSession alloc] init];
        session.sessionPreset = AVCaptureSessionPresetHigh;
	}
    //ALayer *viewLayer = _viewPhoto.layer;
	//NSLog(@"viewLayer = %@", viewLayer);
    if(!captureVideoPreviewLayer){
        captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        captureVideoPreviewLayer.frame = _imageScanPhoto.frame;
    }
	[_imageScanPhoto.layer addSublayer:captureVideoPreviewLayer];
    
  	
	NSError *error = nil;
   
	input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    
	
    
    if(!stillImageOutput){
     stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
     NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
     [stillImageOutput setOutputSettings:outputSettings];
    }
    [session addOutput:stillImageOutput];
    
    _imageShooter.hidden = TRUE;
    
    [session startRunning];
    _btnTakePhoto.enabled = true;
    
    [self performSelector:@selector(checkShowGridValue)];
}


-(void)checkShowGridValue{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    BOOL value= [userdefaults boolForKey:kSHOW_GRID_KEY];
    [self setShowGridValue:value];

}



#pragma mark - photo library



#pragma mark Gestures : Pan
#pragma      Pan panel library
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        float down = initY - _pnlLibrary.frame.origin.y;
        float up = _pnlLibrary.frame.origin.y - deltaYpan;
        
        if( down<up )
            [self animationDown];
        else
            [self animationUp];
        return;
    }
    
    
    
    CGPoint translation = [recognizer translationInView:self.view];
    
      // move down  - forbidden
    if ((_pnlLibrary.frame.origin.y+translation.y)>initY) {
        
         [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        return;
    }
    
    if ((_pnlLibrary.frame.origin.y+translation.y)<deltaYpan) {
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        return;
    }
    recognizer.view.center =CGPointMake(recognizer.view.center.x ,
                                        recognizer.view.center.y + translation.y);
    
    CGRect rect =  _tableView.frame;
    rect.origin.y +=translation.y;
    rect.size.height -=translation.y;
    _tableView.frame = rect;
    
 
     rect =  _viewPhotoLibrary.frame;
    rect.origin.y +=translation.y;
    _viewPhotoLibrary.frame = rect;
    /*
    rect =  _imageView.frame;
    rect.origin.y +=translation.y;
    _imageView.frame = rect;
    */
    
    
    rect =  _viewLeft.frame;
    rect.origin.y +=translation.y;
    _viewLeft.frame = rect;
    
    rect =  _viewRight.frame;
    rect.origin.y +=translation.y;
    _viewRight.frame = rect;
    
    rect =  _viewHeader.frame;
    rect.origin.y +=translation.y;
    _viewHeader.frame = rect;
    
    rect =  _btnCamera.frame;
    rect.origin.y +=translation.y;
    _btnCamera.frame = rect;
    
      
    
    
   [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}




#pragma  - TAP gesture
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer{

    if(recognizer.state == UIGestureRecognizerStateEnded){
        
//NSLog(@" rect %f",_pnlLibrary.frame.origin.y);
        
             if(_pnlLibrary.frame.origin.y == initY)
                 [ self animationUp];
             else
             if(_pnlLibrary.frame.origin.y == deltaYpan)
                 [self animationDown];
    }

}

#pragma      Pan panel library
- (IBAction)handlePanImageGallery:(UIPanGestureRecognizer *)recognizer{
   
    CGFloat upView = 50;
    CGFloat downView = 360;
    CGFloat leftView = 5;
    CGFloat rightView = 315;
 //   float delta = 70;  // permit distance moved
    if(recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat downImage = _imageViewPhotoGallery.frame.origin.y + _imageViewPhotoGallery.frame.size.height;
        CGFloat upImage = _imageViewPhotoGallery.frame.origin.y;
        CGFloat rightImage = _imageViewPhotoGallery.frame.origin.x + _imageViewPhotoGallery.frame.size.width;
        CGFloat leftImage = _imageViewPhotoGallery.frame.origin.x;
        
           // rectangle 310x310 , between header , buttom camera , left and right viewer (5 width)
        
        
        
        
        
        
        
        
        if( downImage!=downView ||  upImage!=upView || leftImage!=leftView || rightImage!=rightView){
            CGFloat x;
            CGFloat y;
            
            if( downImage<downView ||  upImage>upView){
               y=(upImage>upView)?upView:360-_imageViewPhotoGallery.bounds.size.height;
            }
            else y = _imageViewPhotoGallery.frame.origin.y;
            
            if(leftImage>leftView || rightImage<rightView){
               x=(leftImage>leftView)?leftView:320 - _imageViewPhotoGallery.bounds.size.width;
            }
            else x=_imageViewPhotoGallery.frame.origin.x;
                
                
            [self animationGalleryImage:x y:y];
        }
        
        return;
    }
    
    
    
    CGPoint translation = [recognizer translationInView:_viewPhotoLibrary];
    
      recognizer.view.center =CGPointMake(recognizer.view.center.x +translation.x,
                                        recognizer.view.center.y + translation.y);
    
    
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

-(void)animationGalleryImage:(CGFloat )x y:(CGFloat)y{
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         
                                                 
                         CGRect rect =  _imageViewPhotoGallery.frame;
                         rect.origin.x = x;
                         rect.origin.y =y;
                         _imageViewPhotoGallery.frame = rect;
                         
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    

}

-(void)animationUp{
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         
                         CGFloat delta = _pnlLibrary.frame.origin.y - deltaYpan;
                         
                         CGRect rect =  _pnlLibrary.frame;
                         rect.origin.y =deltaYpan;
                         _pnlLibrary.frame = rect;
                         
                         
                          rect =  _tableView.frame;
                         rect.origin.y -=delta;
                         rect.size.height+=delta;
                         _tableView.frame = rect;
                         
                         
                         rect =  _viewPhotoLibrary.frame;
                         rect.origin.y -=delta;
                         _viewPhotoLibrary.frame = rect;
                         /*
                         rect =  _imageView.frame;
                         rect.origin.y -=delta;
                         _imageView.frame = rect;
                         */
                         
                         
                         rect =  _viewLeft.frame;
                         rect.origin.y -=delta;
                         _viewLeft.frame = rect;
                         
                         rect =  _viewRight.frame;
                         rect.origin.y -=delta;
                         _viewRight.frame = rect;
                         
                         rect =  _viewHeader.frame;
                         rect.origin.y -=delta;
                         _viewHeader.frame = rect;
                         
                         rect =  _btnCamera.frame;
                         rect.origin.y -=delta;
                         _btnCamera.frame = rect;
                         
                         
                         rect =  _btnOKAcceptGallery.frame;
                         rect.origin.y -=delta;
                         _btnOKAcceptGallery.frame = rect;

                          
                     }
                     completion:^(BOOL finished){
                     //    NSLog(@"Done!");
                        
                     }];
    


}
-(void)animationDown{
    [UIView animateWithDuration:animationTime
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         
                         CGFloat delta = initY - _pnlLibrary.frame.origin.y;
                         
                         CGRect rect =  _pnlLibrary.frame;
                         rect.origin.y =initY;
                         _pnlLibrary.frame = rect;
                         
                         
                          rect =  _tableView.frame;
                         rect.origin.y +=delta;
                         rect.size.height-=delta;
                         _tableView.frame = rect;
                         
                         
                         rect =  _viewPhotoLibrary.frame;
                         rect.origin.y +=delta;
                         _viewPhotoLibrary.frame = rect;
                         /*
                         rect =  _imageView.frame;
                         rect.origin.y +=delta;
                         _imageView.frame = rect;
                         */
                         
                         
                         rect =  _viewLeft.frame;
                         rect.origin.y +=delta;
                         _viewLeft.frame = rect;
                         
                         rect =  _viewRight.frame;
                         rect.origin.y +=delta;
                         _viewRight.frame = rect;
                         
                         rect =  _viewHeader.frame;
                         rect.origin.y +=delta;
                         _viewHeader.frame = rect;
                         
                         rect =  _btnCamera.frame;
                         rect.origin.y +=delta;
                         _btnCamera.frame = rect;
                         
                     }
                     completion:^(BOOL finished){
                      //   NSLog(@"Done!");
                        
                     }];
    

}

#pragma mark abum image rutins
-(float)getImageDeltaWidth{
   return (_imageViewPhotoGallery.bounds.size.width - kIMAGE_GALLERY_WIDTH )/2;
}
-(float)getImageDeltaHeight{
     return (_imageViewPhotoGallery.bounds.size.height - kIMAGE_GALLERY_HEIGHT )/2;
}


-(void)showImageGalleryByAsset{
    
      //NSLog(@" offset y:%f x:%f",_scrollPhotoGallerySelected.contentOffset.y,_scrollPhotoGallerySelected.contentOffset.x);
    
    
    
    ALAssetRepresentation *rep = [assetSelected		 defaultRepresentation];
    CGSize size=  [rep dimensions];
   
    
    CGRect rectImage = _imageViewPhotoGallery.frame;
    
    BOOL gorizontRatio = true;
    
    if(size.height>size.width){
        CGFloat ratio = size.height/size.width;
        rectImage.size.height = kIMAGE_GALLERY_WIDTH*ratio;
        rectImage.size.width = kIMAGE_GALLERY_WIDTH;
        gorizontRatio = false;
    }else{
        CGFloat ratio = size.width/size.height;
        rectImage.size.width =kIMAGE_GALLERY_HEIGHT*ratio;
        rectImage.size.height=kIMAGE_GALLERY_HEIGHT;
    }
    
    
    rectImage.origin.x=0;
    rectImage.origin.y=0;
    
    _imageViewPhotoGallery.frame = rectImage;
  //  UIImageOrientation orientation = UIImageOrientationUp;
  /*  NSNumber* orientationValue = [assetSelected valueForProperty:@"ALAssetPropertyOrientation"];
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
   */ 
    UIImage* image = [UIImage imageWithCGImage:[rep fullScreenImage]
                                         scale:[rep scale] orientation:0];
     
    
    
//    NSLog(@"image width %f  image height %f  orientation %d",image.size.width,image.size.height, rep.orientation);
    
    [_imageViewPhotoGallery setImage:image];
    
    
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat  right;
    
    CGRect rect = _imageViewPhotoGallery.frame;

    
    CGSize  sizeContent;
    
    if(gorizontRatio){
        CGRect rectV = _viewPhotoLibrary.frame;

        rect.origin.x = rectV.size.width/2 - _imageViewPhotoGallery.bounds.size.width/2;
        rect.origin.y = _viewHeader.frame.size.height;
          //EdgeInsets
        float delta =[self getImageDeltaWidth];
        left = delta;
        right= delta;
        top = 0;
        bottom = 0;

        sizeContent = CGSizeMake(_imageViewPhotoGallery.bounds.size.width, kIMAGE_GALLERY_HEIGHT);
        _scrollPhotoGallerySelected.contentOffset = CGPointMake(0, 0);
       //  NSLog(@" offset y:%f x:%f",_scrollPhotoGallerySelected.contentOffset.y,_scrollPhotoGallerySelected.contentOffset.x);
    }else  // vertical>gorizontal
    {
        
        CGRect rectV = _viewPhotoLibrary.frame;
        rect.origin.y = rectV.size.height/2 - _imageViewPhotoGallery.bounds.size.height/2;
       
            //EdgeInsets
        left = _viewLeft.bounds.size.width;
        right= _viewRight.bounds.size.width;
        
        float delta =[self getImageDeltaHeight];
        
    //    NSLog(@" delta %f  orig.y %f ",delta, rect.origin.y);
        
        top = delta;;
        bottom = delta;;
        
        sizeContent = CGSizeMake(kIMAGE_GALLERY_WIDTH, rect.size.height);
        
        
        contentOff =CGPointMake(0, 0);
        [self performSelector:@selector(changeContentOff)];
        
      // NSLog(@" offset %f ",_scrollPhotoGallerySelected.contentOffset.y);
    }
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(top, left, bottom, right);
    _scrollPhotoGallerySelected.contentInset = contentInsets;
    
    _scrollPhotoGallerySelected.contentSize =sizeContent;
    
    _scrollPhotoGallerySelected.frame = rect;
    _scrollPhotoGallerySelected.showsVerticalScrollIndicator = FALSE;
    _scrollPhotoGallerySelected.showsHorizontalScrollIndicator = FALSE;
    
    
 //   NSLog(@" scroll origin x =%f ",_scrollPhotoGallerySelected.frame.origin.x);
    
}


#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[SSAssetLibraryFactory sharedManager].dataArray count]/4);
}

// selected image from Galerry by Click
-(void)imageLibraryClicked:(UIButton*)button{
    
       //draw  selected Image
    [_tableView reloadData];
    
    NSInteger row = (int)button.tag / kIMAGE_ROW_COUNT;
   
    
    
    
    assetSelected = [[SSAssetLibraryFactory sharedManager].dataArray   objectAtIndex:button.tag];
    
    [self performSelector:@selector(showImageGalleryByAsset) withObject:nil];
    
    if (_pnlLibrary.frame.origin.y<initY) {
        [self animationDown];
    }

   [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    
      
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    int size = 70;
    int deltaX = 8;
    
    
    static NSString *MyIdentifier = @"Swap";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        
        /*        CGRect rect = cell.frame;
         rect.size.height=200;
         rect.size.width=_tableView.bounds.size.width;
         cell.bounds = rect;
         */
        
        
        // button avatare image
           // ALAsset *asset = [dataArray objectAtIndex:indexPath.row];
        int x =deltaX;
        int index = indexPath.row*kIMAGE_ROW_COUNT;
        

      
   
        
        for (int i=0; i<kIMAGE_ROW_COUNT; i++) {
            
            UIButton *btnAvatare;
            UIImageView *imgSelected=nil;
            
             btnAvatare = [[UIButton alloc]initWithFrame:CGRectMake(x,0,size,size)];

            [btnAvatare addTarget:self action:@selector(imageLibraryClicked:) forControlEvents:UIControlEventTouchDown];
            
            ALAsset *asset = [[SSAssetLibraryFactory sharedManager].dataArray   objectAtIndex:(index+i)];
            
            
            btnAvatare.tag = index+i;;
            
            if([assetSelected isEqual:asset]){
                
                imgSelected = [[UIImageView alloc]initWithFrame:CGRectMake(x+2, 0+2, size-2, size-4)];
                
                [imgSelected setImage: [UIImage imageWithCGImage:[asset thumbnail] ] ];
                
                imgSelected.contentMode =UIViewContentModeScaleAspectFit;
                
                [btnAvatare setBackgroundImage: [UIImage imageNamed:@"gallery-photo-selected.png"]  forState:UIControlStateNormal];
                
                
              
                
                
              
                
            }else{
                 
                [btnAvatare setBackgroundImage:[UIImage imageWithCGImage:[asset thumbnail] ]  forState:UIControlStateNormal];
            }
            
           
            
            btnAvatare.contentMode = UIViewContentModeScaleAspectFit;
            

            if(imgSelected!=nil){
                   [cell addSubview:btnAvatare];
                [cell addSubview:imgSelected];
              
            }else{
                [cell addSubview:btnAvatare];
            }
            x+=size+deltaX;
        }
        
      /*
        
        UIImage *image;
        ALAsset *result = [dataArray objectAtIndex:indexPath.row];
        ALAssetRepresentation *rep = [result defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            image =[  UIImage imageWithCGImage:iref];
            UIButton *btnAvatare = [[UIButton alloc]initWithFrame:CGRectMake(x,0,size,size)];
            btnAvatare.contentMode = UIViewContentModeScaleAspectFit;
            [btnAvatare setBackgroundImage:image  forState:UIControlStateNormal];
            [cell addSubview:btnAvatare];

        }
        */

        
    }
    //[cell.textLabel setText: [dataArray objectAtIndex:indexPath.row];
    return cell;
}


-(void)addImage:(ALAsset*)asset{

    UIImage *image;
    
    
  //  NSLog(@"asset:%@",result);
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    ALAssetOrientation orientation = [representation orientation];
    image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:[representation scale] orientation:(UIImageOrientation)orientation];
    
    
//    [dataArray addObject:image];
  
    
    
    
    //   [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];

}




- (void)applicationDidBecomeActive
{
        
    [_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
  
}

-(void)sendImageMaked:(UIImage*)image{
    if(_acceptSegue){
        [self performSegueWithIdentifier:_acceptSegue sender:image];
        _acceptSegue = NULL;
    }
    else{
        [_ownerImage performSelector:_imageSetterSelector withObject:image];
        [[self navigationController]popViewControllerAnimated:YES];
        
    }
}

- (IBAction)bntAcceptPhotoDone:(id)sender {
    
    [self sendImageMaked:[_imagePhotoDone image]];
   /*
    if(_acceptSegue){
        [self performSegueWithIdentifier:_acceptSegue sender:[_imagePhotoDone image]];
        _acceptSegue = NULL;
    }
    else{
        [_ownerImage performSelector:_imageSetterSelector withObject:[_imagePhotoDone image]];
        [[self navigationController]popViewControllerAnimated:YES];
        
    }
    */
}
//  go out from gallery album
- (IBAction)btnAcceptGalleryClicked:(id)sender {
    
    
 //   NSLog(@" scroll coordinate :x%f  y%f ",_scrollPhotoGallerySelected.contentOffset.x,_scrollPhotoGallerySelected.contentOffset.y);
    
    float xCrop;
    float yCrop;
    float heightCrop;
    float widthCrop;
   
    CGPoint offset = _scrollPhotoGallerySelected.contentOffset;
    UIImage *image =_imageViewPhotoGallery.image;
    
    
 
    CGSize sizeImage = _imageViewPhotoGallery.image.size;
    CGSize sizeView = _scrollPhotoGallerySelected.bounds.size;
    
    float widthratio = sizeImage.width/sizeView.width;
    float heightratio =  ( sizeImage.height/sizeView.height);
       
    
    
    
   // NSLog(@"offset y %f  ratio h %f", _scrollPhotoGallerySelected.contentOffset.y,heightratio);
    
    heightCrop = kIMAGE_GALLERY_CROP_SIZE*heightratio;
    widthCrop = kIMAGE_GALLERY_CROP_SIZE*widthratio;
    
      //  vertical image ratio
    if(_imageViewPhotoGallery.bounds.size.height>_imageViewPhotoGallery.bounds.size.width){
        yCrop =  (  offset.y*heightratio);
      
        float delta = [self getImageDeltaHeight]*heightratio;
        yCrop+=delta;
        xCrop = offset.x*widthratio;
    }else
        // gorizont image ratio
    {
        xCrop =offset.x*widthratio;
        float delta = [self getImageDeltaWidth]*widthratio;
        xCrop+=delta;
        yCrop = offset.y*heightratio;
    }
         // GET NEW CROPPED IMAGE
//    NSLog(@" X %f Y %f WIDTH %f HEIGTH %f",xCrop,yCrop,widthCrop,heightCrop);
    
/*    long w = CGImageGetWidth(image.CGImage);
    long h = CGImageGetHeight(image.CGImage);

    NSLog(@" CGI  width %d height %d",w,h);
    NSLog(@" imagesize  width %f height %f scale %f orient %d",image.size.width,image.size.height,image.scale,image.imageOrientation);
*/
    
    
    CGRect cropRect1 = CGRectMake(xCrop, yCrop,  heightCrop, widthCrop);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect1);
    UIImage *cropped = [[UIImage alloc] initWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
 //   NSLog(@" cropped size width %f  heigth %f ",cropped.size.width,cropped.size.height);
    
      [self sendImageMaked:cropped];
}




@end

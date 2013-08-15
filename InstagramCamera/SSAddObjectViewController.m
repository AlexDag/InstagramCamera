//
//  SSAddObjectViewController.m
//  SmartStuffSwap
//
//  Created by Alex on 6/9/13.
//  Copyright (c) 2013 AlexSem. All rights reserved.
//
/*   10 экран - редакция/добавление нового обьекта */
#import "SSAddObjectViewController.h"
#import "SSCameraViewController.h"


@interface SSAddObjectViewController ()

@end

@implementation SSAddObjectViewController{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    if(_selImage){

        [_btnImage setImage:_selImage forState:UIControlStateNormal];
        _selImage = nil;
    }
    
   }


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}





#pragma mark - image block

- (void)setSelectedImage:(UIImage *)selectedImage{
    
    
    [_btnImage setImage:selectedImage forState:UIControlStateNormal];
    //[_imageObject setImage:selectedImage];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *viewtarget =  [segue destinationViewController];
    if([viewtarget isKindOfClass:[SSCameraViewController class]]){
        SSCameraViewController *view =(SSCameraViewController*)viewtarget;
        view.ownerImage = self;
        view.imageSetterSelector = @selector(setSelectedImage:);
    }
 
    
    
}
- (IBAction)btnBackClicked:(id)sender {
    
        [[self navigationController]popViewControllerAnimated:YES];
    
}


@end

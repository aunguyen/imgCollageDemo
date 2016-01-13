//
//  ViewController.m
//  ImgCollage
//
//  Created by Au Nguyen on 1/5/16.
//  Copyright © 2016 Au Nguyen. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    UITapGestureRecognizer* tap;
    UIPanGestureRecognizer* pan;
    UIPinchGestureRecognizer* pinch;
    UILongPressGestureRecognizer* longPress;
    UIImagePickerController* ipc;
    UIView* tempImgView;
    UIImageView* tempIV;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll2;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initZoomForScrollView:_scroll1];
    [self initZoomForScrollView:_scroll2];
    [self initZoomForScrollView:_scroll3];
    [self addGestureForView:_scroll1];
    [self addGestureForView:_scroll2];
    [self addGestureForView:_scroll3];
    [self setupLayout];
}

- (void)addGestureForView:(UIView*)view{
    pinch     = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleImg:)];
    tap       = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImg:)];
    longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(getImg:)];
    [longPress setMinimumPressDuration:1];
    pan       = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(resizeView:)];
    [pan setMinimumNumberOfTouches:2];
    
    [view viewWithTag:100].userInteractionEnabled = YES;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:pan];
    [view addGestureRecognizer:pinch];
    [view addGestureRecognizer:tap];
    [[view viewWithTag:100] addGestureRecognizer:longPress];
}

- (void)addResizeRectToView:(UIView*)view{
    
}

- (void)initZoomForScrollView:(UIScrollView*)sv{
    sv.delegate = self;
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    sv.minimumZoomScale = 1.f;
    sv.maximumZoomScale = 4.f;
}

- (void)setupLayout{
    _h1.constant = _contentView.frame.size.height/3;
    _h2.constant = _contentView.frame.size.height/3;
    _h3.constant = _contentView.frame.size.height/3;
    
    _scroll1.layer.borderColor = [UIColor greenColor].CGColor;
    _scroll2.layer.borderColor = [UIColor greenColor].CGColor;
    _scroll3.layer.borderColor = [UIColor greenColor].CGColor;
    
    _scroll1.layer.borderWidth = 1.5;
    _scroll2.layer.borderWidth = 1.5;
    _scroll3.layer.borderWidth = 1.5;
    
    [_scroll1 setMultipleTouchEnabled:NO];
    [_scroll2 setMultipleTouchEnabled:NO];
    [_scroll3 setMultipleTouchEnabled:NO];
    
    tempIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 120)];
    tempIV.alpha = 0;
    [self.view addSubview:tempIV];
    
}

- (void)selectImg:(UITapGestureRecognizer*)tapGesture{
    tempImgView = tapGesture.view;
    [self showImgPickerForView:tempImgView];
}

- (void)getImg:(UILongPressGestureRecognizer*)longGesture{
    CGPoint location = [longGesture locationInView:self.view];
    UIImage* img = [(UIImageView*)longGesture.view image];
    
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        tempIV.image = img;
        tempIV.alpha = 0.7;
        tempIV.center = location;
    }else if (longGesture.state == UIGestureRecognizerStateChanged){
        tempIV.center = location;
    }else if (longGesture.state == UIGestureRecognizerStateEnded){
        
        if (CGRectContainsPoint(_view1.frame, location)) {
            _img1.image = tempIV.image;
        }
        
        if (CGRectContainsPoint(_view2.frame, location)) {
            _img2.image = tempIV.image;
        }

        if (CGRectContainsPoint(_view3.frame, location)) {
            _img3.image = tempIV.image;
        }
        
        tempIV.image = nil;
        tempIV.alpha = 0;
    }
    
    
}

- (void)resizeView:(UIPanGestureRecognizer*)panGesture{
    CGPoint location = [panGesture locationInView:self.view];
    
    if (CGRectContainsPoint(_view1.frame, location)) {
        NSLog(@"panning in view1");
    }
    
    if (CGRectContainsPoint(_view2.frame, location)) {
        NSLog(@"panning in view2");
    }
    
    if (CGRectContainsPoint(_view3.frame, location)) {
        NSLog(@"panning in view3");
    }
    
}

- (void)scaleImg:(UIPinchGestureRecognizer*)pinchGesture{
    [((UIScrollView*)pinchGesture.view) setZoomScale:pinchGesture.scale animated:YES];
}


- (void)showImgPickerForView:(UIView*)view{
    ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:ipc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    ((UIImageView*)[tempImgView viewWithTag:100]).image = [info objectForKey:UIImagePickerControllerOriginalImage];
}

//ios 9+
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    ((UIImageView*)[tempImgView viewWithTag:100]).image = [info objectForKey:UIImagePickerControllerOriginalImage];
//}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView viewWithTag:100];
}

- (IBAction)reset:(id)sender {
    
    UIImage* image = [UIImage imageNamed:@"addImg"];
    _img1.image = image;
    _img2.image = image;
    _img3.image = image;
    
    [_scroll1 setZoomScale:1];
    [_scroll2 setZoomScale:1];
    [_scroll3 setZoomScale:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

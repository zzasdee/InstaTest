//
//  DetailViewController.m
//  InstaTest
//

#import "DetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "Stuff.h"

@interface DetailViewController () <MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate>

@end



@implementation DetailViewController

@synthesize images;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < images.count; i++)
    {
        CGRect rect = [Stuff position:[images objectAtIndex:i] width:self.view.frame.size count:[images count] rate:i];

        UIView *view = [[UIView alloc] initWithFrame:rect];
        UIImageView *imageInView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];

        imageInView.image = [images objectAtIndex:i];
        imageInView.layer.cornerRadius = 7;
        imageInView.layer.masksToBounds = YES;
        
        [view addSubview:imageInView];
        [self.view addSubview:view];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [panGesture setDelegate:self];
        [panGesture setMaximumNumberOfTouches:1];
        [view addGestureRecognizer:panGesture];
    }
}


- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:recognizer.view];
    
}


- (IBAction)buttonSendMail:(id)sender
{
    UIImage *image = [Stuff makeSnapShot:self.view image:self.imageView offset:self.navigationController.toolbar.frame.size.height];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    
    [composer setMailComposeDelegate:self];
    
    if([MFMailComposeViewController canSendMail])
    {
        [composer setToRecipients:[NSArray arrayWithObjects:@"mail@mail.com",nil]];
        [composer setSubject:@"Subject"];
        [composer setMessageBody:@"Message Body" isHTML:NO];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        [composer addAttachmentData:data mimeType:@"image/jpeg" fileName:@"photo.jpg"];
        
        [self presentViewController:composer animated:YES completion:nil];
    }
}

@end

















//
//  DetailViewController.h
//  InstaTest
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *images;

- (IBAction)buttonSendMail:(id)sender;

@end

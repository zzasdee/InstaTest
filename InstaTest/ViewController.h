//
//  ViewController.h
//  InstaTest
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)buttonDownload:(id)sender;

@end


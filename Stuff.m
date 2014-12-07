//
//  Stuff.m
//  InstaTest
//

#import "Stuff.h"

@implementation Stuff


+ (void)showAllerMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Что-то пошло не так"
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"OK",nil];
    
    [alert show];
}


+ (NSData *)makeRequest:(NSString *)requestString
{
    NSURL *url = [NSURL URLWithString:requestString];
    if (!url) return nil;
    else
    {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:7.0];
        NSURLResponse *response;
        NSError *error;
        return [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    }
}


+ (NSMutableArray *)findSubtring:(NSString *)inputString byPattaern:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSArray *myArray = [regex matchesInString:inputString options:0 range:NSMakeRange(0, [inputString length])] ;
    
    NSMutableArray *matches = [NSMutableArray arrayWithCapacity:[myArray count]];
    NSMutableArray *links = [NSMutableArray arrayWithCapacity:[myArray count]];
    
    for (NSTextCheckingResult *match in myArray)
    {
        NSRange matchRange = [match rangeAtIndex:1];
        [matches addObject:[inputString substringWithRange:matchRange]];
        NSString *str =[[matches lastObject] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        if (![[str pathExtension] isEqualToString:@"mp4"])
        {
            [links addObject:str];
        }
    }
    return links;
}


+ (BOOL)isSrting:(NSString *)string contains:(NSString *)substring
{
    NSString *updSubstring = [NSString stringWithFormat:@"\"%@\"",substring];
    
    if ([string rangeOfString:updSubstring].location == NSNotFound)
        return NO;
    else
        return YES;
}


+ (CGRect)position:(UIImage *)image width:(CGSize)rect count:(uint)count rate:(int)rate
{
    CGFloat delta = rect.width / 320;
    
    return CGRectMake(delta * (10 + arc4random() % 50 + 120 * (rate % 2)),
                      80 + (delta * (rect.height - 200)) / count * rate,
                      delta * 130,
                      delta * (130 * image.size.height / image.size.width));
}


+ (UIImage *)makeSnapShot:(UIView *)view image:(UIImageView *)imageView offset:(CGFloat)offset
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(0, offset + 20, imageView.bounds.size.width, imageView.bounds.size.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return image;
}

@end
















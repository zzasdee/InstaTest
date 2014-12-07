//
//  Stuff.h
//  InstaTest
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Stuff : NSObject

// вывести сообщение об ошибке
+ (void)showAllerMessage:(NSString *)message;

// сделать запрос по URL
+ (NSData *)makeRequest:(NSString *)requestString;

// найти подстроку в строке по шаблону
+ (NSMutableArray *)findSubtring:(NSString *)inputString byPattaern:(NSString *)pattern;

// содержит ли строка подстроку
+ (BOOL)isSrting:(NSString *)string contains:(NSString *)substring;

// вернуть размер и позицию для вью с изображением
+ (CGRect)position:(UIImage *)image width:(CGSize)rect count:(uint)count rate:(int)rate;

// сделать скрин вью для отправки по почте
+ (UIImage *)makeSnapShot:(UIView *)view image:(UIImageView *)imageView offset:(CGFloat)offset;

@end

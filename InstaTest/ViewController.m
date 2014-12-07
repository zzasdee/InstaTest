//
//  ViewController.m
//  InstaTest
//

#import "ViewController.h"
#import "CustomCell.h"
#import "DetailViewController.h"
#import "Stuff.h"

#define CLIENT_ID @"8ee1d0f2d32943c2b0ea5723605c8332"

#define PATTERN_ID @"\"id\":\"(.*?)\""
#define PATTERN_LINK @"low_resolution\":\\{\"url\":\"(.*?)\""

#define SEARCH_USER_REQUEST @"https://api.instagram.com/v1/users/search?q=%@&client_id=%@"
#define FETCH_PHOTO_REQUEST @"https://api.instagram.com/v1/users/%@/media/recent?client_id=%@"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSMutableArray *linksArray;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;

@end



@implementation ViewController

@synthesize photoArray, linksArray, selectedPhotos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.allowsMultipleSelection = YES;
    
    linksArray = [[NSMutableArray alloc] init];
    photoArray = [[NSMutableArray alloc] init];
    selectedPhotos = [[NSMutableArray alloc] init];
}


- (void)getLinksforPhotos
{
    /* 1 */
    // получить имя из текстВью
    NSString *userName = self.textUserName.text;
    
    /* 2 */
    // создать строку для запроса поиска пользователей
    NSString *fetchIDString = [NSString stringWithFormat:SEARCH_USER_REQUEST, userName, CLIENT_ID];
    
    /* 3 */
    // получить данные по поиску пользователей
    NSData *dataWithID = [Stuff makeRequest:fetchIDString];
    if (dataWithID == nil)
    {
        [Stuff showAllerMessage:@"Не удалось получить ответ от сервера"];
        return;
    }
    
    /* 4 */
    // сделать из данных строку
    NSString *stringWithID = [[NSString alloc] initWithData:dataWithID encoding:NSUTF8StringEncoding];
    if (![Stuff isSrting:stringWithID contains:userName])
    {
        [Stuff showAllerMessage:@"Не удалось найти пользователя"];
        return;
    }
    
    /* 5 */
    // получить ID пользователя
    NSMutableArray *userIDS = [Stuff findSubtring:stringWithID byPattaern:PATTERN_ID];
    if ([userIDS count] == 0)
    {
        [Stuff showAllerMessage:@"Не удалось получить ID пользователя"];
        return;
    }
    
    NSString *userID = [userIDS objectAtIndex:0];
    
    /* 6 */
    // создать строку для запроса ссылок на фото
    NSString *fetchPhotoLinksString = [NSString stringWithFormat:FETCH_PHOTO_REQUEST, userID, CLIENT_ID];
    
    /* 7 */
    // получить данные с ссылками на фото
    NSData *dataWithPhotos = [Stuff makeRequest:fetchPhotoLinksString];
    if (dataWithPhotos == nil)
    {
        [Stuff showAllerMessage:@"Не удалось получить ответ от сервера"];
        return;
    }
    
    /* 8 */
    // сделать из данных строку
    NSString *stringWithPhotos = [[NSString alloc] initWithData:dataWithPhotos encoding:NSUTF8StringEncoding];
    
    /* 9 */
    // найти все сслыки на фото
    linksArray = [Stuff findSubtring:stringWithPhotos byPattaern:PATTERN_LINK];
    if ([linksArray count] == 0)
    {
        [Stuff showAllerMessage:@"У польователя нет фото"];
        return;
    }
}


- (void)addDownloadedPhoto:(NSData *)data
{
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    
    [photoArray addObject:[UIImage imageWithData:data]];
    [selectedPhotos addObject:@NO];
    [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:[photoArray count] - 1 inSection:0]];
    
    [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
}


- (void)downloadPhotos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < linksArray.count; i++)
        {
            NSData *data = [Stuff makeRequest:[linksArray objectAtIndex:i]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([UIImage imageWithData:data] != nil)
                    [self addDownloadedPhoto:data];
                else
                    [Stuff showAllerMessage:@"Не удалось загрузить фото]"];
            });
        }
    });
}


- (void)refreshData
{
    [selectedPhotos removeAllObjects];
    
    NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
    
    for (int i = 0; i < photoArray.count; i++)
        [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    [photoArray removeAllObjects];
    
    [self.collectionView deleteItemsAtIndexPaths:arrayWithIndexPaths];
}



#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photoArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = [photoArray objectAtIndex:indexPath.row];
    
    if ([[selectedPhotos objectAtIndex:indexPath.row] boolValue])
        cell.imageOK.image = [UIImage imageNamed:@"ok.png"];
    else
        cell.imageOK.image = nil;

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat f = (self.view.bounds.size.width - 6) / 4;
    return CGSizeMake(f, f);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageOK.image = [UIImage imageNamed:@"ok.png"];
    
    [selectedPhotos replaceObjectAtIndex:indexPath.row withObject:@YES];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = (CustomCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.imageOK.image = nil;
    
    [selectedPhotos replaceObjectAtIndex:indexPath.row withObject:@NO];
}



#pragma mark - Prepare For Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Segue"])
    {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        DetailViewController *dvc = [segue destinationViewController];
        
        for (int i = 0; i < photoArray.count; i++)
            if ([[selectedPhotos objectAtIndex:i] boolValue])
                [data addObject:[photoArray objectAtIndex:i]];
        
        [dvc setImages:data];
    }
}



#pragma mark - Interface

- (IBAction)buttonDownload:(id)sender
{
    [self refreshData];
    
    if ([self.textUserName.text isEqual:@""])
    {
        [Stuff showAllerMessage:@"Введите имя пользователя"];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getLinksforPhotos];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self downloadPhotos];
        });
    });
}

@end








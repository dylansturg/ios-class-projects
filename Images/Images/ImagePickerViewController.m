//
//  ImagePickerViewController.m
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "ImagePickerCollectionViewController.h"
#import "ImagePickerNavigationController.h"
#import "ImagePickerTableViewCell.h"
#import <Photos/Photos.h>

@interface ImagePickerViewController () <PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) NSOperationQueue *backgroundWork;
@property (strong, nonatomic) PHFetchResult *smartAlbums;
@property (strong, nonatomic) NSMutableDictionary* smartAlbumsContents;
@end

static NSString *reuseIdentifier = @"ImageLibraryCell";
NSString *const ImagePickerControllerInfoImage = @"ImagePickerControllerInfoImage";

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundWork = [[NSOperationQueue alloc] init];
    
    if (self.navigationController){
        if ([self.navigationController isKindOfClass:[ImagePickerNavigationController class]]) {
            self.delegate = ((ImagePickerNavigationController*)self.navigationController).imagePickerDelegate;
        }
    }
    
    self.tableView.rowHeight = 50;
    [self.tableView registerNib:[UINib nibWithNibName:@"ImagePickerTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self verifyOrRequestAuthorization];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark private
-(void) verifyOrRequestAuthorization {
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        [self lookupPhotoCollections];
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status != PHAuthorizationStatusAuthorized){
                if(self.delegate){
                    [self.delegate imagePickerDidCancel:self
                                             withReason:ImagePickerViewControllerCancelReasonUnauthorized];
                }
            } else { // stuats == PHAuthorizationStatusAuthorized
                [self lookupPhotoCollections];
            }
        }];
    }
}

-(void) lookupPhotoCollections {
    
    [self.backgroundWork addOperationWithBlock:^{
        PHFetchResult *fetchSmartAblums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        self.smartAlbums = fetchSmartAblums;
        
        NSMutableDictionary *albums = [[NSMutableDictionary alloc] init];
        [self.smartAlbums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *collection = (PHAssetCollection*) obj;
            
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
            PHFetchResult *contents = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            [albums setObject:contents forKey:collection];
        }];
        self.smartAlbumsContents = albums;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
}

# pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"presentAlbum" sender:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smartAlbums ? self.smartAlbums.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAssetCollection *album = self.smartAlbums[indexPath.row];
    cell.titleLabel.text = album.localizedTitle;
    
    PHFetchResult *fetchedAlbum = [self.smartAlbumsContents objectForKey:album];
    if (fetchedAlbum && fetchedAlbum.count){
        int randomIndex = arc4random_uniform((int)fetchedAlbum.count);
        PHAsset *posterAsset = fetchedAlbum[randomIndex];
        [[PHImageManager defaultManager] requestImageForAsset:posterAsset targetSize:cell.posterImage.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
            cell.posterImage.image = result;
        }];
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark InterfaceBuilder

- (IBAction)didCancel:(id)sender {
    if(self.delegate){
        [self.delegate imagePickerDidCancel:self withReason:ImagePickerViewControllerCancelReasonUserRequested];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *fetchCollectionChanges = [changeInstance changeDetailsForFetchResult:self.smartAlbums];
    
    if (fetchCollectionChanges){
        self.smartAlbums = fetchCollectionChanges.fetchResultAfterChanges;
    }
    
    [self.smartAlbumsContents enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:obj];
        if (collectionChanges){
            [self.smartAlbumsContents setObject:collectionChanges.fetchResultAfterChanges forKey:key];
        }
    }];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PHAssetCollection *selectedAlbum = self.smartAlbums[indexPath.row];
    ImagePickerCollectionViewController *collectionViewController = [segue destinationViewController];
    collectionViewController.title = selectedAlbum.localizedTitle;
    collectionViewController.delegate = self.delegate;
    collectionViewController.container = self;
    collectionViewController.album = selectedAlbum;
}


@end

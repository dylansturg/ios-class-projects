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
#import <Photos/Photos.h>

@interface ImagePickerViewController () <PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) NSOperationQueue *backgroundWork;
@property (strong, nonatomic) PHFetchResult *smartAlbums;
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
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smartAlbums ? self.smartAlbums.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAssetCollection *album = self.smartAlbums[indexPath.row];
    cell.textLabel.text = album.localizedTitle;
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
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
        [self.tableView reloadData];
    }
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

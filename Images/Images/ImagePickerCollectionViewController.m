//
//  ImagePickerCollectionViewController.m
//  Images
//
//  Created by Dylan Sturgeon on 5/6/15.
//  Copyright (c) 2015 dylansturg. All rights reserved.
//

#import <Photos/Photos.h>

#import "ImagePickerViewController.h"
#import "ImagePickerCollectionViewController.h"
#import "ImagePickerCollectionViewCell.h"

@interface ImagePickerCollectionViewController () <PHPhotoLibraryChangeObserver>

@property (strong, nonatomic) PHFetchResult *albumContents;
@property (strong, nonatomic) NSOperationQueue *backgroundWork;

@end

@implementation ImagePickerCollectionViewController

static NSString * const reuseIdentifier = @"ImageCell";
static CGSize const cellSize = (CGSize){.width = 50, .height = 50};

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    if (self.navigationController){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didCancel:)];
    }
    
    self.backgroundWork = [[NSOperationQueue alloc] init];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionViewLayout;
    layout.itemSize = cellSize;
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImagePickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.backgroundWork addOperationWithBlock:^{
        PHFetchOptions *options = [[PHFetchOptions alloc]init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
        PHFetchResult *fetchReslt = [PHAsset fetchAssetsInAssetCollection:self.album options:options];
        self.albumContents = fetchReslt;
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumContents ? self.albumContents.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.albumContents[indexPath.row];

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:cellSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *selectedAsset = self.albumContents[indexPath.row];
    
    [[PHImageManager defaultManager] requestImageForAsset:selectedAsset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        
        NSDictionary *pickerResultInfo = [NSDictionary dictionaryWithObjectsAndKeys: result, ImagePickerControllerInfoImage, nil];
        if (self.delegate) {
            [self.delegate imagePicker:self.container didFinishPickingMediaWithInfo:pickerResultInfo];
        }
    }];
}

#pragma mark <PHPhotoLibraryChangeObserver>

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    PHFetchResultChangeDetails *fetchCollectionChanges = [changeInstance changeDetailsForFetchResult:self.albumContents];
    
    if (fetchCollectionChanges){
        self.albumContents = fetchCollectionChanges.fetchResultAfterChanges;
        
        if (fetchCollectionChanges.hasIncrementalChanges) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView performBatchUpdates:^{
                    NSIndexSet *removed = fetchCollectionChanges.removedIndexes;
                    if (removed.count) {
                        [self.collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:removed]];
                    }
                    NSIndexSet *inserted = fetchCollectionChanges.insertedIndexes;
                    if (inserted.count) {
                        [self.collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:inserted]];
                    }
                    NSIndexSet *changed = fetchCollectionChanges.changedIndexes;
                    if (changed.count) {
                        [self.collectionView reloadItemsAtIndexPaths:[self indexPathsFromIndexSet:changed]];
                    }
                    if (fetchCollectionChanges.hasMoves) {
                        [fetchCollectionChanges enumerateMovesWithBlock:^(NSUInteger fromIndex, NSUInteger toIndex) {
                            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForItem:fromIndex inSection:0];
                            NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
                            [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                        }];
                    }
 
                } completion:nil];
            }];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }
    }
}

# pragma mark Private
- (void) didCancel: (id) sender {
    if (self.delegate){
        [self.delegate imagePickerDidCancel:self.container withReason:ImagePickerViewControllerCancelReasonUserRequested];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSArray *) indexPathsFromIndexSet: (NSIndexSet*) set {
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
        [paths addObject:path];
    }];
    
    return [NSArray arrayWithArray:paths];
}


@end

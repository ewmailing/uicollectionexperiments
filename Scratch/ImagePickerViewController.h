//
//  ImagePickerViewController.h
//  Scratch
//
//  Created by Eric Wing on 1/15/13.
//
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIViewController  <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(weak, nonatomic) id<UICollectionViewDelegate> collectionViewDelegate;

@end

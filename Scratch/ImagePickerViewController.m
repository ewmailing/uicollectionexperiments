//
//  ImagePickerViewController.m
//  Scratch
//
//  Created by Eric Wing on 1/15/13.
//
//

#import "ImagePickerViewController.h"
#import "ImageViewCell.h"

@interface ImagePickerViewController ()
{
	NSArray *recipeImages;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ImagePickerViewController

- (void) setCollectionViewDelegate:(id<UICollectionViewDelegate>)the_delegate
{
	[[self collectionView] setDelegate:the_delegate];
	_collectionViewDelegate = the_delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	UINib *cellNib = [UINib nibWithNibName:@"ImageViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ImageCell"];

	/* uncomment this block to use subclassed cells */
//    [self.collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:@"ImageCell"];
    /* end of subclass-based cells block */
    
    // Configure layout
	/*
	 UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	 [flowLayout setItemSize:CGSizeMake(111, 111)];
	 [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
	 [self.collectionView setCollectionViewLayout:flowLayout];
	 */
	
	[self.collectionView setAllowsSelection:YES];
	[[self collectionView] setDelegate:_collectionViewDelegate];

    // Initialize recipe image array
    recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return recipeImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ImageCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    return cell;
}

@end

//
//  ViewController.m
//  Scratch
//
//  Created by Eric Wing on 1/12/13.
//
//

#import "ViewController.h"
#import "WEPopoverController.h"
#import "WEPopoverContainerView.h"
#import "ImagePickerViewController.h"
#import "CloseButton.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton* plusButton;
@property (weak, nonatomic) IBOutlet UIView* canvasView;
@property (assign, nonatomic, getter=isPlusMenuActive) BOOL plusMenuActive;
@property (nonatomic, retain) WEPopoverController* menuPopoverController;

@property(retain, nonatomic) UILongPressGestureRecognizer* longPressRecognizer;
@property(assign, nonatomic) _Bool inDeleteMode;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[[self plusButton] setTransform:CGAffineTransformIdentity];
	
	
	
	
	UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressing:)];
	//	[pressRecognizer setMinimumNumberOfTouches:1];
	//	[pressRecognizer setMaximumNumberOfTouches:1];
	[pressRecognizer setDelegate:self];
	[[self canvasView] addGestureRecognizer:pressRecognizer];
	_longPressRecognizer = pressRecognizer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) onPlusPress:(id)the_sender
{
//	[UIView setAnimationDuration:1.0];
  //  someview.transform = CGAffineTransformMakeRotation(angle);
//    [UIView commitAnimations]
	CGRect plus_button_rect = [[self plusButton] frame];
	CGFloat button_angle;
	if([self isPlusMenuActive] == NO)
	{
		button_angle = M_PI/4;
		[self setPlusMenuActive:YES];

	}
	else
	{
		button_angle = 0.0;
		[self setPlusMenuActive:NO];

	}
	
	[UIView animateWithDuration:.25
						  delay:0
						options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
					 animations:^{
	[[self plusButton] setTransform:CGAffineTransformMakeRotation(button_angle)];
						 }
					 completion:^(BOOL finished) { }
	 ];
	 
	
	if (!self.menuPopoverController) {
		

		
		ImagePickerViewController* image_view_controller = [[ImagePickerViewController alloc] init];
		[image_view_controller setCollectionViewDelegate:self];
//		[self presentModalViewController:image_view_controller animated:YES];
//		return;
		self.menuPopoverController = [[WEPopoverController alloc] initWithContentViewController:image_view_controller];

		self.menuPopoverController.delegate = self;
//		self.menuPopoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		
		/*
		NSArray *segmentedItems = [NSArray arrayWithObjects:@"Bookmarks", @"Recents", @"Contacts", nil];
		UISegmentedControl *ctrl = [[UISegmentedControl alloc] initWithItems:segmentedItems];
		ctrl.segmentedControlStyle = UISegmentedControlStyleBar;
		ctrl.selectedSegmentIndex = 0;
		
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:ctrl];
		ctrl.frame = CGRectMake(0.0f, 5.0f, 320.0f, 30.0f);
		
		NSArray *theToolbarItems = [NSArray arrayWithObjects:item, nil];
		[image_view_controller setToolbarItems:theToolbarItems];
		//	[ctrl release];
		//	[item release];
*/
		
	/*
	 [self.menuPopoverController presentPopoverFromBarButtonItem:the_sender
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
													   animated:YES];
	*/
		[self.menuPopoverController presentPopoverFromRect:plus_button_rect
												inView:self.canvasView
							  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown|
														UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight)
											  animated:YES];
		
	} else {
		[self.menuPopoverController dismissPopoverAnimated:YES];
		[self cleanupMenuPopover];

	}
	
	
	
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController
{
	[self cleanupMenuPopover];
}

- (void) cleanupMenuPopover
{
	
	//Safe to release the popover here
	self.menuPopoverController = nil;
	
	CGFloat button_angle = 0.0;
	[self setPlusMenuActive:NO];
		
	
	[UIView animateWithDuration:.25
						  delay:0
						options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
					 animations:^{
						 [[self plusButton] setTransform:CGAffineTransformMakeRotation(button_angle)];
					 }
					 completion:^(BOOL finished) { }
	 ];
	[self setMenuPopoverController:nil];

	
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	[self cleanupMenuPopover];
	
	return YES;
}



// delegate for UICollectionView in image picker popover

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
    NSLog(@"cell #%d was selected", indexPath.row);


	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	UIImageView* selected_image = (UIImageView *)[cell viewWithTag:100];
	
//	[selected_image setCenter:CGPointMake(CGRectGetMidX([[self canvasView] frame]), CGRectGetMidY([[self canvasView] frame]))];

	[[self canvasView] addSubview:selected_image];
	selected_image.center = [self canvasView].center;

	
	selected_image.userInteractionEnabled = YES;
	UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]
										initWithTarget:self
										action:@selector(imageDragged:)];
	[selected_image addGestureRecognizer:gesture];

	
	
	[self.menuPopoverController dismissPopoverAnimated:YES];
	[self cleanupMenuPopover];


}


- (void)imageDragged:(UIPanGestureRecognizer *)gesture
{
	UIImageView *selected_image = (UIImageView *)gesture.view;
	CGPoint translation = [gesture translationInView:selected_image];
	
	// move label
	selected_image.center = CGPointMake(selected_image.center.x + translation.x,
							   selected_image.center.y + translation.y);
	
	// reset translation
	[gesture setTranslation:CGPointZero inView:selected_image];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognize:(UIGestureRecognizer *)otherGestureRecognizer
{
    // If you have multiple gesture recognizers in this delegate, you can filter them by comparing the gestureRecognizer parameter to your saved objects
    return NO; // Also, very important.
}

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 1.0

-(void)longPressing:(UILongPressGestureRecognizer *)gesture
{
	if([self inDeleteMode])
	{
		return;
	}
	
	if(gesture.state == UIGestureRecognizerStateBegan)
    {
		//		[[self panRecognizer] setEnabled:NO];
		NSArray* views = [[self canvasView] subviews];
		NSUInteger image_view_count = 0;
		if([views count] == 0)
		{
			return;
		}
		else
		{
			[self setInDeleteMode:true];
		}
		for(UIView* item_view in views)
		{
			if( ! [item_view isKindOfClass:[UIImageView class]])
			{
				continue;
			}
			
			image_view_count++;
			//			UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,120,120)];
			//			[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
			
			//			CloseButton *closeButton = [CloseButton buttonWithType:UIButtonTypeRoundedRect];
			CloseButton *closeButton = [[CloseButton alloc] initWithFrame:CGRectMake(0,0,88,88)];
			//			closeButton.buttonType = UIButtonTypeRoundedRect;
			closeButton.frame = CGRectMake(20, 20, 88, 88);
			[closeButton setTitle:@"X" forState:UIControlStateNormal];
//			[closeButton setCanvasView:self];
			[closeButton setItemView:item_view];
			[closeButton addTarget:closeButton action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
			//			[myView addSubview:closeButton];
			
			[item_view addSubview:closeButton];
			
			
			NSInteger randomInt = arc4random()%500;
			float r = (randomInt/500.0)+0.5;
			
			CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDeg * -1.0) - r ));
			CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg + r ));
			
			item_view.transform = leftWobble;  // starting point
			
			[[item_view layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
			
			[UIView animateWithDuration:0.1
								  delay:0
								options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
							 animations:^{
								 [UIView setAnimationRepeatCount:NSNotFound];
								 item_view.transform = rightWobble; }
							 completion:nil];
		}
		
		if(image_view_count == 0)
		{
			[self setInDeleteMode:false];
		}
		
	}
	else if(UIGestureRecognizerStateEnded == gesture.state
			|| UIGestureRecognizerStateCancelled == gesture.state
			|| UIGestureRecognizerStateFailed == gesture.state
			)
	{
		NSLog(@"ended: %d", gesture.state);
		//		[[self panRecognizer] setEnabled:YES];
		
	}
	
}
/*
- (void) setInDeleteMode:(bool)inDeleteMode
{
	_inDeleteMode = inDeleteMode;
	if(inDeleteMode)
	{
		[[self panRecognizer] setEnabled:NO];
	}
	else
	{
		[[self panRecognizer] setEnabled:YES];
		
	}
}
 */

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([self inDeleteMode])
	{
		[self setInDeleteMode:false];
		
		NSArray* views = [[self canvasView] subviews];
		for(UIView* item_view in views)
		{
			if( ! [item_view isKindOfClass:[UIImageView class]])
			{
				continue;
			}
			
			for(UIView* button in [item_view subviews])
			{
				if( [button isKindOfClass:[CloseButton class]])
				{
					[button removeFromSuperview];
				}
			}
			
			[item_view.layer removeAllAnimations];
			
			item_view.transform = CGAffineTransformIdentity;
		}
		
	}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*
	 if([self inDeleteMode])
	 {
	 [self setInDeleteMode:false];
	 }
	 */
}

@end

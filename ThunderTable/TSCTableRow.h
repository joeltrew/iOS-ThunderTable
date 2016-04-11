//
//  TSCTableRow.h
// ThunderTable
//
//  Created by Phillip Caudell on 16/08/2013.
//  Copyright (c) 2013 madebyphill.co.uk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSCTableRowDataSource.h"

/**
 `TSCTableRow` is the primary class for creating rows within a `TSCTableViewController`. Each row must be contained within a `TSCTableSection`.
 */
@interface TSCTableRow : NSObject <TSCTableRowDataSource>

///---------------------------------------------------------------------------------------
/// @name Initializing a TSCTableRow Object
///---------------------------------------------------------------------------------------

/**
 Initializes the row with a single title.
 @param title The title to display in the row
 @discussion The title will populate the `textLabel` text property of a `UITableViewCell`
 */
+ (instancetype _Nonnull)rowWithTitle:(NSString * _Nullable)title;

/**
 Initializes the row with a single title in a custom color
 @param title The title to display in the row
 @param textColor A 'UIColor' to color the text with
 @discussion The title will populate the `textLabel` text property of a `UITableViewCell`. The textColor will be applied to the text.
 */
+ (instancetype _Nonnull)rowWithTitle:(NSString * _Nullable)title textColor:(UIColor * _Nullable)textColor;

/**
 Initializes the row with a single title.
 @param title The title to display in the row
 @param subtitle The subtitle to display beneath the title in the row
 @param image The image to be displayed to the left hand side of the cell
 @discussion The title will populate the `textLabel` text property and the subtitle will populate the `detailTextLabel` text property of the `UITableViewCell`
 */
+ (instancetype _Nonnull)rowWithTitle:(NSString * _Nullable)title subtitle:(NSString * _Nullable)subtitle image:(UIImage * _Nullable)image;

/**
 Initializes the row with a single title.
 @param title The title to display in the row
 @param subtitle The subtitle to display beneath the title in row
 @param imageURL The URL of the image to be displayed to the left hand side of the cell. Loaded asynchronously
 @discussion The title will populate the `textLabel` text property and the subtitle will populate the `detailTextLabel` text property of the `UITableViewCell`
 @note Please set the `imagePlaceholder` property when using this method. This is required because the image width and height is used at layout to provide appropriate space for your loaded image.
 */
+ (instancetype _Nonnull)rowWithTitle:(NSString * _Nullable)title subtitle:(NSString * _Nullable)subtitle imageURL:(NSURL * _Nullable)imageURL;

///---------------------------------------------------------------------------------------
/// @name Handling selection
///---------------------------------------------------------------------------------------

/**
 Adds a target and selector to the cell. This makes the row selectable.
 @param target The object to send the selection event to
 @param selector The selector to call on the target object
 @discussion Calling this method makes the cell selectable in the table view, also adding a selection indicator to the cell
 */
- (void)addTarget:(id _Nullable)target selector:(SEL _Nullable)selector;

/**
 @abstract The object to be called upon the user selecting the row
 */
@property (nonatomic, weak) id _Nullable target;

/**
 @abstract The selector to be called on the target upon the user selecting the row
 */
@property (nonatomic, assign) SEL _Nullable selector;

///---------------------------------------------------------------------------------------
/// @name Row configuration
///---------------------------------------------------------------------------------------

/**
 @abstract The text to be displayed in the cells `textLabel`
 */
@property (nonatomic, copy) NSString * _Nullable title;

/**
 @abstract The text to be displayed in the cells `detailTextLabel`
 */
@property (nonatomic, copy) NSString * _Nullable subtitle;

/**
 @abstract The `UIImage` to be displayed in the cell
 */
@property (nonatomic, strong) UIImage * _Nullable image;

/**
 @abstract The URL of the image to be loaded into the image area of the cell
 */
@property (nonatomic, strong) NSURL * _Nullable imageURL;

/**
 @abstract The placeholder image that is displayed whilst the cell is asynchronously loading the image defined by the `imageURL`
 @discussion Once the image has loaded from the URL it will be displayed at the same size as the placeholderImage so make sure that placeholderImage is the same size as the returned image. Not doing so causes strange frame behaviour of the cells `imageView`
 */
@property (nonatomic, strong) UIImage * _Nullable imagePlaceholder;

/**
 @abstract The `UIColor` to apply to the text in the cell
 */
@property (nonatomic, strong) UIColor * _Nullable titleTextColor;

/**
 @abstract The `UIColor` to apply to the detail text in the cell
 */
@property (nonatomic, strong) UIColor * _Nullable detailTextColor;

/**
 @abstract The `UIColor` to apply to the background of the cell
 */
@property (nonatomic, strong) UIColor * _Nullable backgroundColor;

/**
 @abstract The link that a row should attempt to push when selected
 */
@property (nonatomic, strong) TSCLink * _Nullable link;


/**
 @abstract A boolean to configure whether the cell shows the selection indicator when it is selectable
 @discussion The default value of this property is `YES`
 */
@property (nonatomic, assign) BOOL rowShouldDisplaySelectionIndicator;

/**
 @abstract A boolean to configure whether the cell's text should be centered
 */
@property (nonatomic) BOOL shouldCenterText;

/**
 @abstract A boolean to configure whether the cell's text should be inset
 */
@property (nonatomic) BOOL shouldInsetTextLabel;

/**
 @abstract The accessory type of the row
 */
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/**
 @abstract The amount of padding to add above and below the contents of the cell.
 @discussion You may find that adjusting this padding value on the cell improves the look and feel of your app
 */
@property (nonatomic, assign) float padding;

@end

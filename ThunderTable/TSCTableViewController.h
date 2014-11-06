//
//  TSCTableViewController.h
//  American Red Cross Disaster
//
//  Created by Phillip Caudell on 16/08/2013.
//  Copyright (c) 2013 madebyphill.co.uk. All rights reserved.
//

#import "TSCTableRowDataSource.h"
#import "TSCTableInputRowDataSource.h"
#import "TSCTableInputSliderRowDataSource.h"
#import "TSCTableSection.h"
#import "TSCTableRow.h"
#import "TSCTableSelection.h"
#import "TSCTableInputRow.h"
#import "TSCTableInputCheckRow.h"
#import "TSCTableInputTextFieldRow.h"
#import "TSCTableInputTextViewRow.h"
#import "TSCTableInputSwitchRow.h"
#import "TSCTableInputPickerRow.h"
#import "TSCTableInputDatePickerRow.h"
#import "TSCTableImageRow.h"
#import "TSCTableValue1Row.h"
#import "TSCTableInputViewCell.h"

@class TSCTableSection;

/**
 `TSCTableViewController` is a subclass of UIViewController that provides convenient methods for quick creation of a `UITableViewController`. This class inherits from `UIViewController` because it provides easier access and cusomisation opportunities than subclassing UITableViewController.
 
 Although a `TSCTableViewController` can be used with the usual delegate and datasource methods of a `UITableViewController` it is recommended that you use the following classes;
 
 - `TSCTableRow` for rows
 - `TSCTableSection` for sections
 
 */
@interface TSCTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TSCTableInputViewCellDelegate, UITextFieldDelegate>

///---------------------------------------------------------------------------------------
/// @name Initializing a TSCTableView Object
///---------------------------------------------------------------------------------------

/**
 Initializes the `tableView`
 @param style The `UITableViewStyle` to initialise the `tableView` with.
 */
- (instancetype)initWithStyle:(UITableViewStyle)style;

///---------------------------------------------------------------------------------------
/// @name Configuring the Data Source
///---------------------------------------------------------------------------------------

/**
 @abstract An array of TSCTableSection items to be displayed in the view
 @discussion Setting this property will reload the table view with the given sections
 */
@property (nonatomic, strong) NSArray *dataSource;


/**
 Set the dataSource of the table view to reload with the new content
 @param dataSource An array of `TSCTableSection`s
 @param animated A boolean indicating whether or not the table view should animate it's reload
 */
- (void)setDataSource:(NSArray *)dataSource animated:(BOOL)animated;

/**
 @abstract An array of section items generated from all sections in the `dataSource`
 @discussion This property is generated by taking each `TSCTableSection` in the `dataSource` and compounding them into one array
 */
@property (nonatomic, strong) NSArray *flattenedDataSource;

///---------------------------------------------------------------------------------------
/// @name Configuring the Table View
///---------------------------------------------------------------------------------------

/**
 @abstract The current table view
 @discussion Use this property for accessing information about the underlying table view
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 @abstract The current `UITableViewStyle` of the `tableView`
 @discussion This property should be initialised by one of the designated initializers below
 */
@property (nonatomic, assign) UITableViewStyle style;

/**
 @abstract Used to enable Alphabetical index titles down the side of a table view by section
 @discussion Each section should have a title set before enabling this property
 */
@property (nonatomic, assign) BOOL shouldDisplayAlphabeticalSectionIndexTitles;

/**
 @abstract Enable or disabled seperators between table cells
 */
@property (nonatomic, assign) BOOL shouldDisplaySeparatorsOnCells;

/**
 @abstract A boolean value indicating if the `tableView` should automatically make the first text field in the `dataSource` the first responder upon load
 @discussion The default value of this property is `YES`. When set to `YES` the first responder will be set in `viewDidAppear` the first time the view appears.
 */
@property (nonatomic, assign) BOOL shouldMakeFirstTextFieldFirstResponder;

///---------------------------------------------------------------------------------------
/// @name Managing Refreshing
///---------------------------------------------------------------------------------------

/**
 @abstract The refresh control used for "Pull to refresh" on the `tableView`
 @discussion This property will return nil if `refreshEnabled` is set to NO
 */
@property (nonatomic, strong) UIRefreshControl *refreshControl;

/**
 Called when the `refreshControl` changes it's refresh state
 @discussion Override this method in your own class to perform custom tasks when a pull to refresh action is initiated
 */
- (void)handleRefresh;

/**
 @abstract A boolean to enable or disabled the `refreshControl` on the `tableView`
 @discussion Use `isRefreshEnabled` to check the state of this boolean
 */
@property (nonatomic, assign, getter = isRefreshEnabled) BOOL refreshEnabled;

/**
 @abstract A boolean to set the `refreshControl` into or out of the refreshing state
 @discussion Use `isRefreshing` to check the state of this boolean. Setting this property to YES will cause the refresh control to display an animated loading indicator at the top of the `tableView`
 */
@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;

///---------------------------------------------------------------------------------------
/// @name Managing Editing
///---------------------------------------------------------------------------------------

/**
 @abstract The button to be used when setting the `tableView` to editing mode
 @discussion A default edit button is provided automatically, use this property to provide a custom button if desired
 */
@property (nonatomic, strong) UIBarButtonItem *editItem;

///---------------------------------------------------------------------------------------
/// @name Accessing Input Information
///---------------------------------------------------------------------------------------

/**
 @abstract A dictionary of keys and values populated from the `tableView` when displaying `TSCTableInputRow`'s.
 @discussion The key of each entry is the `inputId` of each `TSCTableInputRow` where the key is it's corresponding `value`
 */
@property (nonatomic, strong) NSDictionary *inputDictionary;

///---------------------------------------------------------------------------------------
/// @name Managing Input Validation
///---------------------------------------------------------------------------------------

/**
 @abstract An array of `TSCTableInputRow`'s that have the `required` property set to YES but have not yet had their input criteria satisfied
 */
@property (nonatomic, strong) NSArray *missingRequiredInputRows;

/**
 @abstract A boolean indicating if any of the `TSCTableInputRow`'s in the `dataSource` with a `required` property set to YES have not yet had their input criteria satisfied
 */
@property (nonatomic, assign) BOOL isMissingRequiredInputRows;

/**
 @abstract Trigger a `UIAlertView` to inform the user that there are missing rows
 @discussion Currently this just displays a default message if there are missing rows but in the future it will list out the titles of the fields that have not been completed
 */
- (void)presentMissingRequiredInputRowsWarning;


///---------------------------------------------------------------------------------------
/// @name Managing Selections
///---------------------------------------------------------------------------------------

/**
 Pass an indexPath to this method to determine whether or not the row can be selected.
 @param indexPath The index path to check is selectable
 @discussion This method will return YES when the row responds to `rowSelectionSelector` and `rowSelectionTarget` or the section it is a part of responds to `rowSelectionTarget` and `rowSelectionSelector`
 */
- (BOOL)isIndexPathSelectable:(NSIndexPath *)indexPath;


///---------------------------------------------------------------------------------------
/// @name Overriding
///---------------------------------------------------------------------------------------

/**
 Called when the return key is pressed on the active UITextField
 @discussion Override this method in your own class to perform custom behaviour on the return key
 */
- (void)textFieldDidReturn:(UITextField *)textField;

/**
 Use this method to register a custom cell type for a particular index path.
 */
- (void)overideCellAtIndexPath:(NSIndexPath *)indexPath withClass:(Class)overideClass;

@end

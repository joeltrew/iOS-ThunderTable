//
//  TableRow.swift
//  ThunderTable
//
//  Created by Simon Mitchell on 14/09/2016.
//  Copyright © 2016 3SidedCube. All rights reserved.
//

import Foundation

// Abstract generic base class that implements Row

// Generic parameter around the associated type

private class _AnyRowBase<Cell>: Row {
	
	init() {
		guard type(of: self) != _AnyRowBase.self else {
			fatalError("_AnyRowBase<Model> instances can not be created; create a subclass instance instead")
		}
	}
	
	var cellClass: UITableViewCell.Type {
		get {
			fatalError("Must override")
		}
	}
	
	var accessoryType: UITableViewCellAccessoryType? {
		get {
			fatalError("Must override")
		}
	}
	
	var selectionStyle: UITableViewCellSelectionStyle? {
		get {
			fatalError("Must override")
		}
	}
	
	var cellStyle: UITableViewCellStyle? {
		get {
			fatalError("Must override")
		}
	}
	
	var title: String? {
		get {
			fatalError("Must override")
		}
	}
	
	var subtitle: String? {
		get {
			fatalError("Must override")
		}
	}
	
	var image: UIImage? {
		get {
			fatalError("Must override")
		}
		set {
			fatalError("Must override")
		}
	}
	
	var imageSize: CGSize? {
		get {
			fatalError("Must override")
		}
	}
	
	var imageURL: URL? {
		get {
			fatalError("Must override")
		}
	}
	
	var remainSelected: Bool {
		get {
			fatalError("Must override")
		}
	}
	
	var displaySeparators: Bool {
		get {
			fatalError("Must override")
		}
	}
	
	var isEditable: Bool {
		get {
			fatalError("Must override")
		}
	}
	
	var prototypeIdentifier: String? {
		get {
			fatalError("Must override")
		}
	}
	
	var selectionHandler: Row.SelectionHandler? {
		get {
			fatalError("Must override")
		}
	}
	
	var editHandler: Row.EditHandler? {
		get {
			fatalError("Must override")
		}
	}
	
	var estimatedHeight: CGFloat? {
		get {
			fatalError("Must override")
		}
	}
	
	var padding: CGFloat? {
		get {
			fatalError("Must override")
		}
	}
	
	var useNibSuperclass: Bool {
		get {
			fatalError("Must override")
		}
	}
	
	func configure(cell: Cell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		fatalError("Must override")
	}
	
	func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
		fatalError("Must override")
	}
}

// Box class

// final subclass of our abstract base

// Inherits the protocol conformance

// Links Concrete.Cell (associated type) to _AnyRowBase.Cell (generic parameter)

private final class _AnyRowBox<ConcreteRow: Row>: _AnyRowBase<ConcreteRow.Cell> {
	
	// variable used since we're calling mutating functions
	var concreteRow: ConcreteRow
	
	init(_ concreteRow: ConcreteRow) {
		self.concreteRow = concreteRow
	}
	
	override var cellClass: UITableViewCell.Type {
		get { return concreteRow.cellClass }
	}
	
	override var accessoryType: UITableViewCellAccessoryType? {
		get { return concreteRow.accessoryType }
	}
	
	override var selectionStyle: UITableViewCellSelectionStyle? {
		get { return concreteRow.selectionStyle }
	}
	
	override var cellStyle: UITableViewCellStyle? {
		get { return concreteRow.cellStyle }
	}
	
	override var title: String? {
		get { return concreteRow.title }
	}
	
	override var subtitle: String? {
		get { return concreteRow.subtitle }
	}
	
	override var image: UIImage? {
		get {
			return concreteRow.image
		}
		set {
			concreteRow.image = newValue
		}
	}
	
	override var imageSize: CGSize? {
		get { return concreteRow.imageSize }
	}
	
	override var imageURL: URL? {
		get { return concreteRow.imageURL }
	}
	
	override var remainSelected: Bool {
		get { return concreteRow.remainSelected }
	}
	
	override var displaySeparators: Bool {
		get { return concreteRow.displaySeparators }
	}
	
	override var isEditable: Bool {
		get { return concreteRow.isEditable }
	}
	
	override var prototypeIdentifier: String? {
		get { return concreteRow.prototypeIdentifier }
	}
	
	override var selectionHandler: Row.SelectionHandler? {
		get { return concreteRow.selectionHandler }
	}
	
	override var editHandler: Row.EditHandler? {
		get { return concreteRow.editHandler }
	}

	override var estimatedHeight: CGFloat? {
		get { return concreteRow.estimatedHeight }
	}
	
	override var padding: CGFloat? {
		get { return concreteRow.padding }
	}
	
	override var useNibSuperclass: Bool {
		get { return concreteRow.useNibSuperclass }
	}
	
	override func configure(cell: ConcreteRow.Cell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		concreteRow.configure(cell: cell, at: indexPath, in: tableViewController)
	}
	
	override func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
		return concreteRow.height(constrainedTo: size, in: tableView)
	}
}

// Public type erasing wrapper class

// Implements the Row protocol

// Generic around the associated type

public final class AnyRow<Cell>: Row {
	
	private let box: _AnyRowBase<Cell>
	
	// Initializer takes our concrete implementer of Row i.e. FileCell
	init<Concrete: Row>(_ concrete: Concrete) where Concrete.Cell == Cell {
		box = _AnyRowBox(concrete)
	}
	
	public var cellClass: UITableViewCell.Type {
		get { return box.cellClass }
	}
	
	public var accessoryType: UITableViewCellAccessoryType? {
		get { return box.accessoryType }
	}
	
	public var selectionStyle: UITableViewCellSelectionStyle? {
		get { return box.selectionStyle }
	}
	
	public var cellStyle: UITableViewCellStyle? {
		get { return box.cellStyle }
	}
	
	public var title: String? {
		get { return box.title }
	}
	
	public var subtitle: String? {
		get { return box.subtitle }
	}
	
	public var image: UIImage? {
		get {
			return box.image
		}
		set {
			box.image = newValue
		}
	}
	
	public var imageSize: CGSize? {
		get { return box.imageSize }
	}
	
	public var imageURL: URL? {
		get { return box.imageURL }
	}
	
	public var remainSelected: Bool {
		get { return box.remainSelected }
	}
	
	public var displaySeparators: Bool {
		get { return box.displaySeparators }
	}
	
	public var isEditable: Bool {
		get { return box.isEditable }
	}
	
	public var prototypeIdentifier: String? {
		get { return box.prototypeIdentifier }
	}
	
	public var selectionHandler: Row.SelectionHandler? {
		return box.selectionHandler
	}
	
	public var editHandler: Row.EditHandler? {
		return box.editHandler
	}
	
	public var estimatedHeight: CGFloat? {
		get { return box.estimatedHeight }
	}
	
	public var padding: CGFloat? {
		get { return box.padding }
	}
	
	public var useNibSuperclass: Bool {
		get { return box.useNibSuperclass }
	}
	
	public func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		box.configure(cell: cell, at: indexPath, in: tableViewController)
	}
	
	public func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
		return box.height(constrainedTo: size, in: tableView)
	}
}

/// A protocol which allows the rendering of information into a cell within
/// a `UITableView` by providing a declarative view on the information to show
public protocol Row {
	
	associatedtype Cell: UITableViewCell
	
	typealias SelectionHandler = (_ row: AnyRow<Any>, _ selected: Bool, _ indexPath: IndexPath, _ tableView: UITableView) -> (Void)
	
	typealias EditHandler = (_ row: AnyRow<Any>, _ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath, _ tableView: UITableView) -> (Void)
	
	/// The accessory type to be displayed on the right of the cell for this row
	/// - Important: If you wish to return `.none` from this, make sure to use the long syntax:
	/// `UITableViewCellAccessoryType.none` otherwise the compiler will think you are returning
	/// `Optional.none` which is equivalent to nil and therefore will be ignored by `TableViewController`
	var accessoryType: UITableViewCellAccessoryType? { get }
	
	/// The selection style to be applied when the cell for this row is pressed down
	/// - Important: If you wish to return `.none` from this, make sure to use the long syntax:
	/// `UITableViewCellSelectionStyle.none` otherwise the compiler will think you are returning
	/// `Optional.none` which is equivalent to nil and therefore will be ignored by `TableViewController`
	var selectionStyle: UITableViewCellSelectionStyle? { get }
	
	/// The cell style of the cell for this row
	///
	/// - Important: This will only take affect if you directly use TableRow, or subclass `TableViewCell` but don't use a xib based layout and return false from `useNibSuperclass`.
	var cellStyle: UITableViewCellStyle? { get }
	
    /// A string to be displayed as the title for the row
    var title: String? { get }
	
    /// A string to be displayed as the subtitle for the row
    var subtitle: String? { get }
    
    /// An image to be displayed in the row
    var image: UIImage? { get set }
    
    /// The size of the image which will be displayed in the row
	/// 
	/// This will be used when displaying an image using imageURL in order
	/// to layout the cell correctly before the image has loaded in.
    var imageSize: CGSize? { get }
    
    /// A url to load the image for the cell from
    var imageURL: URL? { get }
    
    /// Whether the cell should remain selected when pressed by the user
	///
	/// Defaults to false
    var remainSelected: Bool { get }
	
	/// Whether separators should be displayed on the cell
	///
	/// Defaults to true
	var displaySeparators: Bool { get }
	
	/// Whether the row is editable (Shows delete/actions) on cell swipe
	///
	/// Defaults to false
	var isEditable: Bool { get }
    
    /// A prototype identifier for a cell which is defined in a storyboard
	/// file, which this row will use
    var prototypeIdentifier: String? { get }
    
    /// A closure which will be called when the row is pressed on in the table view
    var selectionHandler: SelectionHandler? { get }
	
	/// A closure which will be called when the row is edited in the table view
	var editHandler: EditHandler? { get }
    
    /// The estimated height of the row
	///
	/// Defaults to nil, this is ignored by cells which are layed out
	/// using interface builder
    var estimatedHeight: CGFloat? { get }
    
    /// Padding to apply to the edges of the row
	///
	/// This is ignored by cells which are layed out
	/// using interface builder
    var padding: CGFloat? { get }
	
	/// Whether if no nib was found with the same file name as `Cell`
	/// (expected behaviour is to name your cell's xib the same file name as the 
	/// class you return from `Cell`), we should then find a xib for a
	/// superclass of `Cell`
	///
	/// Defaults to true, meaning all cells without their own xib will use
	/// a superclasses xib to layout, this will eventually come across the base
	/// cell class `TableViewCell` so if you wish to have a none Interface Builder
	/// row, then make sure to return false from this, or subclass from UITableViewCell rather than TableViewCell!
	var useNibSuperclass: Bool { get }
    
    /// A function which will be called in `cellForRow:atIndexPath` delegate 
	/// method which can be used to provide custom overrides on your cell from
	/// the row controlling it
    ///
    /// - Parameters:
    ///   - cell: The cell which needs configuring
    ///   - indexPath: The index path which that cell is at
    ///   - tableViewController: The table view controller which the cell is in
    func configure(cell: Cell, at indexPath: IndexPath, in tableViewController: TableViewController)
 
	/// A function which allows providing a manual height for a cell not layed
	/// out using Interface Builder
	///
	/// - Parameters:
	///   - size: The size which the row has available to it
	///   - tableView: The table view which the row will be displayed in
	/// - Returns: The height (or nil, to have this ignored) the row should be displayed at
	func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat?
	
	/// Returns the cell's class
	var cellClass: UITableViewCell.Type { get }
}

extension Row {

	public var cellClass: UITableViewCell.Type {
		get {
			return Cell.self
		}
	}

	public var accessoryType: UITableViewCellAccessoryType? {
		get { return nil }
	}

	public var selectionStyle: UITableViewCellSelectionStyle? {
		get { return nil }
	}

	public var displaySeparators: Bool {
		get { return true }
	}

	public var isEditable: Bool {
		get { return false }
	}

	public var cellStyle: UITableViewCellStyle? {
		get { return nil }
	}

    public var title: String? {
		get { return nil }
    }

    public var subtitle: String? {
		get { return nil }
    }

    public var image: UIImage? {
        get { return nil }
		set {}
    }

    public var imageURL: URL? {
		get { return nil }
    }

    public var imageSize: CGSize? {
        return nil
    }

    public var remainSelected: Bool {
        return false
    }

    public var prototypeIdentifier: String? {
        return nil
    }

    public var selectionHandler: SelectionHandler? {
		get { return nil }
    }

	public var editHandler: EditHandler? {
		get { return nil }
	}

	public var useNibSuperclass: Bool {
		return true
	}

    public var estimatedHeight: CGFloat? {
        return nil
    }

    public var padding: CGFloat? {
        return nil
    }

    public func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {

    }

	public func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
		return nil
	}
}

/// A base class which can be subclassed providing a template for the `Row` protocol
open class TableRow: Row {
	
	public var cellClass: TableViewCell.Type {
		return TableViewCell.self
	}
	
	public typealias Cell = TableViewCell
	
//	public var cellClass: UITableViewCell.Type
	
	open var cellStyle: UITableViewCellStyle?
	
	open var displaySeparators: Bool = true
	
	public var isEditable: Bool = false
	
	public var editHandler: EditHandler?
    
    open var title: String?
	
	open var titleTextColor: UIColor = ThemeManager.shared.theme.cellTitleColor
	
	open var subtitleTextColor: UIColor = ThemeManager.shared.theme.cellDetailColor
    
    open var subtitle: String?
    
    open var image: UIImage?
    
    open var imageSize: CGSize?
    
    open var imageURL: URL? {
        didSet {
            image = nil
        }
    }
    
    open var prototypeIdentifier: String? {
        return nil
    }
    
    open var selectionHandler: SelectionHandler?
	
	open var selectionStyle: UITableViewCellSelectionStyle?
	
	open var accessoryType: UITableViewCellAccessoryType?
    
    open var estimatedHeight: CGFloat? {
        return nil
    }
    
    open var padding: CGFloat? {
        return nil
    }
    
    open var remainSelected: Bool {
        return false
    }
	
	open var useNibSuperclass: Bool {
		return true
	}
	
	public func configure(cell: TableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
		
		if let imageView = cell.cellImageView {
			
			if image == nil && imageURL == nil {
				imageView.isHidden = true
			} else {
				imageView.isHidden = false
			}
		}
		
		cell.cellTextLabel?.textColor = titleTextColor
		cell.cellDetailLabel?.textColor = subtitleTextColor
	}
	
	public func height(constrainedTo size: CGSize, in tableView: UITableView) -> CGFloat? {
		return nil
	}
    
    public init(title: String?, subtitle: String? = nil, image: UIImage? = nil, selectionHandler: SelectionHandler? = nil) {
        
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.selectionHandler = selectionHandler
    }
}

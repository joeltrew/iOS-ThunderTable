//
//  TableViewController.swift
//  ThunderTable
//
//  Created by Simon Mitchell on 14/09/2016.
//  Copyright © 2016 3SidedCube. All rights reserved.
//

import UIKit

extension UILabel {
	
	var paragraphStyle: NSParagraphStyle? {
		set {
			
			if let _text = text, let style = newValue?.mutableCopy() as? NSMutableParagraphStyle {
				
				var attributes = [String : Any]()
				style.alignment = textAlignment
				
				if let _font = font {
					attributes[NSFontAttributeName] = _font
				}
				
				if let _textColor = textColor {
					attributes[NSForegroundColorAttributeName] = _textColor
				}
				
				attributes[NSParagraphStyleAttributeName] = paragraphStyle
				
				let attributedString = NSAttributedString(string: _text, attributes: attributes)
				attributedText = attributedString
			}
		}
		get {
			return NSParagraphStyle()
		}
	}
}

extension UITableViewCellAccessoryType {
	
    var rightInset: CGFloat {
        switch self {
        case .none:
            return 0
        case .disclosureIndicator, .detailButton, .detailDisclosureButton, .checkmark:
            return 4
        }
    }
}

extension Row {
    
    /// Returns a nib for the row's cell class if one exists in the bundle for the class
    var nib: UINib? {
        
        get {
            
            guard var cellClass = cellClass else { return nil }
            
            var classString = String(describing: cellClass)
            guard var nibName = classString.components(separatedBy: ".").last else { return nil }
						
            var bundle = Bundle(for: cellClass)
			var nibPath = bundle.path(forResource: nibName, ofType: "nib")
			
			// Only look for nib superclasses if we're told to by Row protocol
			if useNibSuperclass {
				
				// Sometimes a cell may have subclassed without providing it's own nib file
				// In this case always use it's superclass!
				while nibPath == nil, let superClass = cellClass.superclass(){
					
					// Make sure we're still looking in the correct bundle
					bundle = Bundle(for: superClass)
					// Find the new class name
					classString = String(describing: superClass)
					// Get the new nib name for the classes superClass
					if let superNibName = classString.components(separatedBy: ".").last, let _path = bundle.path(forResource: superNibName, ofType: "nib") {
						// Update nibPath and nibName
						nibPath = _path
						nibName = superNibName
					}
					cellClass = superClass
				}
			}
			
            guard let _ = nibPath else { return nil }
            let nib = UINib(nibName: nibName, bundle: bundle)
            return nib
        }
    }
    
    var identifier: String? {
        
        if let prototypeIdentifier = prototypeIdentifier {
            return prototypeIdentifier
        } else if let cellClass = cellClass {
            return String(describing: cellClass)
        }
        
        return nil
    }
}

@objc(TSCTableViewController)
open class TableViewController: UITableViewController {
    
    open var data: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }
	
	public var selectedIndexPath: IndexPath?
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        let defaultNib = UINib(nibName: "TableViewCell", bundle: Bundle(for: TableViewController.self))
        tableView.register(defaultNib, forCellReuseIdentifier: "Cell")
    }
    
    public var inputDictionary: [String: Any?]? {
        
        guard let inputRows = data.flatMap({ $0.rows.filter({ $0 as? InputRow != nil }) }) as? [InputRow] else { return nil }
        
        var dictionary: [String: Any?] = [:]
        
        inputRows.forEach { (row) in
            dictionary[row.id] = row.value
        }
        
        return dictionary
    }
	
	public var missingRequiredInputRows: [InputRow]? {
		
		guard let inputRows = data.flatMap({ $0.rows.filter({ $0 as? InputRow != nil }) }) as? [InputRow] else { return nil }
		
		return inputRows.filter({ (inputRow) -> Bool in
			return inputRow.required && inputRow.value == nil
		})
	}
	
    private var registeredClasses: [String] = []

    // MARK: - Helper functions!
    
    open func configure(cell: UITableViewCell, with row: Row, at indexPath: IndexPath) {
        
        var _row = row
        var textLabel = cell.textLabel
        var detailLabel = cell.detailTextLabel
        var imageView = cell.imageView
        
        if let tscTableCell = cell as? TableViewCell {
            
            textLabel = tscTableCell.cellTextLabel
            detailLabel = tscTableCell.cellDetailLabel
            imageView = tscTableCell.cellImageView
			
			tscTableCell.shouldDisplaySeparators = row.displaySeparators
			tscTableCell.cellStyle = row.cellStyle ?? .subtitle
        }
		
		// Whether to display cell separators
		if _row.displaySeparators {
			cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.separatorInset.left, bottom: 0, right: 0)
		} else {
			cell.separatorInset = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
			cell.layoutMargins = UIEdgeInsets(top: 0, left: CGFloat.greatestFiniteMagnitude, bottom: 0, right: 0)
		}
		
		
		// The second else if must be here, as .none equates to nil in an if let
		if let selectionStyle = row.selectionStyle {
			cell.selectionStyle = selectionStyle
		} else if row.selectionStyle == .none {
			cell.selectionStyle = .none
		} else {
			cell.selectionStyle = selectable(indexPath) ? .default : .none
		}
		
		// The second else if must be here, as .none equates to nil in an if let
		if let accessoryType = row.accessoryType {
			cell.accessoryType = accessoryType
		} else if row.accessoryType == .none {
			cell.accessoryType = .none
		} else {
			cell.accessoryType = selectable(indexPath) ? .disclosureIndicator : .none
		}
		
        if let rowTitle = row.title {
            textLabel?.text = rowTitle
        } else {
            textLabel?.text = nil
        }
        
        if let rowSubtitle = row.subtitle {
            detailLabel?.text = rowSubtitle
        } else {
            detailLabel?.text = nil
        }
        
        if let rowImage = row.image {
            imageView?.image = rowImage
        } else {
            imageView?.image = nil
        }
        
        var size = CGSize.zero
        if let imageSize = row.imageSize {
            size = imageSize
        }
        
        imageView?.set(imageURL: row.imageURL, withPlaceholder: row.image, imageSize: size, animated: true, completion: { [weak self] (image, error) -> (Void) in
            
            if let welf = self, _row.image == nil {
                _row.image = image
                welf.tableView.reloadRows(at: [indexPath], with: .none)
            }
        })
		
		textLabel?.paragraphStyle = ThemeManager.shared.theme.cellTitleParagraphStyle
		detailLabel?.paragraphStyle = ThemeManager.shared.theme.cellDetailParagraphStyle
		
        row.configure(cell: cell, at: indexPath, in: self)
    }
    
    private func register(row: Row) {
        
        guard let identifier = row.identifier else { return }
        
        if let nib = row.nib {
            tableView.register(nib, forCellReuseIdentifier: identifier)
        } else if let cellClass = row.cellClass {
            tableView.register(cellClass, forCellReuseIdentifier: identifier)
        }
    }
    
    // MARK: - TableView data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        
        return data.count
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section - 1 > data.count { return 0 }
        
        let section = data[section]
        return section.rows.count
    }

    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = data[indexPath.section].rows[indexPath.row]
        
        var identifier: String = "Cell"
        
        // If the row defines a cell class use the identifier for that
        if let rowIdentifier: String = row.identifier {
            identifier = rowIdentifier
        }
        
        // If we don't have a prototype identifier (Prototype cells are automatically registered by the OS
        if row.prototypeIdentifier == nil {
            
            // Make sure it's registered before de-queueing it
            if !registeredClasses.contains(where: {identifier == $0}) {
                register(row: row)
            }
        }
        
        if identifier == "Cell" {
            print("You didn't provide a cellClass or prototypeIdentifier for \(row), falling back to our default cell class")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        configure(cell: cell, with: row, at: indexPath)
        
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = data[indexPath.section].rows[indexPath.row]
        
        if let estimatedHeight = row.estimatedHeight {
            return estimatedHeight
        } else {
            return self.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    var dynamicHeightCells: [String: UITableViewCell] = [:]
    
    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = data[indexPath.section].rows[indexPath.row]
        
        // If they're using prototype cells or nibs then we don't want to manually calculate size
        let calculateSize = row.prototypeIdentifier == nil && row.nib == nil
        
        if !calculateSize {
            return UITableViewAutomaticDimension
        }
		
		if let height = row.height(constrainedTo: CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude), in: tableView) {
			return height
		}
        
        // Let's calculate this mothertrucker!
        
        var identifier: String = "Cell"
        // If the row defines a cell class use the identifier for that
        if let rowIdentifier: String = row.identifier {
            identifier = rowIdentifier
        }
        
        var cell = dynamicHeightCells[identifier]
        if cell == nil {
            
            if let aClass = row.cellClass as? UITableViewCell.Type {
                cell = aClass.init(style: .default, reuseIdentifier: identifier)
            }
        }
        
        guard let _cell = cell else { return UITableViewAutomaticDimension }

        configure(cell: _cell, with: row, at: indexPath)
        
        _cell.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width - max(2.0, UIScreen.main.scale) * _cell.accessoryType.rightInset, height: 44)
        
        _cell.layoutSubviews()
        
        var totalHeight: CGFloat = 0;
        let subviews = _cell.contentView.subviews
        var lowestYValue: CGFloat = 0;
        
        subviews.forEach { (view) in
            
            if view.frame.height == 0 { return }
            
            let maxY = view.frame.maxY
            if maxY > totalHeight {
                totalHeight = maxY
            }
            
            let minY = view.frame.minY
            if minY < lowestYValue {
                lowestYValue = minY
            }
        }
        
        var cellHeight = totalHeight + fabs(lowestYValue) + 8
        
        if let padding = row.padding {
            cellHeight = cellHeight - 8 + padding
        }
        
        cellHeight = ceil(cellHeight);
        return cellHeight;
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
	
	open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		let section = data[section]
		return section.header
	}
	
	open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		
		let section = data[section]
		return section.footer
	}

    //MARK - Table View Delegate
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectable(indexPath) {
            set(indexPath: indexPath, selected: true)
        }
    }
    
    open override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectable(indexPath) {
            set(indexPath: indexPath, selected: false)
        }
    }
}


//MARK - Selection
public extension TableViewController {
    
    internal func selectable(_ indexPath: IndexPath) -> Bool {
        
        let section = data[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.selectionHandler != nil || section.selectionHandler != nil || (row as? InputRow) != nil || !row.remainSelected
    }
    
    internal func set(indexPath: IndexPath, selected: Bool) {
        
        let section = data[indexPath.section]
        let row = section.rows[indexPath.row]
        
        // Row selection overrides section selection
        if let rowSelectionHandler = row.selectionHandler {
            rowSelectionHandler(row, selected, indexPath, tableView)
        } else if let sectionSelectionHandler = section.selectionHandler {
            sectionSelectionHandler(row, selected, indexPath, tableView)
        }
		
		if selected {
		}
		
        // Deselect it if remain selected is false
        if selected && !row.remainSelected {
            tableView.deselectRow(at: indexPath, animated: true)
		} else if selected && row.remainSelected {
			selectedIndexPath = indexPath
		}
			
        if let _ = row as? InputRow, selected {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.becomeFirstResponder()
        }
    }
    
    public func moveToInputCell(after indexPath: IndexPath) {
        
        outerLoop: for (sectionIndex, section) in data.enumerated() {
            
            if sectionIndex >= indexPath.section {
                
                for (rowIndex, row) in section.rows.enumerated() {
                    
                    if let _ = row as? InputRow, rowIndex > indexPath.row {
                        
                        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        set(indexPath: indexPath, selected: true)
                        
                        break outerLoop
                    }
                }
            }
        }
    }
}

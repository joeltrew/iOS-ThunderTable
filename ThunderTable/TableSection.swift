//
//  TableSection.swift
//  ThunderTable
//
//  Created by Simon Mitchell on 14/09/2016.
//  Copyright © 2016 3SidedCube. All rights reserved.
//

import Foundation

public typealias SelectionHandler = (_ row: AnyRow, _ selected: Bool, _ indexPath: IndexPath, _ tableView: UITableView) -> (Void)

public typealias EditHandler = (_ row: AnyRow, _ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath, _ tableView: UITableView) -> (Void)

public protocol Section {
    
    var rows: [AnyRow] { get set }
    
    var header: String? { get set }
    
    var footer: String? { get set }
	
	var editHandler: EditHandler? { get set }
    
    var selectionHandler: SelectionHandler? { get set }
}

public extension Section {
	
	var rows: [AnyRow] {
		get {
			return []
		}
		set {}
	}
	
    var header: String? {
		get {
			return nil
		}
		set {}
    }
    
    var footer: String? {
		get {
			return nil
		}
		set {}
    }
	
	var editHandler: EditHandler? {
		get {
			return nil
		}
		set {}
	}
    
    var selectionHandler: SelectionHandler? {
		get {
			return nil
		}
		set {}
    }
}

open class TableSection: Section {
    
    open var header: String?
    
    open var footer: String?
    
    open var rows: [AnyRow]
    
    open var selectionHandler: SelectionHandler?
	
	open var editHandler: EditHandler?
    
    public init(rows: [AnyRow], header: String? = nil, footer: String? = nil, selectionHandler: SelectionHandler? = nil) {
        
        self.rows = rows
        self.header = header
        self.footer = footer
        self.selectionHandler = selectionHandler
    }
	
	/// Returns an array of `TableSection` objects sorted by first letter of the row's title
	///
	/// - Parameters:
	///   - rows: The rows to sort into alphabetised sections
	///   - selectionHandler: A selection handler to add to the sections
	/// - Returns: An array of `TableSection` objects
	public class func sortedSections(with rows: [AnyRow], selectionHandler: SelectionHandler? = nil) -> [TableSection] {
		
		let sortedAlphabetically = self.alphabeticallySort(rows: rows)
		let sortedKeys = sortedAlphabetically.keys.sorted { (stringA, stringB) -> Bool in
			return stringB > stringA
		}
			
		return sortedKeys.flatMap({key -> TableSection? in
			guard let rows = sortedAlphabetically[key] else { return nil }
			return TableSection(rows: rows, header: key, footer: nil, selectionHandler: selectionHandler)
		})
	}
	
	private class func alphabeticallySort(rows: [AnyRow]) -> [String : [AnyRow]] {
		
		var sortedDict = [String : [AnyRow]]()
		
		rows.forEach { (row) in
			
			var firstLetter = "?"
			if let rowTitle = row.title, !rowTitle.isEmpty {
				firstLetter = String(rowTitle.prefix(1)).uppercased()
			}
			var subItems = sortedDict[firstLetter] ?? []
			subItems.append(row)
			sortedDict[firstLetter] = subItems
		}
		
		return sortedDict
	}
}

//
//  Extensions.swift
//  ThunderTable
//
//  Created by Simon Mitchell on 02/08/2017.
//  Copyright © 2017 3SidedCube. All rights reserved.
//

import UIKit

extension Array : Section {
    
    public var rows: [Row] {
        return filter({ (item) -> Bool in
            return item is Row
        }) as? [Row] ?? []
    }
    
    public var editHandler: EditHandler? {
        return nil
    }
}

extension String: PickerRowDisplayable {
    
    public var rowTitle: String {
        return self
    }
    
    public var value: AnyHashable {
        return self
    }
}

extension Int: PickerRowDisplayable {
    
    public var rowTitle: String {
        return "\(self)"
    }
    
    public var value: AnyHashable {
        return self
    }
}

extension Double: PickerRowDisplayable {
    
    public var rowTitle: String {
        return "\(self)"
    }
    
    public var value: AnyHashable {
        return self
    }
}

extension String: Row {
    
    public var title: String? {
        return self
    }
}

extension UIImage: Row {
    
    public var image: UIImage? {
        get {
            return self
        }
        set { }
    }
    
    public var accessoryType: UITableViewCell.AccessoryType? {
        return UITableViewCell.AccessoryType.none
    }
    
    public var cellClass: UITableViewCell.Type? {
        return TableImageViewCell.self
    }
    
    public func configure(cell: UITableViewCell, at indexPath: IndexPath, in tableViewController: TableViewController) {
        
        guard let imageViewCell = cell as? TableImageViewCell else { return }
        
        let aspectRatio = size.height/size.width
        
        imageViewCell.imageHeightConstraint.constant = aspectRatio * tableViewController.tableView.bounds.width
    }
}

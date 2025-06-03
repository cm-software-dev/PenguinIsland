//
//  Array2D.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

struct Array2D<T> {
    let columns: Int
    let rows: Int
    var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
    
    mutating func addAtIndex(_ index: Int, item: T) {
        guard index < array.count else {return}
        array[index] = item
    }
    
}

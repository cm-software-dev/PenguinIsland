//
//  Tile.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

import Foundation
import SpriteKit

class Tile {
    
    var flagged: Bool
    let mine: Bool
    var adjacentMines: Int
    var broken: Bool = false
    
    let column: Int
    let row: Int
    
    var sprite: SKSpriteNode?
    
    var visible = false
    
    init(mine: Bool, adjacentMines: Int, column: Int, row: Int) {
        self.mine = mine
        self.adjacentMines = adjacentMines
        self.row = row
        self.column = column
        self.flagged = false
    }
}

//
//  Helpers.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 26/05/2025.
//

struct Helpers {
    
    static func getAdjacentTileCoords(column: Int, row: Int, maxColumns: Int, maxRows: Int) -> [(Int,Int)] {
        var adjacentTileCoords: [(Int, Int)] = []
        if row+1 < maxRows {
            adjacentTileCoords.append((row+1,column))
            
            if column-1 >= 0 {
                adjacentTileCoords.append((row+1,column-1))
            }
            if column+1 < maxColumns {
                adjacentTileCoords.append((row+1,column+1))
            }
        }
        
        if row-1 >= 0 {
            adjacentTileCoords.append((row-1,column))
        }
        
        
        /*[
             (row,column-1),
            (row-1,column-1),
            (row-1,column+1),(row,column+1)] */
        return adjacentTileCoords
    }
}

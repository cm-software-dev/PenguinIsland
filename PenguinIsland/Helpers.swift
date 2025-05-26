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
            adjacentTileCoords.append((column, row+1))
            
            if column-1 >= 0 {
                adjacentTileCoords.append((column-1, row+1))
            }
            if column+1 < maxColumns {
                adjacentTileCoords.append((column+1,row+1))
            }
        }
        
        if row-1 >= 0 {
            adjacentTileCoords.append((column, row-1))
            
            if column-1 >= 0 {
                adjacentTileCoords.append((column-1, row-1))
            }
            if column+1 < maxColumns {
                adjacentTileCoords.append((column+1, row-1))
            }
        }
        
        if column-1 >= 0 {
            adjacentTileCoords.append((column-1, row))
        }
        
        if column+1 < maxColumns {
            adjacentTileCoords.append((column+1, row))
        }
  
        return adjacentTileCoords
    }
}

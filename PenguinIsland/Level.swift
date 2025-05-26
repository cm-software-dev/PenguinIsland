//
//  Level.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

class Level {
    let numColumns: Int
    let numRows: Int
    private let mines: Int
    
    private var tiles: Array2D<Tile>
    
    init(numColumns: Int, numRows: Int, mines: Int) {
        self.numColumns = numColumns
        self.numRows = numRows
        self.mines = mines
        tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
    }
    
    func tileAt(column: Int, row: Int) -> Tile? {
      precondition(column >= 0 && column < numColumns)
      precondition(row >= 0 && row < numRows)
      return tiles[column, row]
    }
    
    func layMines() ->  Array2D<Tile> {
        var mineIndices = Set<Int>()
        while mineIndices.count < mines {
            mineIndices.insert(Int.random(in: 0..<numRows*numColumns))
        }
        print ("mine indices")
        print(mineIndices)
        for row in 0..<numRows {
            for column in 0..<numColumns {
                let index = row * numColumns + column
                if mineIndices.contains(index) {
                    tiles.addAtIndex(index, item: Tile(mine:true, adjacentMines: 0, column: column, row: row))
                    setAdjacentMinesFor(row: row, column: column)
                }
                else if tiles[column, row] == nil {
                    tiles[column, row] = Tile(mine: false, adjacentMines: 0, column: column, row: row)
                }
            }
        }
        return tiles
    }
    
    private func setAdjacentMinesFor(row: Int, column: Int) {
        let adjacentTileCoords = Helpers.getAdjacentTileCoords(row: row, column: column)
        
        adjacentTileCoords.forEach {
            if ($0.0 >= 0 && $0.0 < numRows && $0.1 >= 0 && $0.1 < numColumns) {
                if tiles[$0.1,$0.0] == nil {
                    tiles[$0.1,$0.0] = Tile(mine: false, adjacentMines: 1, column: $0.1, row: $0.0)
                }
                else {
                    tiles[$0.1,$0.0]?.adjacentMines+=1
                }
            }
        }
    }
}

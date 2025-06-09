//
//  Level.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

class Level {
    let numColumns: Int
    let numRows: Int
    let mines: Int
    
    private var tiles: Array2D<Tile>
    
    var visibleTiles: Int  {
        var total = 0
        tiles.array.forEach({tile in
            if let tile = tile, tile.visible {
                total += 1
            }
        })
        return total
    }
    
    var gameOver: Bool = false
    var victory: Bool = false
    
    var correctFlags: Int = 0
    
    convenience init(_ settings: DifficultySettings) {
        self.init(numColumns: settings.numColumns, numRows: settings.numRows, mines: settings.numMines)
    }
    
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
    
    func layMines(_ safeIndex: Int? = nil) ->  Array2D<Tile> {
        gameOver = false
        tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
        var mineIndices = Set<Int>()
        while mineIndices.count < mines {
            if let safeIndex = safeIndex {
                let newIndex = Int.random(in: 0..<numRows*numColumns)
                if newIndex == safeIndex {
                    continue
                }
                else {
                    mineIndices.insert(newIndex)
                }
            }
            else {
                mineIndices.insert(Int.random(in: 0..<numRows*numColumns))
            }
        }

        for row in 0..<numRows {
            for column in 0..<numColumns {
                let index = row * numColumns + column
                if mineIndices.contains(index) {
                    tiles.addAtIndex(index, item: Tile(mine:true, adjacentMines: 0, column: column, row: row))
                    setAdjacentMinesFor(column: column, row: row)
                }
                else if tiles[column, row] == nil {
                    tiles[column, row] = Tile(mine: false, adjacentMines: 0, column: column, row: row)
                }
            }
        }
        return tiles
    }
    
    func getAllTiles() -> [Tile] {
        return tiles.array.compactMap{$0}
    }
    
    private func setAdjacentMinesFor( column: Int, row: Int) {
        let adjacentTileCoords = Helpers.getAdjacentTileCoords(column: column, row: row, maxColumns: numColumns, maxRows: numRows)
        
        adjacentTileCoords.forEach {
            if ($0.0 >= 0 && $0.0 < numColumns && $0.1 >= 0 && $0.1 < numRows) {
                if tiles[$0.0,$0.1] == nil {
                    tiles[$0.0,$0.1] = Tile(mine: false, adjacentMines: 1, column: $0.0, row: $0.1)
                }
                else {
                    tiles[$0.0,$0.1]?.adjacentMines+=1
                }
            }
        }
    }
}

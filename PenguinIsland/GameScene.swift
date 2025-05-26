//
//  GameScene.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level: Level!
    
    let tileWidth: CGFloat = 32.0
    let tileHeight: CGFloat = 36.0
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    
    var numRows: Int = 16
    var numColumns: Int = 9
    
    var tappedColumn: Int?
    var tappedRow: Int?
    
    var visibleTiles: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize, numRows: Int, numColumns: Int) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "Background")
        background.size = size
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(numColumns) / 2,
            y: -tileHeight * CGFloat(numRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
    }
    
    func addSprites(for tiles: Array2D<Tile>) {
        
        for tile in tiles.array {
            //print("Mine:\(tile?.mine)  column: \(tile?.column)  row: \(tile?.row) adjacent: \(tile?.adjacentMines)")
            guard let tile = tile else {
                continue
            }
            let sprite = SKSpriteNode(color:determineSpriteColour(tile: tile), size: CGSize(width: tileWidth, height: tileHeight))
            sprite.position = pointFor(column: tile.column, row: tile.row)
            tilesLayer.addChild(sprite)
            tile.sprite = sprite
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: tilesLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            // 3
            if let tile = level.tileAt(column: column, row: row) {
                // 4
                tappedColumn = column
                tappedRow = row
                tileSpriteTapped(tile: tile)
            }
        }
    }
    
    private func tileSpriteTapped(tile:Tile) {
        if tile.visible {
            return
        }
        tile.visible = true
        let sprite = tile.sprite
        sprite?.color = determineSpriteColour(tile: tile)
        visibleTiles+=1
        if tile.adjacentMines == 0 {
            updateTilesForTileWithNoAdjacentMines(tile: tile)
        }
        
    }
    
    private func updateTilesForTileWithNoAdjacentMines(tile: Tile) {
        let adjacentTileCoords = Helpers.getAdjacentTileCoords(row: tile.row, column: tile.column)
        adjacentTileCoords.forEach {
            coord in
            if let tile = level.tileAt(column: coord.0, row: coord.1), !tile.visible {
                tileSpriteTapped(tile: tile)
            }
        }
    }
    
    private func determineSpriteColour(tile: Tile) -> UIColor {
        if !tile.visible {
            return .gray
        }
        if tile.mine {
            return .black
        }
        switch tile.adjacentMines {
        case 0:
            return .lightGray
        case 1:
            return .blue
        case 2:
            return .green
        case 3:
            return .red
        case 4:
            return .purple
        case 5:
            return .brown
        case 6:
            return .darkGray
        default:
            return .gray
        }
    }
    
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth &&
            point.y >= 0 && point.y < CGFloat(numRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
}

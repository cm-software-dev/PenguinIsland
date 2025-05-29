//
//  GameScene.swift
//  PenguinIsland
//
//  Created by Calum Maclellan on 25/05/2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var level: Level! {
        didSet {
            numRows = level.numRows
            numColumns = level.numColumns
        }
    }
    
    let tileWidth: CGFloat = 32.0
    let tileHeight: CGFloat = 32.0
    
    let gameLayer = SKNode()
    let tilesLayer = SKNode()
    
    var numRows: Int = 16
    var numColumns: Int = 9
    
    var tappedColumn: Int?
    var tappedRow: Int?
    
    let plantingFlagAlpha: CGFloat = 0.8
    
    var plantingFlag: Bool = false {
        didSet {
            if plantingFlag {
                setTileSpritesInFlagSettingMode()
                
            }
            else {
                setTileSpritesNormal()
            }
        }
    }
    
    var tapHandler: ((Tile) -> ())?
    var flagPlantedHandler: ((Tile) -> ())?
    
    var firstTap = true
    
    var layMines: ((Int) -> ())?
    
    private var selectedTile: Tile?
    private var selectedTileInitialSprite: SKSpriteNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "main-background")
        background.size = size
        addChild(background)
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(numColumns) / 2,
            y: -tileHeight * CGFloat(numRows) / 2)
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
    }
    
    
    func setTileSpritesInFlagSettingMode() {
        level.getAllTiles().forEach {
            tile in
            if !tile.flagged {
                tile.sprite?.alpha = plantingFlagAlpha
            }
        }
    }
    
    func setTileSpritesNormal() {
        level.getAllTiles().forEach { $0.sprite?.alpha = 1}
    }
    
    func setBlankTileSprites() {
        tilesLayer.removeAllChildren()
        for row in 0..<level.numRows {
            for column in 0..<numColumns {
                let sprite = SKSpriteNode(imageNamed: SpriteTileName.baseTile.rawValue)
                sprite.position = pointFor(column: column, row: row)
                tilesLayer.addChild(sprite)
            }
        }
    }
    
    func addSprites(for tiles: Array2D<Tile>) {
        tilesLayer.removeAllChildren()
        plantingFlag = false
        
        for tile in tiles.array {
            guard let tile = tile else {
                continue
            }
            let sprite = SKSpriteNode(imageNamed: SpriteTileName.baseTile.rawValue)
            sprite.position = pointFor(column: tile.column, row: tile.row)
            tilesLayer.addChild(sprite)
            tile.sprite = sprite
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: tilesLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            if let tile = level.tileAt(column: column, row: row) {
                tileSpriteTapped(tile: tile)
            }
            else if let previousTile = selectedTile, let previousSprite = selectedTileInitialSprite {
                replaceSpriteInTile(tile: previousTile, newSprite: previousSprite)
            }
        }
        
        selectedTile = nil
        selectedTileInitialSprite = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: tilesLayer)
        
        let (success, column, row) = convertPoint(location)
        
        if success {
            if firstTap && !plantingFlag {
                firstTap = false
                layMines?(row*numColumns + column)
            }
            if !plantingFlag {
                if let tile = level.tileAt(column: column, row: row), !tile.visible {
                    let sprite = SKSpriteNode(imageNamed: SpriteTileName.baseTileTapped.rawValue )
                    selectedTile = tile
                    selectedTileInitialSprite = tile.sprite
                    replaceSpriteInTile(tile: tile, newSprite: sprite)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: tilesLayer)
        let (success, column, row) = convertPoint(location)
        
        
        if success, let previousTile = selectedTile, let previousSprite = selectedTileInitialSprite, column != previousTile.column || row != previousTile.row {
            
    
            selectedTile?.sprite = previousSprite
            replaceSpriteInTile(tile: selectedTile!, newSprite: SKSpriteNode(imageNamed: SpriteTileName.baseTile.rawValue ))
            
            if let nextTile = level.tileAt(column: column, row: row), !nextTile.visible {
                selectedTile = nextTile
                selectedTileInitialSprite = selectedTile?.sprite
                replaceSpriteInTile(tile: selectedTile!, newSprite: SKSpriteNode(imageNamed: SpriteTileName.baseTileTapped.rawValue ))
            }
        }
        
    }
    
    func gameOver() {
        showAllMines()
    }
    
    func showAllMines() {
        level.getAllTiles().forEach({
            tile in
            if tile.mine && !tile.broken && !tile.flagged {
                replaceSpriteInTile(tile: tile, newSprite: SKSpriteNode(imageNamed: SpriteTileName.fineEgg.rawValue))
            }
        })
    }
    
    private func tileSpriteTapped(tile:Tile) {
        if tile.visible {
            return
        }
        
        if plantingFlag {
            setFlagForTile(tile: tile)
            return
        }
        
        if tile.flagged {
            return
        }
        tile.visible = true
        let newSprite = determineSprite(tile: tile)
        replaceSpriteInTile(tile: tile, newSprite: newSprite)
        
        
        if tile.adjacentMines == 0 && !tile.mine {
            updateTilesForTileWithNoAdjacentMines(tile: tile)
        }
        tapHandler?(tile)
    }
    
    private func replaceSpriteInTile(tile: Tile, newSprite: SKSpriteNode) {
        newSprite.position = pointFor(column: tile.column, row: tile.row)
        if let oldSprite = tile.sprite {
            tilesLayer.removeChildren(in: [oldSprite])
        }
        tile.sprite = newSprite
        tilesLayer.addChild(newSprite)
    }
    
    private func setFlagForTile(tile: Tile) {
        tile.flagged.toggle()
        if tile.flagged {
            let newSprite = SKSpriteNode(imageNamed: SpriteTileName.flagTile.rawValue)
            replaceSpriteInTile(tile: tile, newSprite: newSprite)
        }
        else {
            let newSprite = determineSprite(tile: tile)
            replaceSpriteInTile(tile: tile, newSprite: newSprite)
        }
        flagPlantedHandler?(tile)
    }
    
    private func updateTilesForTileWithNoAdjacentMines(tile: Tile) {
        let adjacentTileCoords = Helpers.getAdjacentTileCoords(column: tile.column, row: tile.row, maxColumns: numColumns, maxRows: numRows)
        adjacentTileCoords.forEach {
            coord in
            if let tile = level.tileAt(column: coord.0, row: coord.1), !tile.visible, !tile.flagged {
                tileSpriteTapped(tile: tile)
            }
        }
    }
    
    private func determineSprite(tile: Tile) -> SKSpriteNode {
        if !tile.visible {
            return SKSpriteNode(imageNamed: SpriteTileName.baseTile.rawValue)

        }
        if tile.mine {
            return SKSpriteNode(imageNamed: SpriteTileName.brokenEgg.rawValue)
        }
        switch tile.adjacentMines {
        case 0:
            return SKSpriteNode(imageNamed: SpriteTileName.emptyTile.rawValue)
        case 1:
            return SKSpriteNode(imageNamed: SpriteTileName.oneTile.rawValue)
        case 2:
            return SKSpriteNode(imageNamed: SpriteTileName.twoTile.rawValue)
        case 3:
            return SKSpriteNode(imageNamed: SpriteTileName.threeFile.rawValue)
        case 4:
            return SKSpriteNode(imageNamed: SpriteTileName.fourTile.rawValue)
        case 5:
            return SKSpriteNode(imageNamed: SpriteTileName.fiveTile.rawValue)
        case 6:
            return SKSpriteNode(imageNamed: SpriteTileName.sixTile.rawValue)
        case 7:
            return SKSpriteNode(imageNamed: SpriteTileName.sevenTile.rawValue)
        case 8:
            return SKSpriteNode(imageNamed: SpriteTileName.eightTile.rawValue)
        default:
            return SKSpriteNode(imageNamed: SpriteTileName.baseTile.rawValue)
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


enum SpriteTileName: String {
    case baseTile = "BaseTile"
    case emptyTile = "EmptyTile"
    case flagTile = "YellowFlagTile"
    case oneTile = "OneTile"
    case twoTile = "TwoTile"
    case threeFile = "ThreeTile"
    case fourTile = "FourTile"
    case fiveTile = "FiveTile"
    case sixTile = "SixTile"
    case sevenTile = "SevenTile"
    case eightTile = "EightTile"
    case baseTileTapped = "BaseTileTapped"
    case brokenEgg = "BrokenEggBlack"
    case fineEgg = "FineEgg"
}

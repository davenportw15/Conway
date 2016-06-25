//
//  GameScene.swift
//  Conway
//
//  Created by William Davenport on 6/24/16.
//  Copyright (c) 2016 William Davenport. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let x: Int = 30
    let y: Int = 30
    let delay: Double = 0.25
    
    var cells: [[SKShapeNode]] = []
    var state: State!
    
    override func didMoveToView(view: SKView) {
        let filledPoints = [
            (13, 11),
            (14, 12),
            (12, 12),
            (12, 13),
            (14, 13),
            (13, 13),
            (13, 14)
        ]
        self.state = State(x: self.x, y: self.y, withFilledPoints: filledPoints)
        populateNodes()
        
        let updateConway = SKAction.sequence([
            SKAction.runBlock { self.drawConway() },
            SKAction.waitForDuration(self.delay),
            SKAction.runBlock { self.state = self.state.next() }
        ])
        self.runAction(SKAction.repeatActionForever(updateConway))
    }
    
    private func populateNodes() {
        let cellWidth  = self.frame.width / CGFloat(self.x)
        let cellHeight = self.frame.height / CGFloat(self.y)
        
        for y in 0 ..< self.y {
            self.cells.append([])
            for x in 0 ..< self.x {
                let rectangle = CGRect(
                    x: CGFloat(x) * cellWidth,
                    y: CGFloat(y) * cellHeight,
                    width: cellWidth,
                    height: cellHeight
                )
                let node = SKShapeNode(rect: rectangle)
                node.fillColor = SKColor.whiteColor()
                self.cells[y].append(node)
                self.addChild(node)
            }
        }
    }
    
    private func drawConway() {
        for y in 0 ..< self.y {
            for x in 0 ..< self.x {
                let cell = self.state[x, y]
                let color = cell == State.Cell.Filled ? SKColor.blueColor() : SKColor.whiteColor()
                
                let node = self.cells[y][x]
                node.fillColor = color
            }
        }
    }
}

//
//  State.swift
//  Conway
//
//  Created by William Davenport on 6/24/16.
//  Copyright © 2016 William Davenport. All rights reserved.
//

import Foundation

class State {
    
    enum Cell {
        case Filled
        case Empty
    }
    
    let cells: [[Cell]]
    let x: Int
    let y: Int
    
    init(withCells cells: [[Cell]]) {
        self.cells = cells
        self.x = cells.first!.count
        self.y = cells.count
    }
    
    init(x: Int, y: Int, withFilledPoints points: [(Int, Int)]) {
        
        self.x = x
        self.y = y
        
        // Initialize 2D array of empty cells
        let row = [Cell](count: x, repeatedValue: Cell.Empty)
        var protoCells = [[Cell]](count: y, repeatedValue: row)
        
        for (x, y) in points {
            protoCells[y][x] = Cell.Filled
        }
        
        self.cells = protoCells
    }
    
    // Wrapping index
    subscript(x: Int, y: Int) -> Cell {
        if x < 0 {
            return self[x + self.x, y]
        }
        if x >= self.x {
            return self[x - self.x, y]
        }
        if y < 0 {
            return self[x, y + self.y]
        }
        if y >= self.y {
            return self[x, y - self.y]
        }
        
        return self.cells[y][x]
    }
    
    func neighbors(x x: Int, y: Int) -> [Cell] {
        return [
            // top row
            self[x - 1, y - 1],
            self[x, y - 1],
            self[x + 1, y - 1],
            
            // middle row
            self[x - 1, y],
            self[x + 1, y],
            
            //buttom row
            self[x - 1, y + 1],
            self[x, y + 1],
            self[x + 1, y + 1]
        ]
    }
    
    func filledNeighbors(x x: Int, y: Int) -> Int {
        return self
            .neighbors(x: x, y: y)
            .filter { cell in cell == Cell.Filled }
            .count
    }
    
    func nextCell(x x: Int, y: Int) -> Cell {
        let currentState   = self[x, y]
        let numberAlive    = filledNeighbors(x: x, y: y)
        
        switch currentState {
        case Cell.Empty:
            return numberAlive == 3 ? Cell.Filled : Cell.Empty
        case Cell.Filled:
            return (numberAlive == 2 || numberAlive == 3) ? Cell.Filled : Cell.Empty
        }
    }
    
    func next() -> State {
        var filledPoints = [(Int, Int)]()
        for y in 0 ..< self.y {
            for x in 0 ..< self.x {
                if self.nextCell(x: x, y: y) == Cell.Filled {
                    filledPoints.append((x, y))
                }
            }
        }
        
        return State(x: x, y: y, withFilledPoints: filledPoints)
    }
    
}
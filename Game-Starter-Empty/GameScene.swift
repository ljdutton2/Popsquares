//
//  GameScene.swift
//  Game-Starter-Empty
//
//  Created by mitchell hudson on 9/13/18.
//  Copyright © 2018 Make School. All rights reserved.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var score: Int = 0
    var scoreLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.text = "Score: 0"
        label.color = .white
        label.fontSize = 50
        return label
    }()
    var squares: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        // Called when the scene has been displayed
        score = 0
        scoreLabel.text = "Score: 0"
        
        let pause = SKAction.wait(forDuration: 1.5)
        run(pause)
        
        scoreLabel.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 80)
        addChild(scoreLabel)
        
        let spawn = SKAction.run(spawnSquare)
        let wait = SKAction.wait(forDuration: 1.2)
        
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
  
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for square in squares {
            if let view = view {
                if square.position.y > view.bounds.height {
                    square.removeFromParent()
                    squares.remove(at: squares.index(of: square)!)
                    score -= 1
                    //let gameOver = isGameOver()
                    if isGameOver() {
                        scoreLabel.text = "Game Over!"
                        let wait = SKAction.wait(forDuration: 2)
                        run(wait)
                    } else {
                        scoreLabel.text = "Score: \(score)"
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when touches begin
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if touchedNode.name == "square" {
                touchedNode.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
    
    func spawnSquare() {
        let square = SKSpriteNode(color: .white, size: CGSize(width: 64, height: 64))
        squares.append(square)
        square.name = "square"
        let x = Int.random(in: 40...Int(self.frame.width)-40)
        square.position = CGPoint(x: x, y: 0)
        let moveAction = SKAction.moveBy(x: 0, y: self.frame.height + square.size.height / 2, duration: 3.2)
        square.run(moveAction)
        
        self.addChild(square)
    }
    
    func isGameOver() -> Bool {
        if score <= 0 {
            scoreLabel.text = "Game Over!"
            return true
        } else {
            scoreLabel.text = "Score: \(score)"
            return false
        }
    }
    
    func resetGame() {
        score = 0
        scoreLabel.text = "Score: 0"
        squares.removeAll()
        
        self.removeAllChildren()
        
        let pause = SKAction.wait(forDuration: 1.5)
        run(pause)
        
        if let view = view {
            scoreLabel.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height - 80)
            addChild(scoreLabel)
        }
        
        let spawn = SKAction.run(spawnSquare)
        let wait = SKAction.wait(forDuration: 1.2)
        
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
}

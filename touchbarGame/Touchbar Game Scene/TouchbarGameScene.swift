//
//  TouchbarGameScene.swift
//  touchbarGame
//
//  Created by 周测 on 11/13/19.
//  Copyright © 2019 aiQG_. All rights reserved.
//

import SpriteKit
import GameplayKit

class TouchbarGameScene: SKScene, SKPhysicsContactDelegate {
	
	var isUp:Bool = false
	var isDown:Bool = false
	var isLeft:Bool = false
	var isRight:Bool = false
	
	
	var player:SKSpriteNode!
	
	var scoreLabel:SKLabelNode!
	var score:Int = 0 {
		didSet {
			scoreLabel.text = " \(score) "
		}
	}
	
	var timer:Timer!
	
	
    override func didMove(to view: SKView) {
		super.didMove(to: view)
		self.scaleMode = .resizeFill
		
		self.physicsWorld.gravity = CGVector(dx: 0, dy: 0) //无重力世界
		self.physicsWorld.contactDelegate = self
		
		//初始化score label
		scoreLabel = SKLabelNode(text: " 0 ")
		scoreLabel.position = CGPoint(x: 500, y: 20)
		scoreLabel.zPosition = 1 //over everything
		scoreLabel.fontSize = 10
		scoreLabel.fontName = "AmericanTypewriter-Bold"
		scoreLabel.fontColor = .white
        score = 0
		self.addChild(scoreLabel)
		
		//初始化player
		player = SKSpriteNode(imageNamed: "rocket")
		player.zPosition = 1
		player.scale(to: CGSize(width: 15, height: 10))
		player.position = CGPoint(x: 10, y: 15)
		self.addChild(player)
		//timer -> enemy
		timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addEnemy), userInfo: nil, repeats: true)
		
    }
    
	@objc func addEnemy() {
		let enemy = SKSpriteNode(imageNamed: "enemy")
		
		let randomPosition = GKRandomDistribution(lowestValue: 5, highestValue: 25)
		let position = CGFloat(randomPosition.nextInt())
		
		enemy.position = CGPoint(x: 700, y: position)
		enemy.scale(to: CGSize(width: 21, height: 10))
		//给予物理状态
		enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
		enemy.physicsBody?.isDynamic = true
		//MARK: mask
		enemy.physicsBody?.collisionBitMask = 1
		enemy.physicsBody?.categoryBitMask = 2
		
		self.addChild(enemy)
		
		//动画
		let animationDuration:TimeInterval = 3
		var actionArray = [SKAction]() //动画函数队列
		actionArray.append(SKAction.move(to: CGPoint(x: -10, y: position), duration: animationDuration))
		
		actionArray.append(SKAction.removeFromParent())
		enemy.run(SKAction.sequence(actionArray))
	}
	
	func fire() {
		let shot = SKSpriteNode(imageNamed: "shot")
		shot.position = player.position
		shot.position.x += 5
		
		shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.height / 2)
		shot.physicsBody?.isDynamic = true
		//MARK: mask
		shot.physicsBody?.categoryBitMask = 1
		shot.physicsBody?.collisionBitMask = 2
		shot.physicsBody?.usesPreciseCollisionDetection = true //碰撞检测
		
		self.addChild(shot)
		//动画
		let animationDuration:TimeInterval = 0.5
		var actionArry = [SKAction]() //动画队列
		actionArry.append(SKAction.move(to: CGPoint(x: 700, y: player.position.y), duration: animationDuration))
		actionArry.append(SKAction.removeFromParent())
		shot.run(SKAction.sequence(actionArry))
		
	}
	
	func didReceive(event: NSEvent) {
		if event.type == .keyDown {
			switch event.keyCode {
			//space
			case 49:
				self.fire()
			//up
			case 126:
				isUp = true
			//down
			case 125:
				isDown = true
			//left
			case 123:
				isLeft = true
			//right
			case 124:
				isRight = true
			default:
				print(event)
			}
		} else if event.type == .keyUp {
			switch event.keyCode {
			//up
			case 126:
				isUp = false
			//down
			case 125:
				isDown = false
			//left
			case 123:
				isLeft = false
			//right
			case 124:
				isRight = false
			default:
				print(event)
			}
		}
	}
	
	
	
	
    override func update(_ currentTime: TimeInterval) {
        // movement
		if player.position.y <= 30 - 5 {
			player.position.y += isUp ? 1.25 : 0
		}
		if player.position.y >= 5 {
			player.position.y -= isDown ? 1.25 : 0
		}
		if player.position.x < 678 {
			player.position.x += isRight ? 2 : 0
		}
		if player.position.x > 10 {
			player.position.x -= isLeft ? 2 : 0
		}
    }
	
	
}

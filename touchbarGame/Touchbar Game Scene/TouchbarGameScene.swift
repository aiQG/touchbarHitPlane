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
	
	var CD:Bool = false
	var isUp:Bool = false
	var isDown:Bool = false
	var isLeft:Bool = false
	var isRight:Bool = false
	
	var isPlayerDied:Bool = false
	
	var player:SKSpriteNode!
	
	var scoreLabel:SKLabelNode!
	var score:Int = 0 {
		didSet {
			scoreLabel.text = " \(score)/114514 "
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
		player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
		player.physicsBody?.isDynamic = true
		player.physicsBody?.categoryBitMask = SpriteMask.player
		player.physicsBody?.contactTestBitMask = SpriteMask.enemy
		player.physicsBody?.collisionBitMask = SpriteMask.none
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
		//mask
		enemy.physicsBody?.categoryBitMask = SpriteMask.enemy
		enemy.physicsBody?.contactTestBitMask = SpriteMask.shot
		enemy.physicsBody?.collisionBitMask = SpriteMask.none
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
		//mask
		shot.physicsBody?.categoryBitMask = SpriteMask.shot
		shot.physicsBody?.contactTestBitMask = SpriteMask.enemy
		shot.physicsBody?.collisionBitMask = SpriteMask.none
		shot.physicsBody?.usesPreciseCollisionDetection = true //精确到碰撞检测(防止刚体穿透)
		
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
				if self.CD {return}
				self.CD = true
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
			case 15:
				if isPlayerDied {
					self.reStart()
				}
			default:
				return
			}
		} else if event.type == .keyUp {
			switch event.keyCode {
				//space
			case 49:
				self.CD = false
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
				return
			}
		}
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		//print("first: \(contact.bodyA)\nsecond: \(contact.bodyB)")
		
		//enemy hitted
		if contact.bodyA.categoryBitMask == SpriteMask.enemy && contact.bodyB.categoryBitMask == SpriteMask.shot {
			print("hit enemy")
			
			//添加粒子
			let explosion = SKEmitterNode(fileNamed: "KilledEnemy")!
			explosion.position = contact.bodyA.node!.position
			self.addChild(explosion)
			self.score += 1
			contact.bodyA.node?.removeFromParent()
			contact.bodyB.node?.removeFromParent()
			self.run(SKAction.wait(forDuration: 1)){
				explosion.removeFromParent()
			}
			
			
		} else if contact.bodyA.categoryBitMask == SpriteMask.player && contact.bodyB.categoryBitMask == SpriteMask.enemy {
			print("hit player")
			let explosion = SKEmitterNode(fileNamed: "KilledPlayer")!
			explosion.position = contact.bodyA.node!.position
			self.addChild(explosion)
			contact.bodyA.node?.removeFromParent()
			
			let gameLabel = SKLabelNode(text: "Game Over (\(score)/114514) R(estart)")
			gameLabel.fontSize = 25
			gameLabel.position = CGPoint(x: 350, y: 5)
			self.addChild(gameLabel)
			self.scoreLabel.removeFromParent()
			
			isPlayerDied = true
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
			player.position.x += isRight ? 2.5 : 0
		}
		if player.position.x > 10 {
			player.position.x -= isLeft ? 2.5 : 0
		}
    }
	
	
	func reStart(){
		self.removeAllChildren()
		score = 0
		isPlayerDied = false
		CD = false
		isUp = false
		isDown = false
		isLeft = false
		isRight = false
		
		self.addChild(scoreLabel)
		player.position = CGPoint(x: 10, y: 15)
		self.addChild(player)
		
	}
	
	
	
}

//
//  GameView.swift
//  touchbarGame
//
//  Created by 周测 on 11/14/19.
//  Copyright © 2019 aiQG_. All rights reserved.
//

import Foundation
import SpriteKit



fileprivate extension NSTouchBar.CustomizationIdentifier {
	static let customizationIdentifier = NSTouchBar.CustomizationIdentifier("ocm.touchbar.customizationID")
}
fileprivate extension NSTouchBarItem.Identifier {
	static let identifier = NSTouchBarItem.Identifier("com.touchbar.items.ID")
}






class GameView: SKView {
	//touchbar view
	override func makeTouchBar() -> NSTouchBar? {
		let touchBar = NSTouchBar()
		touchBar.delegate = self
		touchBar.customizationIdentifier = .customizationIdentifier
		touchBar.defaultItemIdentifiers = [.identifier]
		touchBar.customizationAllowedItemIdentifiers = [.identifier]
		return touchBar
	}
	
	var didReceiveEvent: ((NSEvent) -> Void)?
	
	override func keyDown(with event: NSEvent) {
		didReceiveEvent?(event)
	}
	
	override func keyUp(with event: NSEvent) {
		didReceiveEvent?(event)
	}
	
}




extension GameView: NSTouchBarDelegate {
	//set touchbar view
	func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
		switch identifier {
		case NSTouchBarItem.Identifier.identifier:
			let gameView = SKView()
//			gameView.showsFPS = true
//			gameView.showsNodeCount = true
			let scene = TouchbarGameScene()
			let item = NSCustomTouchBarItem(identifier: identifier)
			item.view = gameView
			gameView.presentScene(scene)
			//转发到scene里
			self.didReceiveEvent = scene.didReceive
			
			return item
		default:
			return nil
		}
	}
}





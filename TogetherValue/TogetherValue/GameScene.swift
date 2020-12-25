//
//  GameScene.swift
//  TogetherValue
//
//  Created by Chan Yong Lee on 24.12.20.
//

import SpriteKit
import GameplayKit

class Cloud: SKSpriteNode {
    
}

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let rectangle = SKShapeNode(rect: self.frame)
                rectangle.strokeColor = .green
                rectangle.lineWidth = 20
                addChild(rectangle)
        
        // add background
        let background = SKSpriteNode(color: UIColor(red: 0.6039, green: 0.8, blue: 0.9569, alpha: 1.0), size: CGSize(width: 1000, height: 1000))
        background.position = CGPoint(x:frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        //randomly add clouds
        let cloud = SKSpriteNode(imageNamed: "cloud1")
        let cloudHeight = cloud.frame.height / 2
        let cloudWidth = cloud.frame.width / 2
        cloud.xScale = 0.1
        cloud.yScale = 0.1
        //var clouds = 0
        
        for i in stride(from: 0, to: background.size.width, by: cloudWidth) {
            for j in stride(from: 0, to: background.size.height, by: cloudHeight) {
                let cloud = SKSpriteNode(imageNamed: "cloud1")
                cloud.position = CGPoint(x: i, y: j)
                cloud.xScale = 0.1
                cloud.yScale = 0.1
                
                addChild(cloud)
                //clouds += 1
            }
        }
        //print(clouds)
        
        //add camera
        //var contNodes = 0
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        addChild(cameraNode)
        camera = cameraNode
        print(camera?.position)
        /*
        if let containedNodes = camera?.containedNodeSet() {
            for nodes in containedNodes {
                contNodes += 1
            }
        }
        print(contNodes)
        */
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currCamPos = camera?.position {
            camera?.position = CGPoint(x: currCamPos.x + 10 , y: currCamPos.y + 10)
            print(camera?.position)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

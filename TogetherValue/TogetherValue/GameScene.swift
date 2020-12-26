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
    
    var previousCameraPoint = CGPoint.zero
    var previousCameraScale = CGFloat()
    
    override func didMove(to view: SKView) {
        //setting anchorpoint of this scene
        self.anchorPoint = CGPoint(x: 0, y: 0)
        print("scene anchorPoint: \(self.anchorPoint)")
        print("scene position: \(self.position)")
        
        // for swiping through scene
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        
        // pinch zoom in
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        //this rectangle shows the staring frame of the scene
        
        let rectangle = SKShapeNode(rect: self.frame)
        rectangle.strokeColor = .green
        rectangle.lineWidth = 20
        rectangle.position = CGPoint(x: -view.bounds.width/2,y:-view.bounds.height/2)
        addChild(rectangle)
        
        
        // add background
        let background = SKSpriteNode(color: UIColor(red: 0.6039, green: 0.8, blue: 0.9569, alpha: 1.0), size: CGSize(width: view.bounds.width * 2, height: view.bounds.height * 2))
        background.position = CGPoint(x:frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        print("background position: \(background.position)")
        
        //add bottom limit
        var splinePoints = [CGPoint(x: -view.bounds.width / 2, y: -view.bounds.height / 2), CGPoint(x: view.bounds.width * 1.5, y: -view.bounds.height / 2)]
        let ground = SKShapeNode(splinePoints: &splinePoints, count: splinePoints.count)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.75
        ground.physicsBody?.isDynamic = false
        addChild(ground)
        
        // add cloud
        let cloudTexture = SKTexture(imageNamed: "cloud1")
        let cloud = SKSpriteNode(texture: cloudTexture)
        let cloudHeight = cloud.frame.height / 2
        cloud.position = CGPoint(x:0 , y:0)
        cloud.physicsBody = SKPhysicsBody(texture: cloudTexture, size: cloud.frame.size)
        cloud.physicsBody?.isDynamic = false  // not affected from physics
        addChild(cloud)
        
        //add camera
        let cameraNode = SKCameraNode()
        //cameraNode.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        cameraNode.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        camera = cameraNode
        print("camera position: \(camera?.position)")
        
        // add heave ho body
        let radius = cloudHeight / 2
        let circleBodyStartPoint = CGPoint(x: -view.bounds.width/2,y:-view.bounds.height/2)
        let circleBody = SKShapeNode(circleOfRadius: radius)
        circleBody.fillColor = .yellow
        circleBody.position = circleBodyStartPoint
        circleBody.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        
        //add heav ho arms
        let leftArm = SKShapeNode(rectOf: CGSize(width: radius * 3, height: radius/4))
        let rightArm = SKShapeNode(rectOf: CGSize(width: radius * 3, height: radius/4))
        let leftArmStartpoint = CGPoint(x: circleBodyStartPoint.x - radius, y: circleBodyStartPoint.y)
        let rightArmStartpoint = CGPoint(x: circleBodyStartPoint.x + radius, y: circleBodyStartPoint.y)
        leftArm.fillColor = .yellow
        rightArm.fillColor = .yellow
        //leftArm.position = leftArmStartpoint
        //rightArm.position = rightArmStartpoint
        
        // add heave ho hands
        let leftHand = SKShapeNode(rectOf: CGSize(width: radius / 4, height: radius/4))
        let rightHand = SKShapeNode(rectOf: CGSize(width: radius / 4, height: radius/4))
        leftHand.fillColor = .yellow
        rightHand.fillColor = .yellow
        
        // add joints
        let leftShoulder = SKShapeNode(circleOfRadius: leftArm.frame.height / 2)
        let leftWrist = SKShapeNode(circleOfRadius: leftArm.frame.height / 2)
        let rightShoulder = SKShapeNode(circleOfRadius: leftArm.frame.height / 2)
        let rightWrist = SKShapeNode(circleOfRadius: leftArm.frame.height / 2)
        leftShoulder.fillColor = .red
        leftWrist.fillColor = .red
        rightShoulder.fillColor = .red
        rightWrist.fillColor = .red
        
        addChild(circleBody)
        circleBody.addChild(leftShoulder)
        leftShoulder.addChild(leftArm)
        leftArm.addChild(leftWrist)
        leftWrist.addChild(leftHand)
        circleBody.addChild(rightShoulder)
        rightShoulder.addChild(rightArm)
        rightArm.addChild(rightWrist)
        rightWrist.addChild(rightHand)
        
        // sets gravity to zero
        //physicsWorld.gravity = CGVector(dx: 0, dy: 0)
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        if let currCamPos = camera?.position {
            camera?.position = CGPoint(x: currCamPos.x + 10 , y: currCamPos.y + 10)
            print(camera?.position)
        }
        */
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        // The camera has a weak reference, so test it
        guard let camera = self.camera else {
          return
        }
        // If the movement just began, save the first camera position
        if sender.state == .began {
          previousCameraPoint = camera.position
        }
        // Perform the translation
        let translation = sender.translation(in: self.view)
        let newPosition = CGPoint(
          x: previousCameraPoint.x + translation.x * -1,
          y: previousCameraPoint.y + translation.y
        )
       
        camera.position = newPosition
        print(camera.position)
    }
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
          return
        }
        if sender.state == .began {
          previousCameraScale = camera.xScale
        }
        camera.setScale(previousCameraScale * 1 / sender.scale)
      }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

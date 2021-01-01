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
        // for swiping through scene
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        
        // pinch zoom in
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGesture)
        
        let twoFingerLongPress = UILongPressGestureRecognizer()
        twoFingerLongPress.numberOfTouchesRequired = 2
        twoFingerLongPress.addTarget(self, action: #selector(longPressAction(_:)))
        view.addGestureRecognizer(twoFingerLongPress)
        
        let threeFingerLongPress = UILongPressGestureRecognizer()
        threeFingerLongPress.numberOfTouchesRequired = 3
        threeFingerLongPress.addTarget(self, action: #selector(longPressAction(_:)))
        view.addGestureRecognizer(threeFingerLongPress)
        
        //this rectangle shows the staring frame of the scene
        let rectangle = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        rectangle.strokeColor = .green
        rectangle.lineWidth = 20
        rectangle.position = CGPoint(x: rectangle.frame.width / 2 , y: rectangle.frame.height / 2)
        addChild(rectangle)
        
        let rectangleCenter = SKShapeNode(circleOfRadius: 3)
        rectangleCenter.fillColor = .green
        rectangleCenter.position = CGPoint(x: rectangle.frame.midX, y: rectangle.frame.midY)
        addChild(rectangleCenter)
        
        // add background
        let background = SKSpriteNode(color: UIColor(red: 0.6039, green: 0.8, blue: 0.9569, alpha: 1.0), size: CGSize(width: view.bounds.width * 2, height: view.bounds.height * 2))
        background.anchorPoint = CGPoint(x: 0 , y: 0)
        background.position = CGPoint(x: 0 , y: 0) //CGPoint(x:frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        //add bottom limit
        var splinePoints = [CGPoint(x: 0, y: 0), CGPoint(x: view.bounds.width * 2, y: 0)]
        let ground = SKShapeNode(splinePoints: &splinePoints, count: splinePoints.count)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 0.75
        ground.physicsBody?.isDynamic = false
        addChild(ground)
        
        // add cloud
        let cloudTexture = SKTexture(imageNamed: "cloud1")
        let cloud = SKSpriteNode(texture: cloudTexture)
        let cloudHeight = cloud.frame.height
        cloud.position = CGPoint(x:0 , y:0)
        cloud.physicsBody = SKPhysicsBody(texture: cloudTexture, size: cloud.frame.size)
        cloud.physicsBody?.isDynamic = false  // not affected from physics
        //addChild(cloud)
        
        //add camera
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: rectangle.frame.width / 2, y: rectangle.frame.height / 2)
        addChild(cameraNode)
        camera = cameraNode
        
        /*
        // add heave ho body
        let radius = cloudHeight / 4
        let circleBody = SKShapeNode(circleOfRadius: radius)
        circleBody.fillColor = .yellow
        circleBody.position = CGPoint(x: circleBody.frame.width / 2 , y: circleBody.frame.height / 2)
        circleBody.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        
        //add heav ho arms
        let leftArm = SKShapeNode(rectOf: CGSize(width: radius * 3, height: radius/4))
        let rightArm = SKShapeNode(rectOf: CGSize(width: radius * 3, height: radius/4))
        leftArm.fillColor = .yellow
        rightArm.fillColor = .yellow
        leftArm.position = CGPoint(x: 0, y: 0) //CGPoint(x: circleBody.frame.width + leftArm.frame.width/2, y: circleBody.frame.height / 2)
        leftArm.physicsBody = SKPhysicsBody(rectangleOf: leftArm.frame.size)
        
        // add heave ho hands
        let leftHand = SKShapeNode(rectOf: CGSize(width: radius / 4, height: radius/4))
        let rightHand = SKShapeNode(rectOf: CGSize(width: radius / 4, height: radius/4))
        leftHand.fillColor = .yellow
        rightHand.fillColor = .yellow
        
        // add joints
        let leftShoulderConnectionPoint = CGPoint(x: circleBody.position.x / 2 , y: circleBody.position.y)
        let leftShoulderPinJoint = SKPhysicsJointPin.joint(withBodyA: circleBody.physicsBody!, bodyB: leftArm.physicsBody!, anchor: leftShoulderConnectionPoint)
        leftArm.constraints = [ SKConstraint.distance(SKRange(lowerLimit: radius, upperLimit: radius), to: circleBody) ]
        
        //addChild(circleBody)
        addChild(leftArm)
        */
        
        //---------
        /*
        let sectionLength: CGFloat = 100
        let sectionRect = CGRect(x: -10, y: -sectionLength,
                                 width: 20, height: sectionLength)
           
        let upperArm = SKShapeNode(rect: sectionRect)
        let midArm = SKShapeNode(rect: sectionRect)
        let lowerArm = SKShapeNode(rect: sectionRect)
        let shoulder = SKShapeNode(circleOfRadius: 5)
        let elbow = SKShapeNode(circleOfRadius: 5)
        let wrist = SKShapeNode(circleOfRadius: 5)
        let endEffector = SKShapeNode(circleOfRadius: 5)
        /*
        upperArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        midArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        lowerArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        shoulder.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        elbow.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        wrist.physicsBody = SKPhysicsBody(circleOfRadius: 5)
 */
        upperArm.name = "upperArm"
        midArm.name = "midArm"
        lowerArm.name = "lowerArm"
        shoulder.name = "shoulder"
        elbow.name = "elbow"
        wrist.name = "wrist"
        endEffector.name = "endEffector"
        
        endEffector.physicsBody = SKPhysicsBody(circleOfRadius: 5)
           
        addChild(shoulder)
        shoulder.addChild(upperArm)
        upperArm.addChild(elbow)
        elbow.addChild(midArm)
        midArm.addChild(wrist)
        wrist.addChild(lowerArm)
        lowerArm.addChild(endEffector)

        //fixes shoulder at (320, 320)
        shoulder.constraints = [SKConstraint.positionX(SKRange(constantValue: 320),
                                                       y: SKRange(constantValue: 320))]
            
        //the posistion of each arm elements are defined relatively to its parent's coordinate origin
        //move each part of the arm down a bit to make the how compont look like an arm together
        let positionConstraint = SKConstraint.positionY(SKRange(constantValue: -sectionLength))
        elbow.constraints =  [ positionConstraint ]
        wrist.constraints = [ positionConstraint ]
        endEffector.constraints = [ positionConstraint ]
         */
        //------
        
        
        let point = SKShapeNode(circleOfRadius: 2)
        point.fillColor = .red
        point.position = CGPoint(x: 320, y: 320)
        addChild(point)
           
        let upperArm = SKShapeNode(rectOf: CGSize(width: 100, height: 20))
        let midArm = SKShapeNode(rectOf: CGSize(width: 100, height: 20))
        let lowerArm = SKShapeNode(rectOf: CGSize(width: 100, height: 20))
        let hand  = SKShapeNode(rectOf: CGSize(width: 30, height: 30))
        upperArm.name = "upperArm"
        midArm.name = "midArm"
        lowerArm.name = "lowerArm"
        hand.name = "hand"
        upperArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        upperArm.physicsBody?.isDynamic = false
        midArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        lowerArm.physicsBody = SKPhysicsBody(rectangleOf: upperArm.frame.size)
        hand.physicsBody = SKPhysicsBody(rectangleOf: hand.frame.size)
        upperArm.position = CGPoint(x: 320, y: 320)
        midArm.position = CGPoint(x: upperArm.frame.maxX , y: 320)
        lowerArm.position = CGPoint(x: midArm.frame.maxX + lowerArm.frame.width / 2 , y: 320)
        hand.position = CGPoint(x: lowerArm.frame.maxX , y: 320)
        addChild(upperArm)
        addChild(midArm)
        addChild(lowerArm)
        addChild(hand)
        
        let jointUpperMid = SKPhysicsJointPin.joint(withBodyA: upperArm.physicsBody!, bodyB: midArm.physicsBody!, anchor: CGPoint(x: upperArm.position.x, y: upperArm.frame.minY + upperArm.frame.height / 2))
        let jointMidLow = SKPhysicsJointPin.joint(withBodyA: midArm.physicsBody!, bodyB: lowerArm.physicsBody!, anchor: CGPoint(x: midArm.frame.maxX, y: upperArm.frame.minY + upperArm.frame.height / 2))
        let jointLowHand = SKPhysicsJointFixed.joint(withBodyA: lowerArm.physicsBody!, bodyB: hand.physicsBody!, anchor: CGPoint(x: lowerArm.frame.maxX, y: 320))
        physicsWorld.add(jointUpperMid)
        physicsWorld.add(jointMidLow)
        physicsWorld.add(jointLowHand)
        
        /*
        let distanceUpperMid = SKConstraint.distance(SKRange(lowerLimit: 50, upperLimit: 50), to: upperArm)
        let distanceMidLow = SKConstraint.distance(SKRange(lowerLimit: 100, upperLimit: 100), to: midArm)
        midArm.constraints = [ distanceUpperMid ]
        lowerArm.constraints = [ distanceMidLow ]
 */
        
        upperArm.physicsBody?.affectedByGravity = false
        midArm.physicsBody?.affectedByGravity = false
        lowerArm.physicsBody?.affectedByGravity = false
        hand.physicsBody?.affectedByGravity = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //not a good idea to implement with touches
        
        //physicsWorld.gravity = CGVector(dx: 9.8, dy: 0)
        let accel = SKAction.move(to: CGPoint(x:640, y: 320), duration: 1) //가장근접
        accel.timingMode = SKActionTimingMode.easeIn
        let hand = childNode(withName: "hand")
        hand?.run(accel)
         
        /*
        let shoulder = childNode(withName: "shoulder")
        let endEffector = shoulder?.childNode(withName: "upperArm")?.childNode(withName: "elbow")?.childNode(withName: "midArm")?.childNode(withName: "wrist")?.childNode(withName: "lowerArm")?.childNode(withName: "endEffector")
        let reachAction = SKAction.reach(to: CGPoint(x: 1000, y: 320), rootNode: shoulder!, duration: 1)
        endEffector?.run(reachAction)
 */
        print("touch")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        let shoulder = childNode(withName: "shoulder")
        let endEffector = shoulder!.childNode(withName: "upperArm")!.childNode(withName:"elbow")!.childNode(withName: "midArm")!.childNode(withName: "wrist")!.childNode(withName: "lowerArm")!.childNode(withName: "endEffector")
        
        let reachAction1 = SKAction.reach(to: CGPoint(x: 0, y: 320),
                                         rootNode: shoulder!,
                                         duration: 1.0)
        let reachAction2 = SKAction.reach(to: CGPoint(x: 640, y: 320),
                                         rootNode: shoulder!,
                                         duration: 1.0)
             
        if temp == 0 {
            endEffector!.run(reachAction1)
            temp = 1
        }
        else{
            endEffector!.run(reachAction2)
            temp = 0
        }
        */
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
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
    
    @objc func longPressAction(_ sender: UILongPressGestureRecognizer) {
        //maybe restrict the areas that the arms can move?
        
        if sender.state == UILongPressGestureRecognizer.State.began {
            /*
            if sender.numberOfTouchesRequired == 2 || sender.numberOfTouchesRequired == 3{
                print("long press began")
                physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            }
             */
            let accel : SKAction
            if sender.numberOfTouchesRequired == 2 {
                print("two touch long pressed")
                //accel = SKAction.applyForce(CGVector(dx: 100, dy: 0), duration: 1)
                //accel = SKAction.applyImpulse(CGVector(dx: 100, dy: 0), duration: 1)
                //accel = SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 1)
                let reachPoint = CGPoint(x: 320 + 200, y: 320)
                accel = SKAction.move(to: reachPoint, duration: 1) //가장근접
                accel.timingMode = SKActionTimingMode.easeIn
            }
            else{
                print("three touch long pressed")
                //accel = SKAction.applyForce(CGVector(dx: -100, dy: 0), duration: 1)
                let reachPoint = CGPoint(x: 640, y: 640)
                accel = SKAction.move(to: reachPoint, duration: 1) //가장근접
                accel.timingMode = SKActionTimingMode.easeIn
            }
            let hand = childNode(withName: "hand")
            hand?.run(accel)
        }
        else if sender.state == UIGestureRecognizer.State.ended {
            if sender.numberOfTouchesRequired == 2 || sender.numberOfTouchesRequired == 3{
                print("long press ended")
                physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            }
        }
        else{
            /*
            let accel : SKAction
            if sender.numberOfTouchesRequired == 2 {
                print("two touch long pressed")
                //accel = SKAction.applyForce(CGVector(dx: 100, dy: 0), duration: 1)
                //accel = SKAction.applyImpulse(CGVector(dx: 100, dy: 0), duration: 1)
                //accel = SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 1)
                let reachPoint = CGPoint(x: 320 + 200, y: 320)
                accel = SKAction.move(to: reachPoint, duration: 1) //가장근접
                accel.timingMode = SKActionTimingMode.easeIn
            }
            else{
                print("three touch long pressed")
                accel = SKAction.applyForce(CGVector(dx: -100, dy: 0), duration: 1)
            }
            let hand = childNode(withName: "hand")
            hand?.run(accel)
            
            //if 오차범위내에 --> not dynamic
 */
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

//
//  ViewController.swift
//  ARdice
//
//  Created by Carlos Herrera Somet on 22/4/18.
//  Copyright © 2018 Carlos H Somet. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                addDiceToPlane(at: hitResult)
                    
            }
        }
    }
    
    
    /**
     Add dice model to plane detected at the tap location.
     
     */
    func addDiceToPlane(at location: ARHitTestResult){
        
        let scene = SCNScene(named: "art.scnassets/dice.scn")!
        
        if let node  = scene.rootNode.childNode(withName: "Dice_Red", recursively: true) {
            
            node.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y,
                location.worldTransform.columns.3.z)
            
            diceArray.append(node)
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    
    func rollAll(){
        
        if !diceArray.isEmpty {
            
            for dice in diceArray {
                roll(dice: dice)
            }
        }
        
    }
    
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }

    
    
    /**
     Roll function for every dice
     */
    func roll(dice: SCNNode){
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
       
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
 
}

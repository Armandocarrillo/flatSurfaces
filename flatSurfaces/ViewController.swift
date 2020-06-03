//
//  ViewController.swift
//  flatSurfaces
//
//  Created by Armando Carrillo on 01/06/20.
//  Copyright © 2020 Armando Carrillo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Enable horizontal plane deteccion
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
   
    func createShip(planeAnchor: ARPlaneAnchor) -> SCNNode
    {
        let node = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
        node.position = SCNVector3(planeAnchor.center.x, 0.0, planeAnchor.center.z)
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor
            else
            {return}
        let floor = createFloor(planeAnchor: planeAnchor)
        node.addChildNode(floor)
        
        let ship = createShip(planeAnchor: planeAnchor)
        node.addChildNode(ship)
       
        
        print("A new plane has been discovered.")
       
        
       
    }
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode()
        
        let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        node.geometry = geometry
        node.eulerAngles.x = -Float.pi/2
        node.opacity = 0.25
        
        return node
        
    }
}

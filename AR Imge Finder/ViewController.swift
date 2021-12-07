//
//  ViewController.swift
//  AR Imge Finder
//
//  Created by Андрей on 05.12.2021.
//

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Detect images
        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)!
        
        // Detect planes
//        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        switch anchor {
        case let imageAnchor as ARImageAnchor:
            nodeAdded(node, for: imageAnchor)
        case let planeAnchor as ARPlaneAnchor:
            nodeAdded(node, for: planeAnchor)
        default:
            print(#line, #function, "Unknow anchor has been discovered")
            
        }
    }
    
    func nodeAdded(_ node: SCNNode, for imageAnchor: ARImageAnchor) {
        // Add image size
        let image = imageAnchor.referenceImage
        let size = image.physicalSize
        
        // Create plane of the same size
        let height = 69 / 65 * size.height
        let width = image.name == "horses" ?
            157 / 150 * 15 / 8.1851 * size.width :
            157 / 150 * 15 / 8.247 * size.width
        let plane = SCNPlane(width: width, height: height)
        plane.firstMaterial?.diffuse.contents = image.name == "horses" ?
            UIImage(named: "monument") :
            UIImage(named: "bridge")
        
        // Create plane node
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
 
        // Move plane
        planeNode.position.x += image.name == "theatre" ? -0.002 : 0.001
        
        // Add plane node to the given node
        node.addChildNode(planeNode)
    }
    
    func nodeAdded(_ node: SCNNode, for planeAnchor: ARPlaneAnchor) {
        print(#line, #function, "Plane \(planeAnchor) added")
    }
}

//
//  ViewController.swift
//  Real Minecraft
//
//  Created by Victor Lucas on 05/12/2018.
//  Copyright © 2018 Victor Lucas. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var optionsButton: UIButton!
    
    var blockSize:CGFloat = 0.2
    var iBlock:UIImage!
    
    var blocksImages:[UIImage] = [UIImage(named:"dirt")!,
                                  UIImage(named:"sand")!,
                                  UIImage(named:"stone")!,
                                  UIImage(named:"brick")!,
                                  UIImage(named:"bookshelf")!,
                                  UIImage(named:"bedrock")!,
                                  UIImage(named:"cobblestone_mossy")!,
                                  UIImage(named:"daylight_detector_bottom")!,
                                  UIImage(named:"frosted_ice")!,
                                  UIImage(named:"mushroom_block_skin_red")!,
                                  UIImage(named:"purpur_pillar_top")!,
                                  UIImage(named:"quartz_block_chiseled_top")!,
                                  UIImage(named:"redstone_lamp_on")!,
                                  UIImage(named:"slime")!,
                                  UIImage(named:"sponge")!,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.optionsButton.layer.cornerRadius = 5
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        self.addTapGestureToSceneView()
        
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didTape(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        sceneView.session.pause()
    }

    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTape(withGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
            
        }
        
        if recognizer.state == .changed {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                node.position = SCNVector3(x: translation.x, y: translation.y, z: translation.z)
            }
        }
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
            
        }
        node.removeFromParentNode()
    }

    func addBox(x: Float = 0, y: Float = 0, z: Float = 0) {
        print(self.blockSize)
        let box = SCNBox(width: self.blockSize, height: self.blockSize, length: self.blockSize, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = self.iBlock
        box.materials = [material]
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.position = SCNVector3(x, y, z)
        sceneView.scene.rootNode.addChildNode(boxNode)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    @IBAction func optionsAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsVC") as! OptionsVC
        vc.delegate = self
        vc.size = Float(self.blockSize)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension ViewController : OptionsVCDelegate {
    func updateBlockSize(size: CGFloat) {
        self.blockSize = size
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.blocksImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! BlockCell
        
        cell.imageView.image = self.blocksImages[indexPath.row]
        cell.layer.borderColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.2).cgColor
        cell.layer.borderWidth = 0
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.iBlock = self.blocksImages[indexPath.row]
        let cell = self.collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 50
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

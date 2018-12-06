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

enum Block {
    case dirt
    case sand
    case stone
    case brick
    case bookshelf
    case bedrock
    case cobblestone_mossy
    case daylight_detector_bottom
    case frosted_ice
    case mushroom_block_skin_red
    case purpur_pillar_top
    case quartz_block_chiseled_top
    case redstone_lamp_on
    case slime
    case sponge
}

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var optionsButton: UIButton!
    
    var blockSize:CGFloat = 0.2
    
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
    var block:Block = .dirt
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.optionsButton.layer.cornerRadius = 5
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        self.addTapGestureToSceneView()
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
        var image:UIImage!
        switch self.block {
        case .dirt:
            image = self.blocksImages[0]
        case .sand:
            image = self.blocksImages[1]
        case .stone:
            image = self.blocksImages[2]
        case .brick:
            image = self.blocksImages[3]
        case .bookshelf:
            image = self.blocksImages[4]
        case .bedrock:
            image = self.blocksImages[5]
        case .cobblestone_mossy:
            image = self.blocksImages[6]
        case .daylight_detector_bottom:
            image = self.blocksImages[7]
        case .frosted_ice:
            image = self.blocksImages[8]
        case .mushroom_block_skin_red:
            image = self.blocksImages[9]
        case .purpur_pillar_top:
            image = self.blocksImages[10]
        case .quartz_block_chiseled_top:
            image = self.blocksImages[11]
        case .redstone_lamp_on:
            image = self.blocksImages[12]
        case .slime:
            image = self.blocksImages[13]
        case .sponge:
            image = self.blocksImages[14]
        }
        material.diffuse.contents = image
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
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.block = .dirt
        } else if indexPath.row == 1 {
            self.block = .sand
        } else if indexPath.row == 2 {
            self.block = .stone
        } else if indexPath.row == 3 {
            self.block = .brick
        } else if indexPath.row == 4 {
            self.block = .bookshelf
        }else if indexPath.row == 5 {
            self.block = .bedrock
        }else if indexPath.row == 6 {
            self.block = .cobblestone_mossy
        }else if indexPath.row == 7 {
            self.block = .daylight_detector_bottom
        }else if indexPath.row == 8 {
            self.block = .frosted_ice
        }else if indexPath.row == 9 {
            self.block = .mushroom_block_skin_red
        }else if indexPath.row == 10 {
            self.block = .purpur_pillar_top
        }else if indexPath.row == 11 {
            self.block = .quartz_block_chiseled_top
        }else if indexPath.row == 12 {
            self.block = .redstone_lamp_on
        }else if indexPath.row == 13 {
            self.block = .slime
        }else if indexPath.row == 14 {
            self.block = .sponge
        }
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

//
//  OptionsVC.swift
//  Real Minecraft
//
//  Created by Victor Lucas on 06/12/2018.
//  Copyright © 2018 Victor Lucas. All rights reserved.
//

import UIKit

protocol OptionsVCDelegate {
    func updateBlockSize(size:CGFloat)
}

class OptionsVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var blockSizeBar: UISlider!
    
    var delegate:OptionsVCDelegate?
    var size:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blockSizeBar.value = self.size
        self.logoImageView.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.updateBlockSize(size: CGFloat(self.blockSizeBar.value))
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

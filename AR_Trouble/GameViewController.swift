//
//  GameViewController.swift
//  AR_Trouble
//
//  Created by Imke Beekmans on 03/05/2018.
//  Copyright © 2018 Imke Beekmans. All rights reserved.


import ARKit
import LBTAComponents


class GameViewController: UIViewController {
    
    
//Create a ARview manually
    let arView: ARSCNView = {//AR is for ARKit SCN is for SCNKit
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // PLUSBUTTON
    // Code for the plusbutton
    let plusButtonWidth = ScreenSize.width * 0.1
    lazy var plusButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Plusbutton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1.0, alpha: 0.7)
        button.layer.cornerRadius = plusButtonWidth * 0.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePlusButtonTapped), for: .touchUpInside)
        button.layer.zPosition = 1
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    @objc func handlePlusButtonTapped() {
        print("Tapped on plus button")
        }
    
    // MINUSBUTTON
    // Code for the minusbutton
    
//    let minusButtonWidth = ScreenSize.width * 0.1
//    lazy var minusButton: UIButton = {
//        var button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "MinusButton").withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = UIColor(white: 1.0, alpha: 0.7)
//        button.layer.cornerRadius = minusButtonWidth * 0.5
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(handleMinusButtonTapped), for: .touchUpInside)
//        button.layer.zPosition = 1
//        button.imageView?.contentMode = .scaleAspectFill
//        return button
//    }()
//
//    @objc func handleMinusButtonTapped() {
//        print("Tapped on minus button")
//        //        removeAllNodes()
//    }
//
//    // RESETBUTTON
//    // Code for the resetbutton
//
//    let resetButtonWidth = ScreenSize.width * 0.1
//    lazy var resetButton: UIButton = {
//        var button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "ReloadButton").withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = UIColor(white: 1.0, alpha: 0.7)
//        button.layer.cornerRadius = resetButtonWidth * 0.5
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(handleResetButtonTapped), for: .touchUpInside)
//        button.layer.zPosition = 1
//        button.imageView?.contentMode = .scaleAspectFill
//        return button
//    }()
//
//    @objc func handleResetButtonTapped() {
//        print("Tapped on reset button")
//        //        resetScene()
//    }
    

    
     
    
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupViews()
        
        
        
        
        arView.session.run(configuration, options: [])
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupViews(){

    view.addSubview(arView)
    arView.fillSuperview()
        
    //PLUSBUTTON
    view.addSubview(plusButton)
    plusButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 250, bottomConstant: 30, rightConstant: 0, widthConstant: plusButtonWidth, heightConstant: plusButtonWidth)
    
//    //MINUSBUTTON
//    view.addSubview(minusButton)
//    minusButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 50 , widthConstant: minusButtonWidth, heightConstant: minusButtonWidth)
//
//    //RESETBUTTON
//    view.addSubview(resetButton)
//    resetButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0 , widthConstant: resetButtonWidth, heightConstant: resetButtonWidth)
//        resetButton.anchorCenterXToSuperview()
        
        

        
    }
    
    
    
}

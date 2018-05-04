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
        addNode()
        }
    
    // MINUSBUTTON
    // Code for the minusbutton
    
    let minusButtonWidth = ScreenSize.width * 0.1
    lazy var minusButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "MinusButton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1.0, alpha: 0.7)
        button.layer.cornerRadius = minusButtonWidth * 0.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleMinusButtonTapped), for: .touchUpInside)
        button.layer.zPosition = 1
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    @objc func handleMinusButtonTapped() {
        print("Tapped on minus button")
        removeAllShapes()
     }

    // RESETBUTTON
    // Code for the resetbutton

    let resetButtonWidth = ScreenSize.width * 0.1
    lazy var resetButton: UIButton = {
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ReloadButton").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(white: 1.0, alpha: 0.7)
        button.layer.cornerRadius = resetButtonWidth * 0.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleResetButtonTapped), for: .touchUpInside)
        button.layer.zPosition = 1
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()

    @objc func handleResetButtonTapped() {
        print("Tapped on reset button")
            resetScene()
    }
    

    
     
    
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupViews()
        
        
        
        
        arView.session.run(configuration, options: [])
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        arView.autoenablesDefaultLighting = true
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupViews(){

    view.addSubview(arView)
    arView.fillSuperview()
        
    //PLUSBUTTON
    view.addSubview(plusButton)
    plusButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 250, bottomConstant: 30, rightConstant: 0, widthConstant: plusButtonWidth, heightConstant: plusButtonWidth) //Button located on the left on the bottom of the screen
    
    //MINUSBUTTON
    view.addSubview(minusButton)
    minusButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 250 , widthConstant: minusButtonWidth, heightConstant: minusButtonWidth) //Button located on the right on the bottom of the screen

    //RESETBUTTON
    view.addSubview(resetButton)
    resetButton.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 30, rightConstant: 0 , widthConstant: resetButtonWidth, heightConstant: resetButtonWidth) //Button located in the middle on the bottom of the screen
        resetButton.anchorCenterXToSuperview() //Located to the center

        
        

        
    }
    
    func addNode() {
        let shapeNode = SCNNode()
        shapeNode.geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.0002) //width, height and length in meters
        shapeNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Material")
        shapeNode.position = SCNVector3(Float.random(min: -0.5, max: 0.5),Float.random(min: -0.5, max: 0.5),Float.random(min: -0.5, max: 0.5)) //x,y,z coordinates in meters
        shapeNode.name = "node"
        arView.scene.rootNode.addChildNode(shapeNode)
    } 
    
    func removeAllShapes() {
        arView.scene.rootNode.enumerateChildNodes { (node, _ ) in
            if node.name == "node" {
                node.removeFromParentNode()
                    }
        
        
                }
            }
    
        func resetScene() {
            arView.session.pause()
            arView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "node" {
                    node.removeFromParentNode()
                }
            }
            arView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
        }
    
}

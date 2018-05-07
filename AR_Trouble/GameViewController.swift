//
//  GameViewController.swift
//  AR_Trouble
//
//  Created by Imke Beekmans on 03/05/2018.
//  Copyright © 2018 Imke Beekmans. All rights reserved.


import ARKit
import LBTAComponents


class GameViewController: UIViewController, ARSCNViewDelegate {
    
    
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
//        addNode()
        var doesEarthNodeExistInScene = false //Makes sure there is only one earth, like real life
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "earth" {
                doesEarthNodeExistInScene = true
            }
        }
        if !doesEarthNodeExistInScene { //If doesEarthNode does NOT exist in scene
            addEarth()
        }
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
    
//    Distance label
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.black
        label.text = "Distance:"
        return label
    }()
    
//    X label
    let xLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.red
        label.text = "x:"
        return label
    }()
    
//    y label
    let yLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.green
        label.text = "y:"
        return label
    }()
    
//    z label
    let zLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.blue
        label.text = "z:"
        return label
    }()
    
    let centerImageView: UIImageView = {
       let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Center")
        view.contentMode = .scaleAspectFill
        return view
    }()
//  Measure distance
    var startingPositionNode: SCNNode?
    var endingPositionNode: SCNNode?
    let cameraRelativePosition = SCNVector3(0,0,-0.1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupViews()
        
        
        configuration.planeDetection = .horizontal
//        configuration.planeDetection = .vertical
        
        arView.session.run(configuration, options: [])
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        arView.autoenablesDefaultLighting = true
        arView.delegate = self
        
//      Hit Testing stuff
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGestureRecognizer)
        
        
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
      
//  Distance label
    view.addSubview(distanceLabel)
        distanceLabel.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 35, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 24)
        
//  x,y,z labels
    view.addSubview(xLabel)
    view.addSubview(yLabel)
    view.addSubview(zLabel)
        
    xLabel.anchor(distanceLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
    yLabel.anchor(xLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
    zLabel.anchor(yLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
    view.addSubview(centerImageView)
        centerImageView.anchorCenterSuperview()
        centerImageView.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: ScreenSize.width*0.05, heightConstant: ScreenSize.width*0.05)

        
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
    
//        //Code to create the floor
//        func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
//            let floor = SCNNode()
//            floor.name = "floor" //The name of the floor is floor
//            floor.eulerAngles = SCNVector3(90.degreesToRadians,0,0) //The plane is now a horizontal floor
//            floor.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)) //Makes the floor floor(plane)-shaped. The x and the z values are used, cuz that are the ground values (y is up in the air)
//            floor.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Material") //Material of the floor
//            floor.geometry?.firstMaterial?.isDoubleSided = true //Material is shown on both sides
//            floor.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z) //The floor is positioned at the ground
//            return floor
//        }
    
    func removeNode(named: String) {
        arView.scene.rootNode.enumerateChildNodes { (node, _ ) in
            if node.name == named {
                node.removeFromParentNode()
            }
            
            
        }
    }
    
    
//        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//            guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
//            print("New Plane Anchor with extent:", anchorPlane.extent)
//            let floor = createFloor(anchor: anchorPlane)
//            node.addChildNode(floor)
//
//        }
//
//        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//            guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
//            print("Plane Anchor Updated with extent:", anchorPlane.extent)
//            removeNode(named: "floor")
//            print("New Plane Anchor with extent:", anchorPlane.extent)
//            let floor = createFloor(anchor: anchorPlane)
//            node.addChildNode(floor)
//        }
//
//        func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//            guard let anchorPlane = anchor as? ARPlaneAnchor else { return }
//            print("Plane Anchor removed with extent:", anchorPlane.extent)
//            removeNode(named: "floor ")
//        }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        if startingPositionNode != nil && endingPositionNode != nil {
            return
        }
        
        guard let xDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.x else { return }
        guard let yDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.y else { return }
        guard let zDistance = Service.distance3(fromStartingPositionNode: startingPositionNode, onView: arView, cameraRelativePosition: cameraRelativePosition)?.z else { return }
        
        DispatchQueue.main.async {
            self.xLabel.text = String(format: "x: %.2f", xDistance) + "m"
            self.yLabel.text = String(format: "y: %.2f", yDistance) + "m"
            self.zLabel.text = String(format: "z: %.2f", zDistance) + "m"
            self.distanceLabel.text = String(format: "Distance: %.2f", Service.distance(x: xDistance, y: yDistance, z: zDistance)) + "m"
            
        }
        
    }
    
//      HitTest
    @objc func handleTap(sender: UITapGestureRecognizer) {
//        let tappedView = sender.view as! SCNView
//        let touchLocation = sender.location(in: tappedView)
//        let hitTest = tappedView.hitTest(touchLocation, options: nil)
//        if !hitTest.isEmpty { //If it is N0T empty
//            let result = hitTest.first!
//            let name = result.node.name
//            let geometry = result.node.geometry
//            print("Tapped \(String(describing: name)) with geometry: \(String(describing: geometry))")
        if startingPositionNode != nil && endingPositionNode != nil {
            startingPositionNode?.removeFromParentNode()
            endingPositionNode?.removeFromParentNode()
            startingPositionNode = nil
            endingPositionNode = nil
        } else if startingPositionNode != nil && endingPositionNode == nil{
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            Service.addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePosition: cameraRelativePosition)
            endingPositionNode = sphere
        } else if startingPositionNode == nil && endingPositionNode == nil {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.002))
            sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
            Service.addChildNode(node: sphere, toNode: arView.scene.rootNode, inView: arView, cameraRelativePosition: cameraRelativePosition)
            startingPositionNode = sphere
        }
        

        
        
        
        
        
        }
        
//    }
    
    func addEarth() {
        let earthNode = SCNNode()
        earthNode.name = "earth"
        earthNode.geometry = SCNSphere(radius: 0.2)
        earthNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "EarthDiffuse")
        earthNode.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "EarthSpecular")
        earthNode.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "EarthEmmision")
        earthNode.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "EarthNormal")
        earthNode.position = SCNVector3(0,0,-0.5)
        arView.scene.rootNode.addChildNode(earthNode)

        let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 15) //Rotate the earth a full 360 degrees in 15 seconds
        let rotateForever = SCNAction.repeatForever(rotate)
        earthNode.runAction(rotateForever)
    }

}


// DIFFUSE: The diffuse property specifies the amount of light diffusely reflected from the surface

//SPECULAR: The specuar property specifies the amount of light to reflect in a mirror-like manner

//EMMISION: The emmision property specifies the amount of light the material emits. The emmision does not light up other surfaces in the scene

//NORMAL: The normal property specifies the surface orientation

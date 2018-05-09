//
//  ViewController.swift
//  Face Detection
//
//  Created by Jaskirat Singh on 06/05/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "game") else {
            return
        }
        
        let imageView = UIImageView(image: image)
        view.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        //imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: scaledHeight).isActive = true
        
        let request = VNDetectFaceRectanglesRequest { (req, error) in
            if error != nil {
                print("failed to detect faces")
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else {
                        return
                    }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1.16 - faceObservation.boundingBox.origin.y) - height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    let redView = UIView()
                    redView.backgroundColor = UIColor.red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                }
                
            })
            
        }
        
        guard let cgImage = image.cgImage else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            }
            catch let reqError {
                print("Failed to perform request: ", reqError)
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return.lightContent
    }

}


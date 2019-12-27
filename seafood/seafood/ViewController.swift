//
//  ViewController.swift
//  seafood
//
//  Created by احلام المطيري on 27/12/2019.
//  Copyright © 2019 احلام المطيري. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera // if i need the photo library .photolirary
        imagePicker.allowsEditing = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if   let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
        imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else{
                fatalError("could not convert to ciimage")
            }
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError("loading coreml model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request,error) in
            
            guard   let results = request.results as? [VNClassificationObservation] else {
                fatalError("model failed to prosess image")
            }
           // print(results)
            if let firstResult = results.first {
                if firstResult.identifier.contains("pizza") {
                    self.navigationItem.title = "pizza!"
               //     self.navigationItem.title.fontcolor = .green
                } else {
                    self.navigationItem.title = "Not pizza!"
                    
                    }
                }
            }
            
        
        let handler = VNImageRequestHandler(ciImage:image)
        do {
        try! handler.perform([request])
        } catch {
            print(error)
        }
        
    }

    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}


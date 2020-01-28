//
//  AbsolutelyNotController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 11/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

//https://www.hackingwithswift.com/example-code/uikit/how-to-take-a-photo-using-the-camera-and-uiimagepickercontroller

//https://stackoverflow.com/questions/47752434/displaying-selected-image-on-screen-using-uiiamgepickercontrollerdelegate-in-swi

//https://blog.cmgresearch.com/2017/06/22/vision-kit-and-coreml.html

//https://stackoverflow.com/questions/8425647/how-to-convert-uiimage-to-ciimage-and-vice-versa

//https://medium.com/aubergine-solutions/image-recognition-using-core-ml-and-vision-framework-cd7580bd6fbd

//https://programmingwithswift.com/pass-arguments-to-a-selector-with-swift/

//FONTS
//http://iosfonts.com

import UIKit
import CoreML
import Vision
import AVFoundation

class AbsolutelyNotController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UIPopoverPresentationControllerDelegate
{
    
    //MARK: - UI VARIABLES
       var camera: UIBarButtonItem!
       var library: UIBarButtonItem!
       //text view
       var answerField: UITextView!
       //outletView
       var outletView: UIImageView!
       

       
       override func viewDidLoad()
       {
           super.viewDidLoad()
           
           //MARK: - TOOLBAR INTERFACE
           navigationController?.setToolbarHidden(false, animated: true)
           navigationController?.setNavigationBarHidden(false, animated: true)
           navigationController?.toolbar.barTintColor = .systemBackground
           camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
           library = UIBarButtonItem(title: "LIBRARY", style: .plain, target: self, action: #selector(openPhotoLibrary))
           let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
           toolbarItems = [spacer, spacer, spacer, library, spacer, spacer, camera, spacer, spacer, spacer]
           
           //MARK: - OUTLET VIEW INIT
           outletView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.8))
           outletView.contentMode = .scaleAspectFill
           view.addSubview(outletView)
        

           outletView.translatesAutoresizingMaskIntoConstraints = false
           outletView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
           outletView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
           outletView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
           outletView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           outletView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
           
           //MARK: - LABELS
            //https://stackoverflow.com/questions/37893000/swift-infinite-fade-in-and-out-loop
           answerField = UITextView(frame: CGRect(x: 25, y: self.view.frame.midY - 50, width: self.view.frame.width - 50, height: 120))
           //answerField.font = .boldSystemFont(ofSize: 60)
        answerField.font = UIFont(name: "Avenir-BlackOblique", size: 60)
           answerField.textColor = .black
           answerField.textAlignment = .center
           answerField.isEditable = false
           answerField.adjustsFontForContentSizeCategory = true
           answerField.text = "Take a picture or choose a picture from your library to learn what something is \n PROBABLY NOT"
           answerField.updateTextFont()
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            answerField.textColor = .white
            answerField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            answerField.textColor = .black
            answerField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)

        }
           view.addSubview(answerField)
           answerField.isHidden = false
       }
    
    //MARK: - INTERFACE CHANGES
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if self.traitCollection.userInterfaceStyle == .dark
                  {
                      self.view.backgroundColor = .black
                    self.answerField.textColor = .white
                    answerField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
                  }
                  else if self.traitCollection.userInterfaceStyle == .light
                  {
                      self.view.backgroundColor = .white
                    self.answerField.textColor = .black
                    answerField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
                  }
       }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            if self.traitCollection.userInterfaceStyle == .dark
            {
                self.view.backgroundColor = .black
              self.answerField.textColor = .white
            }
            else if self.traitCollection.userInterfaceStyle == .light
            {
                self.view.backgroundColor = .white
              self.answerField.textColor = .black
            }
       }
       
       @objc func takePicture()
       {
           let vc = UIImagePickerController()
           vc.sourceType = .camera
           vc.allowsEditing = true
           vc.delegate = self
           present(vc, animated: true)
       }
       
        @objc func openPhotoLibrary()
          {
              if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
              {
                  let imagePicker = UIImagePickerController()
                  imagePicker.delegate = self
                  imagePicker.sourceType = .photoLibrary
                  imagePicker.allowsEditing = true
                  present(imagePicker, animated: true)
              }
          }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
       {
           var selectedImagefromPicker: UIImage?
          
           if let editedImage = info[.editedImage] as? UIImage
           {
               selectedImagefromPicker = editedImage
           }
           else if let originalImage = info[.originalImage] as? UIImage
           {
               selectedImagefromPicker = originalImage
           }
           
           if let selectedImage = selectedImagefromPicker
           {
               outletView.image = selectedImage
               guard let transformedImage = CIImage(image: selectedImage) else { return }
               artificialIntelligence(image: transformedImage)
           }
           print(selectedImagefromPicker!.size)
           
           dismiss(animated: true, completion: nil)
       
       }
       
    //MARK: - ARTIFICIAL INTELLIGENCE, BABY!
    
    func artificialIntelligence(image: CIImage)
           {
            
            answerField.frame.size.width = self.outletView.frame.width
            answerField.frame.origin.x = self.outletView.frame.origin.x
            answerField.updateTextFont()
            answerField.text = "Detecting image ..."

               // Load the ML model through its generated class
               guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
                   fatalError("Can't load Inception ML model")
               }

               // Create a Vision request with completion handler
               let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                   guard let results = request.results as? [VNClassificationObservation],
   
                    let lastResult = results.last else
                   {
                    fatalError("Unexpected result type")
                    }
                
                let finalResultI: String = lastResult.identifier
                let limit = ","
                let finalResultIDCut = finalResultI.components(separatedBy: limit)
                let finalResultFinal = finalResultIDCut[0]

                   // Update UI on main queue
                   DispatchQueue.main.async { [weak self] in
                       
                    if lastResult.identifier.startsWithVowel
                    {
                        self?.answerField.text = "ABSOLUTELY NOT \n an \(finalResultFinal)"
                        self?.answerField.updateTextFont()
                    }
                    else
                    {
                        self?.answerField.text = "ABSOLUTELY NOT \n a \(finalResultFinal)"
                        self?.answerField.updateTextFont()
                    }
                   }
               }

               // Run the Core ML model classifier on global dispatch queue
               let handler = VNImageRequestHandler(ciImage: image)
               DispatchQueue.global(qos: .userInteractive).async {
                   do {
                       try handler.perform([request])
                   } catch {
                       print(error)
                   }
               }
           }
}



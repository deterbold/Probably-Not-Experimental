//
//  GameController.swift
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

import UIKit
import CoreML
import Vision
import AVFoundation

class GameController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
{
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var outletView: UIImageView!
    
    
    @IBOutlet weak var thingToFindLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var resultsArray = [String]()
       
    var thingToFind: String!
       
    var wonTheGame = false
    
    let findThisList = ["acoustic guitar", "backpack, back pack, knapsack, packsack, rucksack, haversack", "balloon", "can opener, tin opener", "cellular telephone, cellular phone, cellphone, cell, mobile phone", "computer keyboard, keypad", "desktop computer", "digital clock", "digital watch", "dining table, board", "electric guitar", "frying pan, frypan, skillet", "guillotine", "hammer", "jean, blue jean, denim", "laptop, laptop computer", "loudspeaker, speaker, speaker unit, loudspeaker system, speaker system", "mask","minivan", "nipple", "padlock", "park bench", "parking meter", "pillow", "screwdriver", "ski mask", "television, television system", "tennis ball", "typewriter keyboard", "vacuum, vacuum cleaner", "toilet seat", "wallet, billfold, notecase, pocketbook", "water bottle", "street sign", "pretzel", "cheeseburger", "hotdog, hot dog, red hot", "strawberry", "orange", "lemon", "fig", "pineapple, ananas", "banana", "pizza, pizza pie","volcano","toilet tissue, toilet paper, bathroom tissue", "cup","broccoli"]
       
    //let findThisList = ["laptop, laptop computer"]
    
    
    
    
    @IBAction func takePicture(_ sender: Any)
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func openPhotoLibrary(_ sender: Any)
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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "didSee")
        {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(goHome))
        }
        
        setupGame()

    }
    
    @objc func goHome()
    {
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
    @IBAction func restartGame(_ sender: Any)
    {
        setupGame()
    }
    
   
    func setupGame()
    {
        let delimiter = ","
        thingToFind = findThisList.randomElement()
        let thingToFindCut = thingToFind.components(separatedBy: delimiter)
        if thingToFindCut[0].startsWithVowel
        {
            self.thingToFindLabel.text = "an \(thingToFindCut[0])"
        }
        else
        {
            self.thingToFindLabel.text = "a \(thingToFindCut[0])"
        }
        
        thingToFind = thingToFindCut[0] as! String
        //print("Thing to find: ", thingToFind!)
        
        wonTheGame = false
        
        //clearing the UI
        
        self.resultsLabel.text = ""
        self.answerLabel.text = ""
        outletView.image = nil
        
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
    
    
    
    func artificialIntelligence(image: CIImage)
           {
               answerLabel.text = "Detecting image..."

               // Load the ML model through its generated class
               guard let model = try? VNCoreMLModel(for: Resnet50().model) else
               {
                   fatalError("Can't load Inception ML model")
               }

               // Create a Vision request with completion handler
               let request = VNCoreMLRequest(model: model)
               { [weak self] request, error in

                guard let results = request.results as? [VNClassificationObservation],
                    
                    
                    let firstResult = results.first else { fatalError("unexpected result type") }
                    let secondResult = results[1] as? VNClassificationObservation
                let thirdResult = results[2] as? VNClassificationObservation
                let fourthResult = results[3] as? VNClassificationObservation
                
                let firstResultID: String = firstResult.identifier
                let secondResultID: String = secondResult?.identifier ?? "The results was not good"
                let thirdResultID: String = thirdResult?.identifier ?? "The result was not good"
                let fourthResultID: String = fourthResult?.identifier ?? "the result was not good"
                

                DispatchQueue.main.async
                {
                    [weak self] in
                    
                    let ttf = self?.thingToFind!
                    
                    let limit = ","
                    let firstResultIDCut = firstResultID.components(separatedBy: limit)
                    let firstResultFInal = firstResultIDCut[0]
                    print(firstResultFInal)
                    let secondResultIDCut = secondResultID.components(separatedBy: limit)
                    let secondResultFInal = secondResultIDCut[0]
                    print(secondResultFInal)
                    let thirdResultIDCut = thirdResultID.components(separatedBy: limit)
                    let thirdResultFInal = thirdResultIDCut[0]
                    print(thirdResultFInal)
                    let fourthResultIDCut = fourthResultID.components(separatedBy: limit)
                    let fourthResultFInal = fourthResultIDCut[0]
                    print(fourthResultFInal)
                    
                    if firstResultFInal == ttf
                    {
                        print("too right guess")
                        
                        if firstResultFInal.startsWithVowel
                        {
                            print("vowel")
                            self?.answerLabel.text = "That is actually an \(ttf!)"
                            self?.resultsLabel.text = "Try finding something that is not, but could probably be an \(ttf!)"
                        }
                        else
                        {
                            print("consonant")
                            self?.answerLabel.text = "That is actually a \(ttf!)"
                            self?.resultsLabel.text = "Try finding something that is not, but could probably be a \(ttf!)"
                        }
                    }
                    
                    if secondResultFInal == ttf || thirdResultFInal == ttf || fourthResultFInal == ttf
                    {
                        print("right guess guess")
                        self?.answerLabel.text = "CONGRATS! That is not a \(ttf!), but it could be"
                        self?.resultsLabel.text = "The computer sees: \(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                        
                    }
                    else
                    {
                        print("totally wrong guess")
                        
                        if firstResultFInal.startsWithVowel
                        {
                            print("vowel")
                            self?.answerLabel.text = "That is actually an \(firstResultFInal)"
                            self?.resultsLabel.text = "The computer sees: \(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                        }
                        else
                        {
                            print("consonant")
                            self?.answerLabel.text = "That is actually a \(firstResultFInal)"
                            self?.resultsLabel.text = "The computer sees: \(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                        }
                        
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

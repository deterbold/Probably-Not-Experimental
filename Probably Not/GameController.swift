//
//  GameController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 11/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

//TOOLBAR: https://www.hackingwithswift.com/example-code/uikit/how-to-show-and-hide-a-toolbar-inside-a-uinavigationcontroller


import UIKit
import MultipeerConnectivity
import CoreML
import Vision
import AVFoundation

public struct LabelTexts: Codable
{
    var answerTxt: String
    var resultsTxt: String
}

class GameController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
{
    //MARK: - MULTIPEER UI VARIABLES
    var hostButton: UIButton!
    var joinButton: UIButton!
    
    //MARK: - MULTIPEER VARIABLES
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    //MARK: - GAME UI VARIABLES
    var camera: UIBarButtonItem!
    var reset: UIBarButtonItem!
    var library: UIBarButtonItem!
    //outletView
    var outletView: UIImageView!
    //labels
    var thingToFindLabel: UILabel!
    var answerLabel: UITextView!
    var resultsLabel: UITextView!
    
    //MARK: - GAME VARIABLES
    var resultsArray = [String]()
    var thingToFind: String!
    var wonTheGame = false
    
    let findThisList = ["acoustic guitar", "backpack, back pack, knapsack, packsack, rucksack, haversack", "balloon", "can opener, tin opener", "cellular telephone, cellular phone, cellphone, cell, mobile phone", "computer keyboard, keypad", "desktop computer", "digital clock", "digital watch", "dining table, board", "electric guitar", "frying pan, frypan, skillet", "guillotine", "hammer", "jean, blue jean, denim", "laptop, laptop computer", "loudspeaker, speaker, speaker unit, loudspeaker system, speaker system", "mask","minivan", "nipple", "padlock", "park bench", "parking meter", "pillow", "screwdriver", "ski mask", "television, television system", "tennis ball", "typewriter keyboard", "vacuum, vacuum cleaner", "toilet seat", "wallet, billfold, notecase, pocketbook", "water bottle", "street sign", "pretzel", "cheeseburger", "hotdog, hot dog, red hot", "strawberry", "orange", "lemon", "fig", "pineapple, ananas", "banana", "pizza, pizza pie","volcano","toilet tissue, toilet paper, bathroom tissue", "cup","broccoli"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

       //MARK: - MULTIPEER INTERFACE
        hostButton = UIButton(frame: CGRect(x: (view.frame.midX) - 50, y: (view.frame.midY) - 50, width: 100, height: 50))
        hostButton.backgroundColor = .darkGray
        hostButton.layer.cornerRadius = 14
        hostButton.setTitle("Host Game", for: .normal)
        hostButton.addTarget(self, action: #selector(hostGame), for: .touchUpInside)
        self.view.addSubview(hostButton)
        hostButton.isHidden = true
        
        joinButton = UIButton(frame: CGRect(x: (view.frame.midX) - 50, y: (view.frame.midY) + 50, width: 100, height: 50))
        joinButton.backgroundColor = .darkGray
        joinButton.layer.cornerRadius = 14
        joinButton.setTitle("Join Game", for: .normal)
        joinButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)
        self.view.addSubview(joinButton)
        joinButton.isHidden = true
        
        //MARK: - MULTIPEER
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        //MARK: - GAME INTERFACE
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        reset = UIBarButtonItem(title: "RESET", style: .plain, target: self, action: #selector(resetGame))
        library = UIBarButtonItem(title: "LIBRARY", style: .plain, target: self, action: #selector(openPhotoLibrary))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, library, spacer, camera, spacer, reset, spacer]
        
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
        thingToFindLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.midY, width: self.view.frame.width, height: 40))
        thingToFindLabel.font = .boldSystemFont(ofSize: 20)
        thingToFindLabel.textAlignment = .center
        thingToFindLabel.text = ""
        view.addSubview(thingToFindLabel)
        
        //https://stackoverflow.com/questions/37893000/swift-infinite-fade-in-and-out-loop
        
        answerLabel = UITextView(frame: CGRect(x: 0, y: self.view.frame.midY - 50, width: self.view.frame.width, height: 70))
        answerLabel.font = .boldSystemFont(ofSize: 40)
        answerLabel.isEditable = false
        answerLabel.textAlignment = .center
        answerLabel.text = ""
        answerLabel.updateTextFont()
        view.addSubview(answerLabel)
        answerLabel.isHidden = true
        
        resultsLabel = UITextView(frame: CGRect(x: 0, y: self.view.frame.midY + 50, width: self.view.frame.width, height: 50))
        resultsLabel.font = .boldSystemFont(ofSize: 30)
        resultsLabel.isEditable = false
        resultsLabel.textAlignment = .center
        resultsLabel.text = ""
        resultsLabel.updateTextFont()
        view.addSubview(resultsLabel)
        resultsLabel.isHidden = true
        
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            thingToFindLabel.textColor = .white
            answerLabel.textColor = .white
            answerLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
            resultsLabel.textColor = .white
            resultsLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
          
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            thingToFindLabel.textColor = .black
            answerLabel.textColor = .black
            answerLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
            resultsLabel.textColor = .black
            resultsLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
        }
        
        startGame()
        
    }
    
    //MARK: - INTERFACE CHANGES
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if self.traitCollection.userInterfaceStyle == .dark
            {
                self.view.backgroundColor = .black
                thingToFindLabel.textColor = .white
                answerLabel.textColor = .white
                answerLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
                resultsLabel.textColor = .white
                resultsLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
              
            }
            else if self.traitCollection.userInterfaceStyle == .light
            {
                self.view.backgroundColor = .white
                thingToFindLabel.textColor = .black
                answerLabel.textColor = .black
                answerLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
                resultsLabel.textColor = .black
                resultsLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
            }
       }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            if self.traitCollection.userInterfaceStyle == .dark
            {
                self.view.backgroundColor = .black
                thingToFindLabel.textColor = .white
                answerLabel.textColor = .white
                answerLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
                resultsLabel.textColor = .white
                resultsLabel.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
              
            }
            else if self.traitCollection.userInterfaceStyle == .light
            {
                self.view.backgroundColor = .white
                thingToFindLabel.textColor = .black
                answerLabel.textColor = .black
                answerLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
                resultsLabel.textColor = .black
                resultsLabel.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
            }
       }
    

    // MARK: - BUTTON ACTIONS
    @objc func hostGame(sender: UIButton)
    {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "PN-game", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        
        hostButton.isHidden = true
        joinButton.isHidden = true
        
        startGame()
    }
    
    
    @objc func joinGame(sender: UIButton)
    {
        let mcBrowser = MCBrowserViewController(serviceType: "PN-game", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        hostButton.isHidden = true
        joinButton.isHidden = true
    }
    
    //MARK: - MULTIPEER FUNCTIONS
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("browser finished")
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        hostButton.isHidden = false
        joinButton.isHidden = false
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("Fatal Error")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        if let image = UIImage(data: data)
        {
            DispatchQueue.main.async { [unowned self] in
                self.outletView.image = image
            }
        }
    //https://stackoverflow.com/questions/52838432/why-are-strings-sent-via-multipeer-connectivity-garbled-on-the-receiving-end
        
        let receivedData = data
        let decoder = JSONDecoder()
        let attepmt = try? decoder.decode(LabelTexts.self, from: receivedData)
        print(attepmt!.answerTxt)
        print(attepmt!.resultsTxt)
        
        DispatchQueue.main.async {
            self.answerLabel.text = attepmt!.answerTxt
            self.resultsLabel.text = attepmt!.resultsTxt
        }
        
    }
    
    //MARK: - SENDING DATA
    func sendImage(img: UIImage)
    {
        if mcSession.connectedPeers.count > 0
        {
            if let imageData = img.pngData()
            {
                do
                {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError
                {
                    let ac = UIAlertController(title: "ERROR sending image", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func sendString(str1: String, str2: String)
    {
        let labels = LabelTexts(answerTxt: str1, resultsTxt: str2)
        let encoder = JSONEncoder()
        let encodedLabels = (try? encoder.encode(labels))!
        if mcSession.connectedPeers.count > 0
        {
            let stringToSend = String(data: encodedLabels, encoding: .utf8)
            if let stringData = stringToSend?.data(using: .utf8)
            {
                do
                {
                    try mcSession.send(stringData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError
                {
                    let ac = UIAlertController(title: "ERROR sending text", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    
    //MARK: - GAME FUNCTIONS

    func startGame()
    {
        print("game started")
        navigationController?.setToolbarHidden(false, animated: true)
        thingToFindLabel.isHidden = false
        
        let delimiter = ","
        thingToFind = findThisList.randomElement()
        let thingToFindCut = thingToFind.components(separatedBy: delimiter)
        
        if thingToFindCut[0].startsWithVowel
        {
            self.thingToFindLabel.text = "Find me an \(thingToFindCut[0])"
        }
        else
        {
            self.thingToFindLabel.text = "Find me a \(thingToFindCut[0])"
        }
        
        thingToFind = thingToFindCut[0]
        
        //restarting the game
        wonTheGame = false
        
        //clearing the UI
        self.answerLabel.text = ""
        self.answerLabel.isHidden = true
        self.resultsLabel.text = ""
        self.resultsLabel.isHidden = true
        outletView.image = nil
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
    
    @objc func resetGame()
    {
        startGame()
    }
    
    //MARK: - IMAGE PICKER CONTROLLER
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
            print(selectedImage)
            self.outletView.image = selectedImage
            guard let transformedImage = CIImage(image: selectedImage) else { return }
            artificialIntelligence(image: transformedImage)
        }
        print(selectedImagefromPicker!.size)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - ARTIFICIAL INTELLIGENCE, BABY!
    
    func artificialIntelligence(image: CIImage)
    {
        thingToFindLabel.text = ""
        thingToFindLabel.isHidden = true
        answerLabel.isHidden = false
        resultsLabel.isHidden = false
        
        answerLabel.frame.size.width = self.outletView.frame.width
        answerLabel.frame.origin.x = self.outletView.frame.origin.x
        resultsLabel.frame.size.width = self.outletView.frame.width
        resultsLabel.frame.origin.x = self.outletView.frame.origin.x
        
        answerLabel.text = "Detecting image..."
        answerLabel.updateTextFont()

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
                    
                     self?.answerLabel.text = "That is actually \nan \(ttf!)"
                     self?.resultsLabel.text = "Try finding something that is not, but could probably be an \(ttf!)"
                        self?.answerLabel.updateTextFont()
                    self?.resultsLabel.updateTextFont()
                 }
                 else
                 {
                     print("consonant")
                     self?.answerLabel.text = "That is actually \na \(ttf!)"
                     self?.resultsLabel.text = "Try finding something that is not, but could probably be a \(ttf!)"
                    self?.answerLabel.updateTextFont()
                    self?.resultsLabel.updateTextFont()
                 }
             }
             
             if secondResultFInal == ttf || thirdResultFInal == ttf || fourthResultFInal == ttf
             {
                 print("right guess guess")
                 self?.answerLabel.text = "CONGRATS! That is not \na \(ttf!), but it could be"
                 self?.resultsLabel.text = "The computer sees: \n\(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                self?.answerLabel.updateTextFont()
                self?.resultsLabel.updateTextFont()
                 
             }
             else
             {
                 print("totally wrong guess")
                 
                 if firstResultFInal.startsWithVowel
                 {
                     print("vowel")
                     self?.answerLabel.text = "That is actually \n an \(firstResultFInal)"
                     self?.resultsLabel.text = "The computer sees: \n\(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                    self?.answerLabel.updateTextFont()
                    self?.resultsLabel.updateTextFont()
                 }
                 else
                 {
                     print("consonant")
                     self?.answerLabel.text = "That is actually \n a \(firstResultFInal)"
                     self?.resultsLabel.text = "The computer sees: \n\(firstResultFInal), \(secondResultFInal), \(thirdResultFInal), \(fourthResultFInal) "
                    self?.answerLabel.updateTextFont()
                    self?.resultsLabel.updateTextFont()
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

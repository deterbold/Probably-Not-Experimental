//
//  ViewController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 11/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var presentationLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        print(UserDefaults.standard.bool(forKey: "didSee"))

        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(changeFont))
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
    }

    @IBAction func pressedGame(_ sender: Any)
    {
        if !UserDefaults.standard.bool(forKey: "didSee")
        {
            UserDefaults.standard.set(true, forKey: "didSee")
            performSegue(withIdentifier: "toTutorial", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "toGame", sender: self)
        }
    }
    
    @objc func changeFont()
    {
        print("triple tapped")
        presentationLabel.font = UIFont(name: "SansBullshitSans", size: UIFont.labelFontSize)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}


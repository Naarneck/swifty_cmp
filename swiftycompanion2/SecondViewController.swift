//
//  SecondViewController.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/6/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var histogram: Histogram!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image.makeRounded()
        histogram.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.height/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

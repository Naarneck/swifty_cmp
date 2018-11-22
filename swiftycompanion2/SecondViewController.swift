//
//  SecondViewController.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/6/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    let data = ["proj 1 ","proj 2","proj 2","proj 2","proj 2"]
    var currentProject = [ProjectsUser(finalMark: 0, status: "unknown", validated: false, project: Cursus(name: "unknown", slug: "unknown"), markedAt: "unknown")]

    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var histogram: Histogram!
    @IBOutlet weak var pickerProject: UIPickerView!
    @IBOutlet weak var projname: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        scrollview.canCancelContentTouches = false
//        scrollview.delaysContentTouches = false
        pickerProject.dataSource = self
        pickerProject.delegate = self
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

extension SecondViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return data.count
        return currentProject.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.projname.text = data[row]
        self.projname.text = currentProject[row].project.name
        if let mark = currentProject[row].finalMark {
            self.mark.text = String(mark)
        } else {
            self.mark.text = "0"
        }
        self.status.text = currentProject[row].status
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentProject[row].project.name
    }
}

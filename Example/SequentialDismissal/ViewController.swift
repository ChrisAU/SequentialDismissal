//
//  ViewController.swift
//  SequentialDismissal
//
//  Created by Chris Nevin on 18/10/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var firstRun: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func dummyViewController() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard firstRun else {
            return
        }
        firstRun = false
        
        let a = dummyViewController()
        let b = dummyViewController()
        let c = dummyViewController()
        let d = dummyViewController()
        
        self.sequentialPresentation(of: [a, b, c, d], animated: true) { [weak self] in
            print("Presented all")
            self?.sequentialDismiss(animated: true, completion: {
                print("Dismissed all")
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


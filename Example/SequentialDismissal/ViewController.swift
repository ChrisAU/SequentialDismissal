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

        presentOnTop(a)
        presentOnTop(b)
        presentOnTop(c)
        presentOnTop(d) {
            b.sequentialDismiss() { // Dismiss c, d
                self.sequentialPresentation(of: [c, d]) {
                    c.sequentialDismiss() { // Dismiss d
                        self.sequentialPresentation(of: [d]) {
                            self.sequentialDismiss()    // Dismiss a, b, c, d
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


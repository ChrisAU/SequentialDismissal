//
//  SecondViewController.swift
//  SequentialDismissal
//
//  Created by Chris Nevin on 18/10/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import UIKit

class SecondViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let max: UInt32 = 255
        var random: CGFloat {
            return CGFloat(arc4random_uniform(max)) / CGFloat(max)
        }
        view.backgroundColor = UIColor(red: random, green: random, blue: random, alpha: 1)
    }
}

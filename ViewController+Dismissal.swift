//
//  ViewController+Dismissal.swift
//  SequentialDismissal
//
//  Created by Chris Nevin on 18/10/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//

import UIKit

extension UIViewController {
    private var sequentialPresentedViewControllers: [UIViewController] {
        var orderToDismiss = [UIViewController]()
        var topMost = self
        while topMost.presentedViewController != nil {
            orderToDismiss.append(topMost)
            topMost = topMost.presentedViewController!
        }
        return orderToDismiss.reversed()
    }

    /// Present view controllers in sequence then call completion once final view controller has been presented.
    /// - parameter viewControllers: View Controllers in order they should be presented.
    /// - parameter animated: Whether or not to animate presentation of each view controller.
    /// - parameter completion: Called once all `viewControllers` have been presented.
    func sequentialPresentation(of viewControllers: [UIViewController],
                                animated: Bool = true,
                                completion: (() -> ())? = nil) {
        guard viewControllers.count > 0 else {
            completion?()
            return
        }
        var toPresent = viewControllers
        let current = toPresent.removeFirst()
        present(current, animated: animated) {
            current.sequentialPresentation(of: toPresent, animated: animated, completion: completion)
        }
    }

    /// Dismiss view controllers starting from the top-most view controller working backwards.
    /// - parameter animated: Whether or not to animate dismissal of each view controller.
    /// - parameter completion: Called once all View Controllers have been dismissed.
    func sequentialDismiss(animated: Bool = true,
                           completion: (() -> ())? = nil) {
        var toDismiss = sequentialPresentedViewControllers
        func dismissFirst(finished: @escaping () -> ()) {
            guard toDismiss.count > 0 else {
                finished()
                return
            }
            toDismiss.removeFirst().dismiss(animated: animated) {
                dismissFirst(finished: finished)
            }
        }
        dismissFirst {
            completion?()
        }
    }
}

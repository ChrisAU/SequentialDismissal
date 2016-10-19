//
//  ViewController+Dismissal.swift
//  SequentialDismissal
//
//  Created by Chris Nevin on 18/10/2016.
//  Copyright © 2016 CJNevin. All rights reserved.
//
//  Extension to safely present and dismiss view controllers irrespective of hierarchy and current state.
//

import UIKit

extension UIViewController {
    var topMostViewController: UIViewController {
        var topMost = self
        while topMost.presentedViewController != nil {
            topMost = topMost.presentedViewController!
        }
        return topMost
    }

    private var sequentialPresentedViewControllers: [UIViewController] {
        var orderToDismiss = [UIViewController]()
        var topMost = self
        while topMost.presentedViewController != nil {
            orderToDismiss.append(topMost)
            topMost = topMost.presentedViewController!
        }
        return orderToDismiss.reversed()
    }

    private var alreadyPresentingOrDismissing: Bool {
        let topMost = topMostViewController
        return topMost.isBeingPresented || topMost.presentedViewController?.isBeingPresented == true ||
            topMost.isBeingDismissed || topMost.presentedViewController?.isBeingDismissed == true
    }

    /// Present view controller on top of stack when possible.
    /// - parameter viewController: View Controller to present.
    /// - parameter animated: Whether or not to animate presentation of the view controller.
    /// - parameter completion: Called once the `viewController` has been presented.
    func presentOnTop(_ viewController: UIViewController,
                      animated: Bool = true,
                      completion: (() -> ())? = nil) {
        sequentialPresentation(of: [viewController], animated: animated, completion: completion)
    }

    /// Present view controllers in sequence on top of stack then call completion once final view controller has been presented.
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
        if alreadyPresentingOrDismissing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                self?.sequentialPresentation(of: viewControllers, animated: animated, completion: completion)
            })
            return
        }
        var toPresent = viewControllers
        let current = toPresent.removeFirst()
        topMostViewController.present(current, animated: animated) {
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

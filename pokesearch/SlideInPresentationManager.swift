//
//  SlideInPresentationManager.swift
//  MedalCount
//
//  Created by paul on 22/03/2017.
//  Copyright © 2017 Ron Kliffer. All rights reserved.
//

import UIKit
enum PresentationDirection {
  case left
  case top
  case right
  case bottom
}

class SlideInPresentationManager: NSObject {
  
var direction = PresentationDirection.left


}
// MARK: - UIViewControllerTransitioningDelegate
extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(presentedViewController: presented,
                                                               presenting: presenting,
                                                               direction: direction)
    return presentationController
  }
}

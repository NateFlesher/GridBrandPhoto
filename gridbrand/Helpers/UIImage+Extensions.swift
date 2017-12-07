//
//  UIImage+Extensions.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 11/1/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func forceLazyImageDecompression() -> UIImage {
        #if os(iOS)
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        self.draw(at: CGPoint.zero)
        UIGraphicsEndImageContext()
        #endif
        return self
    }
}

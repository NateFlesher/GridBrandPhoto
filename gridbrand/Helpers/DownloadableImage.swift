//
//  DownloadableImage.swift
//  RxExample
//
//  Created by Vodovozov Gleb on 10/31/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
#endif
import UIKit

enum DownloadableImage{
    case content(image:UIImage)
    case offlinePlaceholder

}

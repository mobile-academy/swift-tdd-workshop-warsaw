//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import Eureka

@testable
import TDDWorkshop

extension PollViewController {

    func simulateTextInput(forRowWithType type: ValidationFieldType, text: String) {
        form.allRows.filter {
            $0.tag == type.rawValue
        }.forEach {
            row in
            row.hightlightCell()
            row.baseValue = text
            row.unhighlightCell()
        }
    }

}

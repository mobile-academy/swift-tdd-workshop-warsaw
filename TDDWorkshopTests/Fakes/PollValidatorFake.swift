//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

@testable
import TDDWorkshop

class ValidatorFake: ValidatorType {
    private(set) var didCallValidateText: Bool = false
    private(set) var didCallFailMessage: Bool = false

    func validateText(text: String?) -> Bool {
        self.didCallValidateText = true
        return false
    }

    func validationFailMessage() -> String {
        self.didCallFailMessage = true
        return ""
    }

}

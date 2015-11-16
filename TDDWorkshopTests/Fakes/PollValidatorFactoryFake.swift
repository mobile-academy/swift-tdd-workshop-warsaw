//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

@testable
import TDDWorkshop

class ValidationFactoryFake: ValidatorFactoryType {
    let validator: ValidatorType

    init(validator: ValidatorType) {
        self.validator = validator
    }

    func validatorForKey(key: ValidationFieldType) -> ValidatorType? {
        return self.validator
    }
}

//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

protocol ValidatorFactoryType {
    func validatorForKey(key: ValidationFieldType) -> ValidatorType?
}

class ValidatorFactory: ValidatorFactoryType {

    func validatorForKey(key: ValidationFieldType) -> ValidatorType? {
        switch key {
        case .Text: return IllegalSymbolsValidator()
        case .Email: return EmailValidator()
        case .Comment: return CharactersMinimalCountValidator(10)
        }
    }

}

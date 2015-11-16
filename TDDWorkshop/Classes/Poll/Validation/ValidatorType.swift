//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

protocol ValidatorType {
    func validateText(text: String?) -> Bool
    func validationFailMessage() -> String
}

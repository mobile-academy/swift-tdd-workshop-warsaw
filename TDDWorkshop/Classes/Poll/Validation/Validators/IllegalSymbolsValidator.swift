//
// Created by Maciej Oczko on 16.11.2015.
// Copyright (c) 2015 Mobile Academy. All rights reserved.
//

import Foundation

class IllegalSymbolsValidator: ValidatorType {

    func validateText(text: String?) -> Bool {
        guard let text = text where !text.isEmpty else {
            return false
        }
        return [
                NSCharacterSet.illegalCharacterSet(),
                NSCharacterSet.symbolCharacterSet(),
                NSCharacterSet.punctuationCharacterSet(),
                NSCharacterSet.nonBaseCharacterSet(),
                NSCharacterSet.controlCharacterSet(),
        ].reduce(true) {
            $0 && text.rangeOfCharacterFromSet($1) == nil
        }
    }

    func validationFailMessage() -> String {
        return "invalid characters"
    }

}

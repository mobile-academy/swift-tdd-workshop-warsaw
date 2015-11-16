//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

class EmailValidator: ValidatorType {

    func validateText(text: String?) -> Bool {
        guard let text = text where !text.isEmpty else {
            return false
        }
        return self.validateEmail(text)
    }

    func validationFailMessage() -> String {
        return "invalid email format"
    }

    private func validateEmail(email: String) -> Bool {
        let pattern = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluateWithObject(email)
    }
}

//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

class CharactersMinimalCountValidator: ValidatorType {
    let minimalCharactersCount: Int

    init(_ minimalCharactersCount: Int) {
        self.minimalCharactersCount = minimalCharactersCount
    }

    func validateText(text: String?) -> Bool {
        guard let text = text where !text.isEmpty else {
            return false
        }
        return text.characters.count >= self.minimalCharactersCount
    }

    func validationFailMessage() -> String {
        return "less than \(self.minimalCharactersCount) characters"
    }
}

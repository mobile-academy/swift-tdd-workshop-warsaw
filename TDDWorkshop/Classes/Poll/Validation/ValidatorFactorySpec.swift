//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable
import TDDWorkshop

class ValidatorFactorySpec: QuickSpec {
    override func spec() {
        var factory: ValidatorFactory!

        beforeEach() {
            factory = ValidatorFactory()
        }

        afterEach {
            factory = nil
        }

        it("should return illegal symbols validator for name") {
            expect(factory.validatorForKey(.Text) is IllegalSymbolsValidator).to(beTrue())
        }

        it("should return email validator for username") {
            expect(factory.validatorForKey(.Email) is EmailValidator).to(beTrue())
        }

        it("should return minimal characters cound validator for comment") {
            expect(factory.validatorForKey(.Comment) is CharactersMinimalCountValidator).to(beTrue())
        }
    }
}

//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation

@testable
import TDDWorkshop

class PollManagerFake: PollSender {

    var pollAlreadySent: Bool = false
    var completionFlag: Bool = true
    private(set) var didCallSendPoll: Bool = false

    func isPollAlreadySent() -> Bool {
        return pollAlreadySent
    }

    func sendPoll(poll: Poll, completion: ((Bool, NSError?) -> ())?) {
        self.didCallSendPoll = true
        if let completion = completion {
            completion(self.completionFlag, nil)
        }
    }
}

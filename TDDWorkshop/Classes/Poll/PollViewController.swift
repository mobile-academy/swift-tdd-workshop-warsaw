//
//  PollViewController.swift
//  TDD Workshop
//
//  Created by Maciej Oczko on 03.07.2015.
//  Copyright © 2015 Mobile Academy. All rights reserved.
//

import UIKit
import Eureka

enum ValidationFieldType: String {
    case Text = "name"
    case Comment = "feedback"
    case Email = "email"
}

struct ValidationContext {
    let validator: String? -> Bool
    let message: String
}

class PollViewController: FormViewController {
    let sections = ["Intro", "Testing techniques", "Red Green Refactor", "Working with Legacy Code"]

    var pollManager: PollSender? = PollManager()
    var pollBuilder: PollBuilder? = PollBuilder()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Feedback"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pollBuilder = pollBuilder else {
            return
        }

        let validators = [ValidationFieldType.Text: ValidationContext(validator: validateText, message: "Invalid characters"),
                          ValidationFieldType.Comment: ValidationContext(validator: validateComment, message: "Your comment is too short"),
                          ValidationFieldType.Email: ValidationContext(validator: validateEmail, message: "Invalid email format")]

        configureGeneralSection(validators, pollBuilder: pollBuilder)
        configureAgendaSections(sections, validators: validators, pollBuilder: pollBuilder)
    }

    override func viewWillAppear(animated: Bool) {
        guard let pollManager = pollManager else {
            return
        }

        // Think what else could be tested for this class.
        navigationItem.rightBarButtonItem =
                pollManager.isPollAlreadySent()
                ? nil
                : UIBarButtonItem(title: "Send", style: .Plain, target: self, action: "didTapSend")

    }

    func didTapSend() {
        guard let pollBuilder = pollBuilder where pollBuilder.isValid() else {
            showInvalidPollAlert()
            return
        }

        let sendAction = UIAlertAction(title: "Yes", style: .Default) {
            [weak self] _ in
            self?.sendPoll()
        }

        let alert = UIAlertController(title: "Confirmation", message: "You can send it only once.\nDo you want to continue?", preferredStyle: .Alert)

        alert.addAction(sendAction)
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        alert.preferredAction = sendAction

        presentViewController(alert, animated: true, completion: nil)
    }

    func sendPoll() {
        guard let pollManager = pollManager, let pollBuilder = pollBuilder else {
            return
        }

        let poll = pollBuilder.poll()
        pollManager.sendPoll(poll) {
            [weak self] success, error in
            if success {
                self?.navigationItem.setRightBarButtonItem(nil, animated: true)
            }
        }
    }

    func showInvalidPollAlert() {
        let alert = UIAlertController(title: "Error", message: "Can't send poll.\nFields with * are required.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: Validation

    // TODO: Extract and test validation logic (to make it more reusable and reliable).
    // Hint 1: Create common Validator protocol
    // Hint 2: Create different validators (comment, email, etc.)
    // Hint 3: Create validators factory (remember about tests)
    // Hint 4: To simulate input on form cell use this code: `simulateTextInput(foforRowWithType:text:)` where type is `ValidationFieldType`.
    //          E.g.: simulateTextInput(forRowWithType: .Text, text: "fixture string")

    func validateComment(comment: String?) -> Bool {
        guard let comment = comment where !comment.isEmpty else {
            return false
        }
        return comment.characters.count > 10
    }

    func validateEmail(email: String?) -> Bool {
        guard let email = email where !email.isEmpty else {
            return false
        }
        let pattern = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluateWithObject(email)
    }

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
            $0 || text.rangeOfCharacterFromSet($1) != nil
        }
    }
}

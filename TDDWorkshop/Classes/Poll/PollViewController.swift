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
    var validatorFactory: ValidatorFactoryType? = ValidatorFactory()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        title = "Feedback"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let pollBuilder = pollBuilder, let validatorFactory = validatorFactory else {
            return
        }

        let buildContext = {
            (key: ValidationFieldType) -> ValidationContext in
            let validator = validatorFactory.validatorForKey(key)!
            return ValidationContext(validator: validator.validateText, message: validator.validationFailMessage())
        }

        let validators = [
                ValidationFieldType.Text: buildContext(ValidationFieldType.Text),
                ValidationFieldType.Comment: buildContext(ValidationFieldType.Comment),
                ValidationFieldType.Email: buildContext(ValidationFieldType.Email)]

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
}

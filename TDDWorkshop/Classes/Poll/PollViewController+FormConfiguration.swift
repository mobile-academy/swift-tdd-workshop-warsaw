//
// Created by Maciej Oczko on 03.03.2016.
// Copyright (c) 2016 Mobile Academy. All rights reserved.
//

import Foundation
import UIKit
import Eureka

typealias Emoji = String
let 🎉 = "🎉", 👍🏻 = "👍🏻", 😎 = "😎", 👎🏻 = "👎🏻", 😡 = "😡"
let symbols = [
        "🎉": 5,
        "👍🏻": 4,
        "😎": 3,
        "👎🏻": 2,
        "😡": 1
]

extension PollViewController {

    // MARK: Form configuration

    func configureForm(sections: [String], validators: [ValidatorType:ValidationContext], pollBuilder: PollBuilder) {
        configureGeneralSection(validators, pollBuilder: pollBuilder)
        configureAgendaSections(sections, validators: validators, pollBuilder: pollBuilder)
    }

    func configureGeneralSection(validators: [ValidatorType:ValidationContext], pollBuilder: PollBuilder) {
        form +++ Section("General")
                <<<
                NameRow("name") {
                    $0.title = "Name*"
                    $0.placeholder = "John Smith?"
                }
                .onCellHighlight {
                    [weak self] (_, row) in
                    row.onCellUnHighlight {
                        (_, row) in
                        guard let context = validators[.Text] else {
                            return
                        }
                        if context.validator(row.value) {
                            pollBuilder.setName(row.value)
                        } else {
                            self?.showInvalidValueAlert(context.message)
                        }
                    }
                }
                <<<
                EmailRow("username") {
                    $0.title = "E-mail*"
                    $0.placeholder = "you@example.com"
                }
                .onCellHighlight {
                    [weak self] (_, row) in
                    row.onCellUnHighlight {
                        (_, row) in
                        guard let context = validators[.Email] else {
                            return
                        }
                        if context.validator(row.value) {
                            pollBuilder.setEmail(row.value)
                        } else {
                            self?.showInvalidValueAlert(context.message)
                        }
                    }
                }
                <<<
                TextAreaRow("feedback") {
                    $0.title = "General feedback"
                    $0.placeholder = "Write general feedback..."
                }
                .onCellUnHighlight {
                    [weak self] (cell, row) in
                    guard let context = validators[.Comment] else {
                        return
                    }
                    if context.validator(row.value) {
                        pollBuilder.setComments(row.value)
                    } else {
                        self?.showInvalidValueAlert(context.message)
                    }
                }
    }

    func configureAgendaSections(sections: [String], validators: [ValidatorType:ValidationContext], pollBuilder: PollBuilder) {
        for (i, section) in sections.enumerate() {
            form +++ Section(section)
                    <<<
                    SegmentedRow<Emoji>("rate\(i)") {
                        $0.title = "What's your rate?"
                        $0.options = [🎉, 👍🏻, 😎, 👎🏻, 😡]
                        $0.value = 🎉
                        pollBuilder.setRate(symbols[🎉], forTitle: section)
                    }
                    .onChange {
                        row in
                        guard let value = row.value else {
                            return
                        }
                        pollBuilder.setRate(symbols[value], forTitle: section)
                    }
                    <<<
                    TextAreaRow("comment\(i)") {
                        $0.title = "Comments"
                        $0.placeholder = "Write your comments here..."
                    }
                    .onCellUnHighlight {
                        [weak self] (cell, row) in
                        guard let context = validators[.Comment] else {
                            return
                        }
                        if context.validator(row.value) {
                            pollBuilder.setComment(row.value, forTitle: section)
                        } else {
                            self?.showInvalidValueAlert(context.message)
                        }
                    }
        }
    }

    func showInvalidValueAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

//
//  Copyright © 2015 Mobile Academy. All rights reserved.
//


import UIKit

class AgendaViewController: UITableViewController {

    var agendaProvider: AgendaProviding!

    // MARK: Initialisers
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        self.agendaProvider = AgendaProvider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.agendaProvider = AgendaProvider()
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // reload agenda
        self.agendaProvider.reloadAgenda { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: Table view
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.agendaProvider.agendaItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AgendaItemCellIdentifier, forIndexPath: indexPath) as! AgendaItemCell
        
        let agendaItem = self.agendaProvider.agendaItems[indexPath.row]
        
        cell.nameLabel.text = agendaItem.name
        cell.timeLabel.text = agendaItem.time
        
        return cell
    }
}

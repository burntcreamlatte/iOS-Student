//
//  RepresentativeTableViewCell.swift
//  Representative
//
//  Created by Aaron Shackelford on 11/20/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepresentativeTableViewCell: UITableViewCell {

    var representative: Representative? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var repNameLabel: UILabel!
    @IBOutlet weak var repPartyLabel: UILabel!
    @IBOutlet weak var repPhoneLabel: UILabel!
    @IBOutlet weak var repDistrictLabel: UILabel!
    @IBOutlet weak var repWebsiteLabel: UILabel!

    
    func updateViews() {
        repNameLabel.text = representative?.name
        repPartyLabel.text = representative?.party
        repPhoneLabel.text = representative?.phone
        repDistrictLabel.text = representative?.district
        repWebsiteLabel.text = representative?.link
    }
}

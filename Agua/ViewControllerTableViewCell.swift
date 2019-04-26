//
//  ViewControllerTableViewCell.swift
//  RutinaGymApp
//
//  Created by Mike on 4/24/19.
//  Copyright © 2019 UTNG. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {


    @IBOutlet weak var lblMarca: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblPreferencia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  DailyForecastTableViewCell.swift
//  WeatherClient
//
//  Created by Anhquan Nguyen on 8/10/19.
//  Copyright © 2019 Anhquan Nguyen. All rights reserved.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {

    // Mark: Outlets
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var forecastImageView: UIImageView!
    
    // Mark: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

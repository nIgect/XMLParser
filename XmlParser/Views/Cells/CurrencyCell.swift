//  Created by iOS on 11.02.2019.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var scale: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.currency.text = nil
        self.currencyName.text = nil
        self.rate.text = nil
        self.scale.text = nil
    }
    
    func configure() {}

}

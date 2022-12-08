import Foundation
import UIKit

class CelulaHome: UITableViewCell {
    
    @IBOutlet weak var celulaView: CustomizacaoCelula!
    @IBOutlet weak var siglaLabel: UILabel!
    @IBOutlet weak var porcentagemLabel: UILabel!
    
}

class CustomizacaoCelula: UIView {
    
    func valoresCelula() {
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

extension UILabel {
    
    func corLabel(variacaoPorcentagem: Double) {
        if variacaoPorcentagem < 0 {
            self.textColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1)   // #D0021B
        } else if variacaoPorcentagem > 0 {
            self.textColor = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1) // #7ED321
        } else {
            self.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) // #FFFFFF
        }
    }
}

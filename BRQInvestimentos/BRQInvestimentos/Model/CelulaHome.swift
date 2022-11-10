import Foundation
import UIKit

class CelulaHome: UITableViewCell {
    // View / Labels - HomeViewController
    @IBOutlet weak var celulaView: CustomizacaoCelula!
    @IBOutlet weak var siglaLabel: UILabel!
    @IBOutlet weak var porcentagemLabel: UILabel!
    
}

    // Customização da Celula - HomeViewController
class CustomizacaoCelula: UIView {
    
    func valoresCelula() {
       
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}

    // Cor Porcentagem
extension UILabel {
    
    func corLabel(variacaoPorcentagem: Double) {
        if variacaoPorcentagem < 0 { // red #D0021B
//            self.textColor = UIColor.red
            self.textColor = UIColor(hex: "#D0021Bff")
        } else if variacaoPorcentagem > 0 {
//            self.textColor = UIColor.green // green 7ED321
            self.textColor = UIColor(hex: "#7ED321ff")
        } else {
            self.textColor = UIColor.white
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}

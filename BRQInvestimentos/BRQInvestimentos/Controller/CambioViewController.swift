import Foundation
import UIKit

class CambioViewController: UIViewController {
    
    @IBOutlet weak var viewCambio: UIView!
    
    @IBOutlet weak var siglaNomeLabel: UILabel!
    @IBOutlet weak var variacaoLabel: UILabel!
    @IBOutlet weak var precoCompraLabel: UILabel!
    @IBOutlet weak var precoVendaLabel: UILabel!
    
    @IBOutlet weak var saldoDisponivelLabel: UILabel!
    @IBOutlet weak var moedaCaixaLabel: UILabel!
    
    @IBOutlet weak var botaoVender: UIButton!
    @IBOutlet weak var botaoComprar: UIButton!
    
    @IBOutlet weak var quantidadeTextField: UITextField!
    
    var customizacaoBotao = CustomizacaoBotao()
    var customizacaoView = CustomizacaoView()
    var customizacaoQuantidade = CustomizacaoTextField()
    
    var moedaSelecionada: Currency?
    var siglaMoeda = String()
    var currencyISO = String()
    var carteira: Carteira?
    var totalTransacao = Double()
    var valorDeVenda = Double()
    var valorDeCompra = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantidadeTextField.delegate = self
        
        alteracaoLabel()
        
        customizacaoBotao.BordaBotao(botaoComprar)
        customizacaoBotao.BordaBotao(botaoVender)
        
        customizacaoView.BordaView(viewCambio)
        
        customizacaoQuantidade.BordaQuantidade(quantidadeTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    // MARK: - Alterando Labels
    func alteracaoLabel() {
        guard let moeda = moedaSelecionada,
              let carteira = carteira,
              let quantidadeDeMoedas = carteira.carteiraPessoal[siglaMoeda]  else {return}
        
        siglaNomeLabel.text = "\(siglaMoeda) - \(moeda.name)"
        
        variacaoLabel.text = moeda.variationString
        variacaoLabel.corLabel(variacaoPorcentagem: moeda.variation)  // Cor variação
        
        precoCompraLabel.text = ("Compra: " + moeda.compraString)
        
        precoVendaLabel.text = ("Venda: " + moeda.vendaString)
        
        saldoDisponivelLabel.text = ("Saldo disponível: \(carteira.saldoDisponivel)")
        
        moedaCaixaLabel.text = ("\(quantidadeDeMoedas) \(siglaMoeda) em caixa")
        
        disponibilidadeBotao(botaoComprar, carteira, moeda, iso: siglaMoeda)
        disponibilidadeBotao(botaoVender, carteira, moeda, iso: siglaMoeda)
        
        quantidadeTextField.text =  ""
    }
    // MARK: - Disponibilidade Botões (Habilitado / Desabilitado)
    
    func disponibilidadeBotao(_ botao: UIButton, _ carteira: Carteira, _ moeda: Currency, iso: String) {
        guard let moedaPrecoCompra = moeda.buy,
              let moedaEmCarteira = carteira.carteiraPessoal[iso],
              let stringQuantidadeTextField = quantidadeTextField.text else { return }
        
        var precoTotal = Double()
        var quantidadeInserida = Int()
        
        if let IntQuantidadeInserida = Int(stringQuantidadeTextField) {
            quantidadeInserida = IntQuantidadeInserida
            precoTotal = moedaPrecoCompra * Double(IntQuantidadeInserida)
        }
        if botao.tag == 1 { // Botão Comprar
            if (carteira.saldo < moedaPrecoCompra || carteira.saldo < precoTotal) {
                customizacaoBotao.BotaoDesabilitado(botaoComprar)
            } else {
                customizacaoBotao.BotaoHabilitado(botaoComprar)
            }
        } else {  // Botão Vender
            if (quantidadeInserida > moedaEmCarteira || moeda.sell == nil || moedaEmCarteira == 0) {
                customizacaoBotao.BotaoDesabilitado(botaoVender)
            } else {
                customizacaoBotao.BotaoHabilitado(botaoVender)
            }
        }
        if (stringQuantidadeTextField.isEmpty || quantidadeInserida <= 0) {
            customizacaoBotao.BotaoDesabilitado(botaoComprar)
            customizacaoBotao.BotaoDesabilitado(botaoVender)
        }
    }
    // MARK: - Botões Pressionados (Botões Comprar / Vender)
    
    @IBAction func BotoesPressionados(_ sender: UIButton) {
        guard let carteira = carteira,
              let moedaSelecionada = moedaSelecionada,
              let stringCampoQuantidade = quantidadeTextField.text,
              let campoQuantidade = Int(stringCampoQuantidade),
              let storyboard = storyboard,
              let MensagemViewController = storyboard.instantiateViewController(withIdentifier: "MensagemViewController") as? MensagemViewController,
              let navigationController = navigationController else {return}
        
        var acaoBotao: String
        var precoTransacao: String
        
        if sender.tag == 0 {
            guard let valorCompra = moedaSelecionada.buy else {return}
            acaoBotao = "Comprar"
            carteira.comprarVender(quantidade: campoQuantidade, sigla: siglaMoeda, valor: valorCompra, botaoTag: sender.tag, moeda: moedaSelecionada)
            precoTransacao = carteira.precoTotalCompraFormatado
        } else {
            guard let valorVenda = moedaSelecionada.sell else {return}
            acaoBotao = "Vender"
            carteira.comprarVender(quantidade: campoQuantidade, sigla: siglaMoeda, valor: valorVenda, botaoTag: sender.tag, moeda: moedaSelecionada)
            precoTransacao = carteira.precoTotalVendaFormatado
        }
        //Informações enviadas para a próxima tela.
        MensagemViewController.acaoBotaoMensagem = acaoBotao
        MensagemViewController.campoQuantidadeMensagem = campoQuantidade
        MensagemViewController.siglaMoedaMensagem = siglaMoeda
        MensagemViewController.moedaSelecionadaMensagem = moedaSelecionada
        MensagemViewController.precoTransacaoMensagem = precoTransacao
        
        MensagemViewController.title = acaoBotao.capitalized
        navigationController.pushViewController(MensagemViewController, animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        alteracaoLabel()
    }
}

extension CambioViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let moedaSelecionada = moedaSelecionada,
              let carteira = carteira else { return }
        
        disponibilidadeBotao(botaoComprar, carteira, moedaSelecionada, iso: siglaMoeda)
        disponibilidadeBotao(botaoVender, carteira, moedaSelecionada, iso: siglaMoeda)
    }
}

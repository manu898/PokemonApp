//
//  PokemonDetailView.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import Foundation
import UIKit

class PokemonDetailView: UIViewController {
    // TODO: controllare le funzioni decorate e mettere in Useful se servono in più file
    var realmManager: RealmManager?
    var pokemonName: String?
    var stats: [Stat] = []
    var abilities: [String] = []
    var img: UIImageView = UIImageView()
    
    var preferiti: UIViewController?
    
    lazy var pokemonNameLabel: UILabel = {
        let pokemonNameLabel = UILabel()
        pokemonNameLabel.text = pokemonName
        pokemonNameLabel.textAlignment = .center
        pokemonNameLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        return pokemonNameLabel
    }()
    
    lazy var addFavorite: UIButton = {
        let heartButton = UIButton()
        heartButton.tintColor = .red
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        if let realmManager = realmManager {
            if realmManager.favorites.contains(where: {$0.name == pokemonName}) {
                heartButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
                heartButton.addTarget(self, action: #selector(removeFromFavorite), for: .touchUpInside)
            } else {
                heartButton.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
                heartButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
            }
        }
        return heartButton
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        print("view dismessa")
        preferiti?.viewWillAppear(true)
    }
    
    @objc func removeFromFavorite() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        addFavorite.setImage(UIImage(systemName: "heart", withConfiguration: configuration), for: .normal)
        if let realmManager = realmManager {
            if let pokemonName = pokemonName {
                if realmManager.favorites.contains(where: {$0.name == pokemonName}){
                    let foo = realmManager.favorites.first(where: {$0.name == pokemonName})
                    realmManager.deletePokemonFromFavorites(id: foo!.id)
                    realmManager.pokemonDeletedFromFavs = pokemonName
                    print("Ho rimosso \(pokemonName) dai preferiti")
                    
                    var listaPreriti = [String]()
                    realmManager.favorites.forEach { poke in
                        listaPreriti.append(poke.name)
                    }
                    print("lista preferiti dopo la rimozione di \(pokemonName) è \(listaPreriti)") // lista preferiti di test
                    
                } else {
                    print("\(pokemonName) è già stato rimosso dai preferiti")
                }
            }
        }
    }

    @objc func addToFavorite() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 30)
        addFavorite.setImage(UIImage(systemName: "heart.fill", withConfiguration: configuration), for: .normal)
        if let realmManager = realmManager {
            if let pokemonName = pokemonName {
                if realmManager.favorites.contains(where: {$0.name == pokemonName}) {
                    print("\(pokemonName) è stato già aggiunto ai preferiti")
                }else {
                    realmManager.addPokemonToFavorites(name: pokemonName)
                    realmManager.newFavPokemon = pokemonName
                    print(realmManager.newFavPokemon)
                }
            }
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.contentMode = .scaleAspectFit
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
    private func setupViews() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(addFavorite)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
//        img.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        img.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        img.autoresizesSubviews = true
        stackView.addArrangedSubview(img)
        stackView.addArrangedSubview(pokemonNameLabel)
        abilitiesView(abilities: abilities)
        
        for stat in stats {
            let statRow = StatRow(name: stat.name, value: stat.value).statRow
            stackView.addArrangedSubview(statRow)
        }
    }
    
    func decorate(label: UILabel) -> UILabel {
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }
    
    func abilitiesView(abilities: [String]) {
        let stackViewAbilities = UIStackView()
        stackViewAbilities.spacing = 10
        stackViewAbilities.axis = .vertical
        stackViewAbilities.distribution = .fill
        let numberOfAbilities = abilities.count
        let numberOfRow = Int(numberOfAbilities/2)
        var i = 0
        if numberOfRow > 0 {
            for _ in 0..<Int(numberOfRow) {
                let abilitiesRow = AbilityRow(ability1: abilities[i], ability2: abilities[i+1]).abilityRow
                stackViewAbilities.addArrangedSubview(abilitiesRow)
                i = i+2
            }
        }
        if numberOfAbilities % 2 != 0 {
            var abilityLabel = UILabel()
            abilityLabel.translatesAutoresizingMaskIntoConstraints = false
            abilityLabel.text = abilities.last
            abilityLabel = decorate(label: abilityLabel)
            stackViewAbilities.addArrangedSubview(abilityLabel)
        }
        stackView.addArrangedSubview(stackViewAbilities)
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupViews()
        setupLayout()
    }
}

class StatRow: UIView {
    var name: String?
    var value: String?
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var statRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var nameLabel = UILabel()
        var valueLabel = UILabel()
        nameLabel.text = name
        valueLabel.text = value
        nameLabel = decorate(label: nameLabel)
        valueLabel = decorate(label: valueLabel)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(valueLabel)
        return stackView
    }()
    
    func decorate(label: UILabel) -> UILabel {
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return label
    }
}


class AbilityRow: UIView {
    var ability1: String
    var ability2: String
    
    
    init(ability1: String, ability2: String){
        self.ability1 = ability1
        self.ability2 = ability2
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var abilityRow: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var abilityLabel1 = UILabel()
        abilityLabel1.text = ability1
        abilityLabel1 = decorate(label: abilityLabel1)
        
        var abilityLabel2 = UILabel()
        abilityLabel2.text = ability2
        abilityLabel2 = decorate(label: abilityLabel2)
        
        stackView.addArrangedSubview(abilityLabel1)
        stackView.addArrangedSubview(abilityLabel2)
        return stackView
    }()
    
    func decorate(label: UILabel) -> UILabel {
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .gray
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return label
    }
}

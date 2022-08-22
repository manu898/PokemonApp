//
//  Favorites.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import UIKit
import Foundation

class Preferiti: UIViewController{
    
    var realmManager: RealmManager?
    var buttonList: [(PokemonButton,Int)] = []
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let realmManager = realmManager {
            let newFavPokemon = realmManager.newFavPokemon
            if newFavPokemon != "" {
                if !buttonList.contains(where: {$0.0.title == newFavPokemon}) {
                    realmManager.newFavPokemon = ""
                    let imageURL = APICaller.shared.getPokemonImageURL(name: newFavPokemon)
                    let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                    print("realizzo il bottone per \(newFavPokemon)")
                    let button = PokemonButton(title: newFavPokemon, imageView: imageView)
                    let btn = button.button
                    let numOfButton = buttonList.count
                    btn.tag = numOfButton + 200
                    buttonList.append((button,btn.tag))
                    btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                    stackView.addArrangedSubview(btn)
                    print("button list dopo dell'operazione = \(buttonList)")
                    
                }
            }
            if realmManager.pokemonDeletedFromFavs == true {
                removeAllSubviews(sV: stackView)
                setup()
                realmManager.pokemonDeletedFromFavs = false
            }
        }
    }
    
    func removeAllSubviews(sV: UIStackView){
        sV.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        buttonList.removeAll()
    }
    
    // da testare
    func removeSubview(pokemonName: String) {
        print("buttonList dentro removeSub = \(buttonList)")
        buttonList.forEach { poke in
            print("pokemonName foreach = \(String(describing: poke.0.title))")
            if poke.0.title == pokemonName {
                let viewToRemove = view.viewWithTag(poke.1)
                printContent("view da rimuovere = \(String(describing: viewToRemove))")
                viewToRemove?.removeFromSuperview()
            }
        }
    }
    
    private func setup() {
        if let realmManager = realmManager {
            for (n,poke) in realmManager.favourites.enumerated(){
                //print("controllo se posso aggiungere \(poke.name) e n = \(n)")
                if !buttonList.contains(where: {$0.0.title == poke.name}) {
                    //print("button list non contiene \(poke.name) e n = \(n)")
                    let imageURL = APICaller.shared.getPokemonImageURL(name: poke.name)
                    let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                    let button = PokemonButton(title: poke.name, imageView: imageView)
                    let btn = button.button
                    btn.tag = n+200
                    print("tag \(btn.tag) per \(poke.name)")
                    buttonList.append((button,btn.tag))
                    btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                    stackView.addArrangedSubview(btn)
                } else {
                    //print("button list contiene \(poke.name) e n = \(n)")
                }
            }
        }
        print("sto in setup e buttonListPreriti = \(buttonList)")
    }
    
    @objc
    func tap(sender: UIButton){
        let pokemonName = buttonList[sender.tag-200].0.title
        print("pokemonName = \(pokemonName!)")
        let result = APICaller.shared.getPokemon(name: pokemonName!)
        let imageURL = APICaller.shared.getPokemonImageURL(name: pokemonName!)
        let imageView = APICaller.shared.getPokemonImage(url: imageURL)
        let abilities = result.0
        let stats = result.1
        let controller = PokemonDetailView()
        controller.img = imageView
        controller.pokemonName = pokemonName
        controller.preferiti = self
        controller.realmManager = realmManager
        controller.stats = stats
        controller.abilities = abilities
        present(controller, animated: true, completion: nil)
    }
    
    private func setupViews() {
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setup()
    }
    
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
}

//
//  Favorites.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import UIKit
import Foundation

class Preferiti: UIViewController{
    //TODO: modificare Preferiti in Favorite
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
                print("entro dentro perchè newFav è qualcosa")
                if !buttonList.contains(where: {$0.0.title == newFavPokemon}) {
                    realmManager.newFavPokemon = ""
                    let imageURL = APICaller.shared.getPokemonImageURL(name: newFavPokemon)
                    let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                    let button = PokemonButton(title: newFavPokemon, imageView: imageView)
                    let btn = button.button
                    let numOfButton = buttonList.count // togliere sta costante
                    btn.tag = numOfButton + 200
                    print("creo bottone per \(newFavPokemon) con tag \(btn.tag)")
                    buttonList.append((button,btn.tag))
                    btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                    stackView.addArrangedSubview(btn)
                    
                }
            }
            if realmManager.pokemonDeletedFromFavs != "" {
                print("entro dentro perchè deletedFav è qualcosa")
                removeSubview(pokemonName: realmManager.pokemonDeletedFromFavs)
                realmManager.pokemonDeletedFromFavs = ""
            }
            print("buttonList dopo viewWillAppear = \(buttonList)")
        }
    }
    
    func removeAllSubviews(sV: UIStackView){
        sV.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        buttonList.removeAll()
    }
    
    func removeSubview(pokemonName: String) {
        buttonList.forEach { poke in
            if poke.0.title == pokemonName {
                let viewToRemove = stackView.viewWithTag(poke.1)
                let indexOfButton = buttonList.firstIndex(where: {$0.0.title == pokemonName})
                buttonList[indexOfButton!].0.title = "Eliminato"
                print("buttonList dopo la removeSubview \(buttonList)")
                viewToRemove?.removeFromSuperview()
            }
        }
    }
    
    private func setup() {
        if let realmManager = realmManager {
            for (n,poke) in realmManager.favorites.enumerated(){
                print("n = \(n) e pokemon = \(poke)")
                if !buttonList.contains(where: {$0.0.title == poke.name}) {
                    let imageURL = APICaller.shared.getPokemonImageURL(name: poke.name)
                    let imageView = APICaller.shared.getPokemonImage(url: imageURL)
                    let button = PokemonButton(title: poke.name, imageView: imageView)
                    let btn = button.button
                    btn.tag = 200 + buttonList.count // aggiunto buttonlist.count e rimosso n
                    print("creo il bottone per \(poke.name) con tag \(btn.tag)")
                    buttonList.append((button,btn.tag))
                    btn.addTarget(self, action: #selector(tap), for: .touchUpInside)
                    stackView.addArrangedSubview(btn)
                }
            }
        }
        print("buttonList dopo setup = \(buttonList)")
    }
    
    @objc
    func tap(sender: UIButton){
        print("buttonList \(buttonList) ") // ha rimosso il bottone pokemon aggiunto e rimosso dalla buttonList, perchè ?
        let indexPokemon = buttonList.firstIndex(where: {$0.1 == sender.tag})
        print("index = \(indexPokemon)")
        let pokemonName = buttonList[indexPokemon!].0.title
        //let pokemonName = buttonList[sender.tag-200].0.title // da correggere indice
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

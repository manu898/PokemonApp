//
//  ViewController.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import UIKit
import SwiftyJSON


class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    var realmManager: RealmManager = RealmManager()
    var favorites: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let pokemonList = PokemonList()
        let favoriteList = Favorites()
        pokemonList.realmManager = realmManager
        favoriteList.realmManager = realmManager
        favorites = favoriteList
        pokemonList.favorites = favorites
        let pokemon = generateNavController(vc: pokemonList, title: "Pokemon")
        let preferiti = generateNavController(vc: favoriteList, title: "Preferiti")
        pokemon.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        preferiti.tabBarItem.image = UIImage(systemName: "star.fill")
        tabBar.tintColor = .label
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [pokemon,preferiti]
        self.delegate = self
    }
    
    fileprivate func generateNavController(vc: UIViewController, title: String) -> UINavigationController{
        vc.navigationItem.title = title
        let navController = UINavigationController(rootViewController: vc)
        navController.title = title
        return navController
    }
}


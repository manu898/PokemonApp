//
//  RealmManager.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var favorites: [FavouritePokemon] = []
    @Published var newFavPokemon: String = ""
    @Published var pokemonDeletedFromFavs: String = ""
    
    init(){
        openRealm()
        getFavorites()
    }
    
    func openRealm() {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addPokemonToFavorites(name: String){
        if let localRealm = localRealm {
            do{
                try localRealm.write {
                    let newPokemon = FavouritePokemon(value: ["name": name])
                    localRealm.add(newPokemon)
                    getFavorites()
                }
            } catch {
                print("Error in add pokemon ro realm: \(error)")
            }
        }
    }
    
    func getFavorites(){
        if let localRealm = localRealm {
            let allFavourites = localRealm.objects(FavouritePokemon.self)
            favorites = []
            allFavourites.forEach { favs in
                favorites.append(favs)
            }
            favorites = favorites.reversed()
        }
    }
    
    func deletePokemonFromFavorites(id: ObjectId){
        if let localRealm = localRealm {
            do {
                let pokemonToDelete = localRealm.objects(FavouritePokemon.self).where {$0.id == id}
                try localRealm.write {
                    localRealm.delete(pokemonToDelete)
                    getFavorites()
                }
            } catch {
                print("Error deleting task \(id) from Realm: \(error)")
            }
        }
    }
}


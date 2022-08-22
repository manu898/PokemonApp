//
//  FavoritePokemon.swift
//  PokemonApp
//
//  Created by Manuel Caparrelli on 22/08/22.
//

import Foundation
import RealmSwift
import UIKit

class FavouritePokemon: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name = ""
}


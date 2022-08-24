# PokemonApp

## Descrizione

Una semplice applicazione in cui possiamo visualizzare le varie statistiche dei pokemon messi a disposizione dall'applicazione.
Ogni pokemon può essere aggiunto ad una lista dei preferiti visualizzabile tramite la relativa schermata presente nell'app.

## Installazione
Per la realizzazione di questa applicazione sono stai utilizzati i seguenti framework: 
* RealmSwift per la creazione di un database locale;
* SwiftyJSON per effettuare le richieste HTTP.

Per una corretta esecuzione è neccessario installare i framework sopracitati.

## Utilizzo
L'applicazione presenta 3 schermate:
* una schermata che mostra la lista dei pokemon messi a disposizione;
* una schermata che mostra la lista dei pokemon selezionari come preferiti dall'utente.
* una schermata di dettaglio che mostra le statistiche e le abilità del pokemon selezionato tramite il relativo bottone presente nella prima schermata.

## Struttura del progetto

### ViewController.swift
Presenta una classe ViewController che è una sottoclasse di UITabBarController e conforme al protocollo UITabBarControllerDelegate.
In questa classe viene creato un oggetto della classe PokemonList dichiarata nel file PokemonList.swift e un oggetto della classe Favorites dichiarata
nel file Favorites.swift. Questi due oggetti una volta creati vengono passati alla funzione generateNavController per la generazione di oggetti
di tipo UINavigationController per poi essere assegnati come viewControllers della classe ViewController.

### PokemonList.swift


### Favorites.swift


### PokemonDetailView.swift


### RealmManager.swift


### APICaller.swift


### FavoritePokemon.swift


### Useful.swift
Presenta una estensinsione della classe UIImage 




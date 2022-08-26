# PokemonApp

## Descrizione

Una semplice applicazione in cui possiamo visualizzare le abilità e le statistiche dei pokemon messi a disposizione dall'applicazione.
Ogni pokemon può essere aggiunto ad una lista dei preferiti visualizzabile tramite la relativa schermata presente nell'app.

## Installazione
Per la realizzazione di questa applicazione sono stai utilizzati i seguenti framework: 
* RealmSwift per la creazione di un database locale;
* SwiftyJSON per effettuare le richieste HTTP.

Per una corretta esecuzione è neccessario installare i framework sopraccitati.

## Utilizzo
L'applicazione presenta 3 schermate:
* Una schermata che mostra la lista dei pokemon messi a disposizione;
* Una schermata che mostra la lista dei pokemon selezionati come preferiti dall'utente;
* Una schermata di dettaglio che mostra le statistiche e le abilità del pokemon selezionato tramite il relativo bottone presente nella prima schermata.

## Struttura del progetto

### ViewController.swift
Presenta la classe ViewController che è una sottoclasse di UITabBarController e conforme al protocollo UITabBarControllerDelegate.
In questa classe viene creato un oggetto della classe PokemonList dichiarata nel file PokemonList.swift e un oggetto della classe Favorites dichiarata
nel file Favorites.swift. Questi due oggetti una volta creati vengono passati alla funzione **generateNavController(vc: UIViewController, title: String)** per la generazione di oggetti di tipo UINavigationController per poi essere assegnati come viewControllers della classe ViewController.


### PokemonList.swift
Presenta la classe PokemonList che è una sottoclasse di UIViewController e la classe PokemonButton che è una sottoclasse di UIView.
Nella classe PokemonList viene creato un oggetto della classe UIScrollView nel quale viene inserito un oggetto di tipo UIView che a sua volta contiene
un oggetto della classe UIStackView. Quest'ultima sarà il contenitore dei bottoni relativi ad ogni pokemon richiesto tramite la richiesta HTTP fatta utilizzando la funzione **getPokemonList(numPokemon: Int)** della classe APICaller. I bottoni presenti nella view associata a questa classe vengono realizzati tramite la classe **PokemonButton** presente sempre in questo file.


### Favorites.swift
Presenta la classe Favorites che è una sottoclasse di UIViewController.
Nella classe Favorites viene creato un oggetto della classe UIScrollView nel quale viene inserito un oggetto di tipo UIView che a sua volta contiene
un oggetto della classe UIStackView. Quest'ultima sarà il contenitore dei bottoni relativi ad ogni pokemon contenuto nella lista dei preferiti presente nella variabile **favorites** della classe **RealManager** dichiarata nel file **RealmManager.swift**. I bottoni presenti nella view associata a questa classe vengono realizzati tramite la classe **PokemonButton** presente nel file **PokemonList.swift**.
In questa classe viene anche fatto l'override della funzione **viewWillAppear(animated: Bool)** che ogni volta che la view associata alla classe verrà
visualizzata, si occuperà di verificare se è stato aggiunto o rimosso un nuovo pokemon dalla lista dei preferiti e di operare di conseguenza sulla lista dei bottoni presenti nella schermata. 


### PokemonDetailView.swift
Presenta le seguenti classi:
* La classe PokemonDetailView che è una sottoclasse di UIViewController;
* La classe AbilityRow che è una sottoclasse di UIView;
* La classe StatRow che è una sottoclasse di UIView.

La classe PokemonDetailView si occupa della creazione di un oggetto della classe UIScrollView che contiene un oggetto della classe UIStackView. Un oggetto della classe PokemonDetailView viene creato ogni volta che l'utente seleziona un determinato pokemon della lista dei pokemon recuperata tramite la funzione **getPokemonList(numPokemon: Int)** della classe **APICaller** richiamata nella classe **PokemonList** oppure quando si seleziona un pokemon presente nella schermata dei preferiti data dalla classe **Favorites**.

La UIStackView contiene:
* un bottone per aggiungere o rimuovere il pokemon selezionato dalla lista dei preferiti;
* L'immagine in formato png legata al pokemon selezionato;
* L'insieme delle abilità relative al pokemon selezionato;
* L'insieme della statistiche relative al pokemon selezionato.


### RealmManager.swift
Presenta la classe RealmManager che è conforme al protocollo ObservableObject.
In questa classe sono implementate le seguenti funzioni:
* **openRealm()** che si occupa della configurazione iniziale della tabella che utilizzeremo per la memorizzazione della lista dei pokemon preferiti nel database locale Realm;
* **addPokemonToFavorite(name: String)** che aggiunge alla tabella il pokemon associato al valore di tipo String passato in input alla funzione;
* **getFavorite()** che recupera la lista dei pokemon presenti nella tabella situata nel database;
* **deletePokemonFromFavorite(id: ObjectId)** che si occupa di eliminare dalla tabella il pokemon associato al valore di tipo ObjectId passato
in input alla funzione.


### APICaller.swift
Presenta la classe APICaller, la struct Pokemon per ogni pokemon da rappresentare nell'applicazione, la struct Pokemons per la risposta alla richiesta della lista dei pokemon al database e la struct Stat per le statistiche di ogni Pokemon ricevuto dal database.
Nella classe APICaller sono implementate le seguenti funzioni:
* **getPokemonList(numPokemon: Int)** che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/" e restituisce un array di oggetti di tipo Pokemon lunga quanto il valore intero passato in input alla funzione. 
* **getPokemon(name: String)** che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/{name}" e restituisce le statistiche e le abilità del pokemon relativo al valore di tipo String passato in input alla funzione;
* **getPokemon(id: Int)** che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/{id}" e restituisce le statistiche e le abilità del pokemon relativo al valore di tipo Int passato in input alla funzione;
* **getAbilities(data: Data)** che prende il contenuto della risposta alla richiesta HTTP fatta in **getPokemon(name: String)** e restituisce le abilità associate al pokemon;
* **getStats(data: Data)** che prende il contenuto della risposta alla richiesta HTTP fatta in **getPokemon(name: String)** e restituisce le statistiche associate al pokemon;
* **getPokemonImageURL(name: String)** che restituisce la url dove richiedere l'immagine in formato png del pokemon associato alla variabile di tipo stringa passata in input alla funzione;
* **getPokemonImage(url: String)** che restituisce un oggetto della classe UIImageView nel quale è contenuta l'immagine in formato png del pokemon associato alla url passata in input alla funzione.


### FavoritePokemon.swift
Presenta la classe FavoritePokemon che è conforme al protocollo ObjectKeyIdentifiable.
Questa classe è costituita da due variabili: 
* Una variabile id impostata come primary key della tabella che si andrà a creare nel database locale Realm;
* Una variabile name di tipo String che andrà a contenere il nome del pokemon che si vuole inserire nella tabella.


### Useful.swift
Presenta una estensione della classe UIImage nella quale viene dichiarata la funzione **scalePreservingAspectRatio(targetSize: CGSize)** che dato un oggetto della classe CGSize restituisce un oggetto della classe UIImage delle dimensioni specificate nell'oggetto passato in input alla funzione.




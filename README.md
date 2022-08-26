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
* Una schermata che mostra la lista dei pokemon messi a disposizione;
* Una schermata che mostra la lista dei pokemon selezionati come preferiti dall'utente;
* Una schermata di dettaglio che mostra le statistiche e le abilità del pokemon selezionato tramite il relativo bottone presente nella prima schermata.

## Struttura del progetto

### ViewController.swift
Presenta la classe ViewController che è una sottoclasse di UITabBarController e conforme al protocollo UITabBarControllerDelegate.
In questa classe viene creato un oggetto della classe PokemonList dichiarata nel file PokemonList.swift e un oggetto della classe Favorites dichiarata
nel file Favorites.swift. Questi due oggetti una volta creati vengono passati alla funzione generateNavController per la generazione di oggetti
di tipo UINavigationController per poi essere assegnati come viewControllers della classe ViewController.

### PokemonList.swift
Presenta la classe PokemonList che è una sottoclasse di UIViewController e la classe PokemonButton che è una sottoclasse di UIView.
Nella classe PokemonList viene creato un oggetto della classe UIScrollView nel quale 


### Favorites.swift
Presenta la classe Favorite che è una sottoclasse di UIViewController.


### PokemonDetailView.swift
Presenta le seguenti classi:
* La classe PokemonDetailView che è una sottoclasse di UIViewController;
* La classe AbilityRow che è una sottoclasse di UIView;
* La classe StatRow che è una sottoclasse di UIView.



### RealmManager.swift
Presenta la classe RealmManager che è conforme al protocollo ObservableObject.


### APICaller.swift
Presenta la classe APICaller, la struct Pokemon per ogni pokemon da rappresentare nell'applicazione, la struct Pokemons per la risposta alla richiesta della lista dei pokemon al database e la struct Stat per le statistiche di ogni Pokemon ricevuto dal database.
Nella classe APICaller sono implementate le seguenti funzioni:
* ''' swift getPokemonList(numPokemon: Int) ''' che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/" e restituisce una lista di oggetti di tipo Pokemon lunga quanto il valore intero passato in input alla funzione. 
* ''' swift getPokemon(name: String) ''' che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/{name}" e restituisce le statistiche e le abilità del pokemon relativo al valore di tipo String passato in input alla funzione;
* ''' swift getPokemon(id: Int) ''' che effettua una richiesta HTTP alla url "https://pokeapi.co/api/v2/pokemon/{id}" e restituisce le statistiche e le abilità del pokemon relativo al valore di tipo Int passato in input alla funzione;
* getAbilities(data: Data) che prende il contenuto della risposta alla richiesta HTTP fatta in getPokemon(name: String) e restituisce le statistiche associate al pokemon;
* getStats(data: Data) che prende il contenuto della risposta alla richiesta HTTP fatta in getPokemon(name: String) e restituisce le abilità associate al pokemon;
* getPokemonImageURL(name: String) che restituisce la URL dove richiedere l'immagine in formato png del pokemon associato alla variabile di tipo stringa passata in input alla funzione;
* getPokemonImage(url: String) che restituisce un oggetto della classe UIImageView nel quale è contenuta l'immagine in formato png del pokemon associato alla url passata in input alla funzione.


### FavoritePokemon.swift
Presenta la classe FavoritePokemon che è conforme al protocollo ObjectKeyIdentifiable.
Questa classe è costituita da due variabili: 
* Una variabile id impostata come primary key dello schema che si andrà a creare nel database locale;
* Una variabile name di tipo Stringa che andrà a contenere il nome del pokemon che si vuole inserire nello schema.


### Useful.swift
Presenta una estensione della classe UIImage nella quale viene dichiarata la funzione scalePreservingAspectRatio che dato un oggetto della classe CGSize restituisce un oggetto della classe UIImage delle dimensioni specificate nell'oggetto passato in input alla funzione.





//pruebo
import UIKit

class SearchLocationTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var pokemons: [Pokemon?] = []
    var connection = Connection()
    var MAX_POKEMONS = 183
    var filteredData : [Pokemon?] = []
    var pokemonsDownload = 0
    
    let searchController = UISearchController()
    
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //searchBar.placeholder = "Introduce localización"
       // searchBar.showsScopeBar = false
        //searchBar.delegate = self
        filteredData = pokemons
        setupSearch()

        
        
        
        
        pokemons = [Pokemon?] (repeating: nil, count: MAX_POKEMONS)
        
        //Se recorre el array hasta el numero de la variable Max_Pokemons recogiendo el contenido haciendo conexion con la API
        for i in 1...MAX_POKEMONS{
            connection.getPokemon(withID: i) { pokemon in
                self.pokemonsDownload += 1
                if let pokemon = pokemon, let id = pokemon.id{
                    self.pokemons[id-1] = pokemon
                }
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //Configuracion de la barra de busqueda
    func setupSearch(){
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Introduce ubicación"
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let pokemon = filteredData[indexPath.row]
        cell.textLabel?.text = pokemon?.name ?? ""
        //cell.textLabel?.text = String(pokemon?.height ?? 3)
        
        return cell
    }
    
    /*
    //Barra de busqueda que filtra los resultados buscando coincidencias entre los datos y lo escrito
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if pokemonsDownload == MAX_POKEMONS {
            filteredData = pokemons.filter({ pokemon -> Bool in
                guard let text = searchBar.text else { return false }
                return pokemon!.name.lowercased().contains(text.lowercased())
            }).sorted(by: { (item1, item2) -> Bool in
                return item1!.name.compare(item2!.name) == ComparisonResult.orderedAscending
            })
        }
        
        tableView.reloadData()
    }
 */
    
    func updateSearchResults(for searchController: UISearchController) {
        if pokemonsDownload == MAX_POKEMONS {
            filteredData = pokemons.filter({ pokemon -> Bool in
                guard let text = searchController.searchBar.text else { return false }
                return pokemon!.name.lowercased().contains(text.lowercased())
            }).sorted { $0!.name < $1!.name }
        }
        tableView.reloadData()
        
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Variable de tipo ViewController
        let nextViewController: DetalleViewController = segue.destination as! DetalleViewController
        
        //Variable que recoge el index de la celda que se pulsa en la tabla
        let indexPath = self.tableView.indexPathForSelectedRow
        let pokemon = filteredData[indexPath!.row]
        
        nextViewController.infectionsNumber = pokemon?.height
        nextViewController.locationSelected = pokemon?.name
        nextViewController.locationIsSelected = true
        
    }
}


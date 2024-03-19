//
//  ViewController.swift
//  AppNews
//
//  Created by Victor ulises Vazquez arriaga on 04/03/24.
//

import UIKit
import SafariServices




class ViewController: UIViewController {
    
    var articuloDeNoticias : [Noticia] = []
    
    @IBOutlet weak var tablaNoticias: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Registro de nueva celda
        
        tablaNoticias.register(UINib(nibName: "CeldaNoticiaTableViewTableViewCell", bundle: nil), forCellReuseIdentifier: "celdaNoticia")
        tablaNoticias.delegate = self
        tablaNoticias.dataSource = self
        
        bucarNoticiasDos ()
    
    }
    
    func bucarNoticiasDos ()  {
        
        let urlString = URL(string: "https://saurav.tech/NewsAPI/top-headlines/category/health/in.json")!
        let url = URLSession.shared.dataTask(with: urlString){ [weak self] (data, response, error) in
            if error != nil {
                print("No puedo mostrar la pagina, surgio un error en el servidor")
                return
            }
            guard let httpReponse = response as? HTTPURLResponse, (200...299).contains(httpReponse.statusCode) else {
                print("No puedo mostrar la pagina, surgio un error en el servidor")
                return
            }
            guard let data = data else {
                print ("no se recibieron datos")
                return
            }
            do{
                let decoder = JSONDecoder ()
                let NoticiasModelo = try decoder.decode(NoticiasModelo.self, from: data)
                
                DispatchQueue.main.async {
                    self?.articuloDeNoticias = NoticiasModelo.articles
                    self?.tablaNoticias.reloadData()
                }
                
            } catch  {
                print ("Error al decodificar")
            }
        }
        url.resume()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articuloDeNoticias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tablaNoticias.dequeueReusableCell(withIdentifier: "celdaNoticia", for: indexPath) as! CeldaNoticiaTableViewTableViewCell
        
        celda.tituloNoticiaLabel.text = articuloDeNoticias[indexPath.row].title
        celda.descriptionNoticiaLabel.text = articuloDeNoticias[indexPath.row].description
        
        
        if let urlStringImage = URL(string: articuloDeNoticias[indexPath.row].urlToImage ?? "") {
            let urlImage = URLSession.shared.dataTask(with: urlStringImage) {(data, response, error) in
                
                if error != nil {
                    print ( "No se puede mostrar la imagen que proviene del servidor")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print ("No se recibieon datos como image")
                    return
                }
                guard let data = data else {
                    print ("No se recibieon datos como image")
                    return
                }
                DispatchQueue.main.async {
                    celda.imageNoticiaIV.image = UIImage(data: data)
                }
            }
            urlImage.resume()
        }
        return celda
    }
    
    // propiedad que funciona cuando un usuario selecciona una celda para ir a otra celda
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tablaNoticias.deselectRow(at: indexPath, animated: true)
        
        guard let urlMostrar = URL(string: articuloDeNoticias[indexPath.row].url ?? "") else { return }
        let safariViewController = SFSafariViewController(url: urlMostrar)
        safariViewController.delegate = self
        
        
        // Se abre clousure para crear dentro de este mismo una nueva variable para crear un nuevo view controller,
        // que esta misma contiene propiedas
        present(safariViewController, animated: true) {
            
            
            let viewController = UIViewController ()
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            viewController.view.backgroundColor = .white.withAlphaComponent(0.3)
            // Mostrar indicador de actividad
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = viewController.view.center
            activityIndicator.startAnimating()
            viewController.view.addSubview(activityIndicator)
            safariViewController.present(viewController, animated: true)
        }
        
        
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
        controller.dismiss(animated: true)
    }
}

   

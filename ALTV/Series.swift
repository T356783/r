//
//  Series.swift
//  ALTV
//
//  Created by Alan Olivares on 23/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit

class Series: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var seriesOb = [SerieObjeto]()
    
    @IBOutlet var tableViewSe: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSe.dataSource = self
        tableViewSe.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let urlString = "https://pastebin.com/raw/Z1tkhQRm"
        let url = URL(string: urlString)
        
        let peticion = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if(error != nil){
                print("Error: \(String(describing: error))")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String: AnyObject]]
                    for user in json{
                        let nombre = user["nombre"] as! String
                        let imagen = user["imagen"] as! String
                        let capitulos = user["capitulos"] as! [String: AnyObject]
                        let capitulo = capitulos["capitulo"] as! [String]
                        let links = capitulos["link"] as! [String]
                        self.seriesOb.append(SerieObjeto(name: nombre, imagen: imagen, capitulo: capitulo, link:links ))
                    }
                    OperationQueue.main.addOperation({
                        self.tableViewSe.reloadData()
                    })
                    
                } catch let error as NSError{
                    print(error)
                }
            }
        }
        
        peticion.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesOb.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom3", for: indexPath) as! Serie
        let urlString = seriesOb[indexPath.row].imagen //Lista con las URLs
        let url = NSURL(string: urlString)!
        let data = NSData(contentsOf: url as URL)
        cell.imagen.image=UIImage(data: data! as Data)
        cell.numero.text=String (indexPath.row+1)
        cell.nombre.text=seriesOb[indexPath.row].name
        
        return cell
    }
    var x=0
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        x=indexPath.row
        self.performSegue(withIdentifier: "pasoserie", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! Capitulos
        DestViewController.paso = seriesOb
        DestViewController.va = x
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class SerieObjeto{
    var name: String
    var imagen: String
    var capitulo: [String]
    var link: [String]
    init(name: String,imagen: String, capitulo: [String],link :[String]) {
        self.name = name
        self.imagen = imagen
        self.capitulo = capitulo
        self.link = link
    }
    
}
class Serie:UITableViewCell{
    
    @IBOutlet var nombre: UILabel!
    @IBOutlet var imagen: UIImageView!
    
    @IBOutlet var numero: UILabel!
    
}

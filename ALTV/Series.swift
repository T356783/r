//
//  Series.swift
//  ALTV
//
//  Created by Alan Olivares on 23/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit

class Series: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var seriesOb = [SerieObjeto]()
    var seriesMos = [SerieMos]()
    var currenSeries = [SerieMos]()
    @IBOutlet var searchBarSer: UISearchBar!
    @IBOutlet var tableViewSe: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSe.dataSource = self
        tableViewSe.delegate = self
        searchBarSer.delegate = self
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let myURLString = "here edit your source with your own m3u"
        if let myURL = NSURL(string: myURLString) {
            do {
                let myHTMLString = try NSString(contentsOf: myURL as URL, encoding: String.Encoding.utf8.rawValue)
                extractChannelsFromRawString(myHTMLString as String)
            } catch {
                print(error)
            }
        }
        mostrarSerie()
        currenSeries = seriesMos
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom3", for: indexPath) as! Serie
        let urlString = currenSeries[indexPath.row].imagen //Lista con las URLs
        if urlString != ""{
            let url = URL(string: urlString)!
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data as Data) {
                        DispatchQueue.main.async {
                            cell.imagen.image=image
                        }
                    }
                }
            }
        }
        cell.nombre.text=currenSeries[indexPath.row].name
        
        return cell
    }
    var x=""
    var imagen = ""
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        x=currenSeries[indexPath.row].name
        imagen = currenSeries[indexPath.row].imagen
        self.performSegue(withIdentifier: "pasoserie", sender: self)
        
    }
    func mostrarSerie(){
        var bol = false
        for objeto in seriesOb{
            let ini = objeto.name
            for series in seriesMos{
                if ini==series.name{
                    bol = true
                }
            }
            if bol == false{
                seriesMos.append(SerieMos(name: ini, imagen: objeto.imagen))
            }
            bol = false
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currenSeries = seriesMos
            tableViewSe.reloadData()
            return
        }
        currenSeries = seriesMos.filter({serie -> Bool in
            serie.name.lowercased().contains(searchText.lowercased())
        })
        tableViewSe.reloadData()
    }
    func extractChannelsFromRawString(_ string: String) {
        var namee = ""
        var namee2 = ""
        var linkIm2 = ""
        var linkIm3 = ""
        var capitulos = ""
        var val = ""
        string.enumerateLines { line, shouldStop in
            if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infoItems = infoLine.components(separatedBy: ",")
                if let title = infoItems.last{
                    capitulos = title
                }
            }
            if line.hasPrefix("#EXTINF:"){
                let val2 = line.components(separatedBy: "=")
                let sep1 = val2[1]
                let indexStartOfText = sep1.index(sep1.startIndex, offsetBy: 1)
                linkIm2 = String(sep1[indexStartOfText...])
                let indexEndOfText = linkIm2.index(linkIm2.endIndex, offsetBy: -13)
                linkIm3 = String(linkIm2[..<indexEndOfText])
                //print(linkIm3)
                val = val2[2]
                let sep3 = val.components(separatedBy: ",")
                let sep2 = sep3[0]
                //print(sep2)
                let indexStartOfText2 = sep2.index(sep2.startIndex, offsetBy: 1)
                namee = String(sep2[indexStartOfText2...])
                let indexEndOfText2 = namee.index(namee.endIndex, offsetBy: -1)
                namee2 = String(namee[..<indexEndOfText2])
            }else {
                if line.hasPrefix("http"){
                    self.seriesOb.append(SerieObjeto(name: namee2, imagen: linkIm3, capitulo: capitulos, link: line))
                    linkIm3 = ""
                }
            }
        }
        //self.tableViewSe.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DestViewController = segue.destination as! Capitulos
        DestViewController.paso = seriesOb
        DestViewController.va = x
        DestViewController.imageSe = imagen
    }
}
class SerieObjeto{
    var name: String
    var imagen: String
    var capitulo: String
    var link: String
    init(name: String,imagen: String, capitulo: String,link :String) {
        self.name = name
        self.imagen = imagen
        self.capitulo = capitulo
        self.link = link
    }
    
}
class Serie:UITableViewCell{
    
    @IBOutlet var nombre: UILabel!
    @IBOutlet var imagen: UIImageView!
    
}
class SerieMos {
    var name : String
    var imagen : String
    init(name: String,imagen: String) {
        self.name = name
        self.imagen = imagen
    }
}

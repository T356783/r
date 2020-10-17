//
//  Canales.swift
//  ALTV
//
//  Created by Alan Olivares on 23/09/18.
//  Copyright © 2018 Alan Olivares. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
class Canales: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var canalesOb = [CanalObjeto]()
    var currentCan = [CanalObjeto]()
    var canalO: CanalObjeto?
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpSearchBar()
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
        currentCan = canalesOb
        
    }
    private func setUpSearchBar(){
    searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            currentCan = canalesOb
            tableView.reloadData()
            return
        }
        currentCan = canalesOb.filter({canal -> Bool in
            canal.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! Canal
        let urlString = currentCan[indexPath.row].imagen //Lista con las URLs
        var url = URL(string: "")
        if urlString != ""{
            url = URL(string: urlString)!
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data as Data) {
                        DispatchQueue.main.async {
                            cell.imagee.image=image
                            //cell.numero.text=String (indexPath.row+1)
                            //cell.nombre.text=self?.currentPeli[indexPath.row].name
                        }
                    }
                }
            }
        }else{
            cell.imagee.image = UIImage(named: "canal")!
        }
        
        cell.number.text=String (indexPath.row+1)
        cell.nombreCa.text=currentCan[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoURL = URL(string: currentCan[indexPath.row].link)
        print(currentCan[indexPath.row].link)
         let player = AVPlayer(url: videoURL!)
         let playerViewController = LandscapeAVPlayerController()
         playerViewController.player = player
         self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
         }
        
    }
    func extractChannelsFromRawString(_ string: String) {
        var namee = ""
        var linkIm2 = ""
        var linkIm3 = ""
        string.enumerateLines { line, shouldStop in
            if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infoItems = infoLine.components(separatedBy: ",")
                if let title = infoItems.last {
                    namee = title
                }
            }
                if line.hasPrefix("#EXTINF:-1"){
                    let val2 = line.components(separatedBy: " ")
                    for sep in val2{
                        if sep.hasPrefix("tvg-logo="){
                            let sep2 = sep.components(separatedBy: ",")
                            let sep1 = sep2[0]
                            let indexStartOfText = sep1.index(sep1.startIndex, offsetBy: 10)
                            linkIm2 = String(sep1[indexStartOfText...])
                            let indexEndOfText = linkIm2.index(linkIm2.endIndex, offsetBy: -1)
                            linkIm3 = String(linkIm2[..<indexEndOfText])
                        }
                    }
            }else {
                if line.hasPrefix("http"){
                    self.canalesOb.append(CanalObjeto(name: namee, imagen: linkIm3, link: line))
                    linkIm3 = ""
                }
            }
        }
        self.tableView.reloadData()
    }

}
class Canal:UITableViewCell{
    @IBOutlet var nombreCa: UILabel!
    
    @IBOutlet var number: UILabel!
    
    @IBOutlet var imagee: UIImageView!
}

class CanalObjeto{
    var name: String
    var imagen: String
    var link: String
    init(name: String,imagen: String, link: String) {
        self.name = name
        self.imagen = imagen
        self.link = link
    }
}

//
//  EpisodioTableViewController.swift
//  DoctorApp
//
//  Created by Felipe Macbook Pro on 5/21/15.
//  Copyright (c) 2015 Felipe-Otalora. All rights reserved.
//

import UIKit
import AVFoundation

class EpisodioTableViewController: UITableViewController {

    var episodio : NSDictionary = [ "dict":1 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fecha : String = episodio.valueForKey("fecha") as! String
        println("La fecha es: \(fecha)")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 3
        }else if(section == 1){
            return 1
        }else if(section == 2){
            let comentarios : NSArray = episodio.valueForKey("comentarios") as! NSArray
            if(comentarios.count > 0){
                return comentarios.count
            }else{
                return 1
            }
        }else if(section == 3){
            let medicamentos : NSArray = episodio.valueForKey("medicamentos") as! NSArray
            if(medicamentos.count > 0){
                return medicamentos.count
            }else{
                return 1
            }
        }else if(section == 4){
            let patronesDeSueno : NSArray = episodio.valueForKey("patronesDeSueno") as! NSArray
            if(patronesDeSueno.count > 0){
                return patronesDeSueno.count
            }else{
                return 1
            }
        }else{
            return 0;
        }
    }
    
    func setEpisodioVista(nepisodio : NSDictionary) -> Void{
        episodio = nepisodio
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("episodio", forIndexPath: indexPath) as! UITableViewCell

        if (indexPath.section == 0){
            if (indexPath.row == 0){
                let nivel : Int = episodio.valueForKey("nivelDolor") as! Int
                cell.textLabel?.text = "Nivel Dolor: " + "\(nivel)"
            }else if(indexPath.row == 1){
                let fecha : String = episodio.valueForKey("fecha") as! String
                cell.textLabel?.text = "Fecha: " + fecha
            }else if(indexPath.row == 2){
                let localizacion : String = episodio.valueForKey("localizacion") as! String
                cell.textLabel?.text = "Localización: " + localizacion
            }
        }else if(indexPath.section == 1){
            let ubicacion : String = episodio.valueForKey("localizacion") as! String
            var final : String = ""
            
            if(ubicacion == "Occipital Izquierdo"){
                final = "occipital-izquierdo"
            }else if(ubicacion == "Occipital Derecho"){
                final = "occipital-derecho"
            }else if(ubicacion == "Frontal"){
                final = "frontal"
            }else if(ubicacion == "Temporal Izquierdo"){
                final = "temporal-izquierdo"
            }else if(ubicacion == "Temporal Derecho"){
                final = "temporal-derecho"
            }else if(ubicacion == "Parietal Izquierdo"){
                final = "parietal-izquierdo"
            }else if(ubicacion == "Parietal Derecho"){
                final = "parietal-derecho"
            }else{
                final = "brain"
            }
            
            let image : UIImage = UIImage(named: final)!
            let imageView : UIImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 340, height: 400))
            imageView.image = image
            cell.addSubview(imageView)
            cell.textLabel?.text = ""
        }else if(indexPath.section == 2){
            let comentarios : NSArray = episodio.valueForKey("comentarios") as! NSArray
            if (comentarios.count > 0){
                let comment : NSDictionary = comentarios[indexPath.row] as! NSDictionary
                let texto : String = comment.valueForKey("contenido") as! String
                cell.textLabel?.text = "" + texto
            }else{
                cell.textLabel?.text = "No hay comentarios"
            }
            
            
        }else if(indexPath.section == 3){
            let comentarios : NSArray = episodio.valueForKey("medicamentos") as! NSArray
            if (comentarios.count > 0){
                let comment : NSDictionary = comentarios[indexPath.row] as! NSDictionary
                let texto : String = comment.valueForKey("titulo") as! String
                cell.textLabel?.text = "" + texto
            }else{
                cell.textLabel?.text = "No hay medicamentos"
            }
            
            
        }else if(indexPath.section == 4){
            let comentarios : NSArray = episodio.valueForKey("patronesDeSueno") as! NSArray
            if (comentarios.count > 0){
                let comment : NSDictionary = comentarios[indexPath.row] as! NSDictionary
                let texto : String = comment.valueForKey("titulo") as! String
                cell.textLabel?.text = "" + texto
            }else{
                cell.textLabel?.text = "No hay patrones de sueño"
            }
            
            
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 1){
            return 440.0
        }else{
            return 44.0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Información"
        }else if(section == 1){
            return "Imagen"
        }else if(section == 2){
            return "Comentarios"
        }else if(section == 3){
            return "Medicamentos"
        }else{
            return "Patrones Sueño"
        }
    }

    
    @IBAction func rangoEdades(sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Agregar Comentario", message: "Escriba el comentario a agregar", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: "Comentar", style: UIAlertActionStyle.Default,handler: {
            (alert: UIAlertAction!) in
            if let textField = actionSheetController.textFields?.first as? UITextField{
                var connector : Connector = Connector()
                let idDoc : Int = self.episodio.valueForKey("id") as! Int
                let comment = textField.text
                connector.doPost("/episodio/\(idDoc)/comentario", dict: ["contenido": comment])
            }
        }))
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.blueColor()
        }
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func reproducirSonido(sender: UIButton) {
        var  player = AVPlayer()
        
        let url = episodio["grabacion"] as! String
        let playerItem = AVPlayerItem( URL:NSURL( string:url ) )
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

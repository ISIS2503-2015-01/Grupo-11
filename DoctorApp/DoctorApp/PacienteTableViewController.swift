//
//  PacienteTableViewController.swift
//  DoctorApp
//
//  Created by Felipe Macbook Pro on 5/21/15.
//  Copyright (c) 2015 Felipe-Otalora. All rights reserved.
//

import UIKit

class PacienteTableViewController: UITableViewController {

    var paciente : NSDictionary = [ "dict":1 ]
    var episodios : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodios = paciente.valueForKey("episodios") as! NSArray
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if(section == 0){
            return 6
        }else if(section == 1){
            return 1
        }else{
            return episodios.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("paciente", forIndexPath: indexPath) as! UITableViewCell

        if (indexPath.section == 0){
            if (indexPath.row == 0){
                let nombre : String = paciente.valueForKey("nombre") as! String
                let apellido : String = paciente.valueForKey("apellido") as! String
                cell.textLabel?.text = "Nombre: " + nombre + " " + apellido
            }else if(indexPath.row == 1){
                let genero : String = paciente.valueForKey("genero") as! String
                cell.textLabel?.text = "Género: " + genero
            }else if(indexPath.row == 2){
                let cedula : String = paciente.valueForKey("identificacion") as! String
                cell.textLabel?.text = "Cédula: " + cedula
            }else if(indexPath.row == 3){
                let correo : String = paciente.valueForKey("email") as! String
                cell.textLabel?.text = "Correo: " + correo
            }else if(indexPath.row == 4){
                let fechaNac : String = paciente.valueForKey("fechaNacimiento") as! String
                cell.textLabel?.text = "Fecha Nacimiento: " + fechaNac
            }else if(indexPath.row == 5){
                let fechaNac : String = paciente.valueForKey("fechaVinculacion") as! String
                cell.textLabel?.text = "Fecha Vinculación: " + fechaNac
            }
        }else if(indexPath.section == 1){
            var data : [Float] = []
            //        var vals : [Float] = [episodios.count]
            for (index, element) in enumerate(episodios) {
                let dictActual : NSDictionary = element as! NSDictionary
                data.append(dictActual.valueForKey("nivelDolor") as! Float)
            }
            
            if(episodios.count > 1){
                cell.subviews.map({ $0.removeFromSuperview() })
                let chart = Chart(frame: CGRect(x: 20, y: 20, width: 340, height: 400))
                let series = ChartSeries(data)
                series.color = ChartColors.greenColor()
                chart.addSeries(series)
                cell.textLabel?.text = ""
                cell.addSubview(chart)
            }else{
                println("No hay episodios")
                cell.textLabel?.text = "No hay episodios"
            }

        }else if(indexPath.section == 2){
            let episodioActual : NSDictionary = episodios[indexPath.row] as! NSDictionary
            let fecha : String = episodioActual.valueForKey("fecha") as! String
            let nivel : Int = episodioActual.valueForKey("nivelDolor") as! Int
            cell.textLabel?.text = "Episodio: " + fecha + " dolor: " + "\(nivel)"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Información"
        }else if(section == 1){
            return "Gráfica"
        }else{
            return "Episodios"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 2){
            //Ver pacientes selected
            episodios = paciente.valueForKey("episodios") as! NSArray
            let episodioAtual : NSDictionary = episodios[indexPath.row] as! NSDictionary
            
            let main : UIStoryboard = self.storyboard!
            let controller : EpisodioTableViewController =  main.instantiateViewControllerWithIdentifier("EpisodioTableViewController") as! EpisodioTableViewController
            controller.setEpisodioVista(episodioAtual)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 1){
            if(episodios.count > 0){
                return 440.0
            }else{
                return 44.0
            }
        }else{
            return 44.0
        }
    }
    
    func setPacienteVista(npaciente : NSDictionary) -> Void{
        paciente = npaciente
    }
    
    @IBAction func verTodos(sender: UIButton) {
        episodios = paciente.valueForKey("episodios") as! NSArray
        self.tableView.reloadData()
    }
    
    @IBAction func rangoEdades(sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Filtrar Episodios", message: "Escriba el filtro del nivel ej: 0-10", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: "Filtrar", style: UIAlertActionStyle.Default,handler: {
            (alert: UIAlertAction!) in
            if let textField = actionSheetController.textFields?.first as? UITextField{
                self.episodios = self.paciente.valueForKey("episodios") as! NSArray
                let filtro = textField.text
                
                var fullNameArr = split(filtro) {$0 == "-"}
                let min : Int = (fullNameArr[0] as String).toInt()!
                let max : Int = (fullNameArr[1] as String).toInt()!
                
                var appenders : [NSDictionary] = []
                
                for (var i = 0; i < self.episodios.count; i++){
                    let actual : NSDictionary = self.episodios[i] as! NSDictionary
                    let edad : Int = actual.valueForKey("nivelDolor") as! Int
                    if(min < edad && max > edad){
                        appenders.append(actual)
                    }
                }
                self.episodios = appenders
                self.tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

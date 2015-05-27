//
//  PacientesTableViewController.swift
//  DoctorApp
//
//  Created by Felipe Macbook Pro on 4/7/15.
//  Copyright (c) 2015 Felipe-Otalora. All rights reserved.
//

import UIKit

class PacientesTableViewController: UITableViewController {
    
    var pacientesArray : NSArray = []
    
    var refresher : UIRefreshControl!
    var segControl : UISegmentedControl = UISegmentedControl(items: ["Todos","Nombre","Altura","Apellido"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segControl.selectedSegmentIndex = 0
        segControl.frame = CGRectMake(60.0, 20.0, 260.0, 30.0)
        segControl.addTarget(self, action: "ordenar:", forControlEvents: .ValueChanged)
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        var connector : Connector = Connector()
        
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var doctorActual : String = settings.valueForKey("DOCTOR_ID") as! String
        
        pacientesArray = connector.doGet("/doctor/\(doctorActual)/pacientes")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func ordenar(sender: UISegmentedControl) -> Void {
        var connector : Connector = Connector()
        let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var doctorActual : String = settings.valueForKey("DOCTOR_ID") as! String
        pacientesArray = connector.doGet("/doctor/\(doctorActual)/pacientes")
        
        switch sender.selectedSegmentIndex {
        case 0:
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
            var sortedResults: NSArray = pacientesArray.sortedArrayUsingDescriptors([descriptor])
            pacientesArray = sortedResults
            self.tableView.reloadData()
        case 1:
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "nombre", ascending: true)
            var sortedResults: NSArray = pacientesArray.sortedArrayUsingDescriptors([descriptor])
            pacientesArray = sortedResults
            self.tableView.reloadData()
        case 2:
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "fechaNacimiento", ascending: true)
            var sortedResults: NSArray = pacientesArray.sortedArrayUsingDescriptors([descriptor])
            pacientesArray = sortedResults
            self.tableView.reloadData()
        case 3:
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "apellido", ascending: true)
            var sortedResults: NSArray = pacientesArray.sortedArrayUsingDescriptors([descriptor])
            pacientesArray = sortedResults
            self.tableView.reloadData()
        default:
            self.view.backgroundColor = UIColor.purpleColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return pacientesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        var dictActual = pacientesArray[indexPath.row] as! NSDictionary
        let nombre : String = dictActual.valueForKey("nombre") as! String
        let apellido : String = dictActual.valueForKey("apellido") as! String
        cell.textLabel?.text = nombre + " " + apellido
        //        cell.detailTextLabel?.text = dictActual.valueForKey("email") as? String
        cell.imageView?.image = UIImage(named: "doctor")
        
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let main : UIStoryboard = self.storyboard!
        let controller : PacienteTableViewController =  main.instantiateViewControllerWithIdentifier("PacienteTableViewController") as! PacienteTableViewController
        var pacienteActual : NSDictionary = pacientesArray[indexPath.row] as! NSDictionary
        controller.setPacienteVista(pacienteActual)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view : UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 70.0))
        view.backgroundColor = UIColor(red: 250.0/255, green: 250.0/255, blue: 250.0/255, alpha: 1.0)
        view.addSubview(segControl)
        
        return view
    }
    
    @IBAction func rangoEdades(sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Filtrar Edades", message: "Escriba el filtro de edades ej: 20-40", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        actionSheetController.addAction(UIAlertAction(title: "Filtrar", style: UIAlertActionStyle.Default,handler: {
            (alert: UIAlertAction!) in
            if let textField = actionSheetController.textFields?.first as? UITextField{
                var connector : Connector = Connector()
                let settings : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                var doctorActual : String = settings.valueForKey("DOCTOR_ID") as! String
                self.pacientesArray = connector.doGet("/doctor/\(doctorActual)/pacientes")
                let filtro = textField.text
                
                var fullNameArr = split(filtro) {$0 == "-"}
                let min : Int = (fullNameArr[0] as String).toInt()!
                let max : Int = (fullNameArr[1] as String).toInt()!
                
                var appenders : [NSDictionary] = []

                for (var i = 0; i < self.pacientesArray.count; i++){
                    let actual : NSDictionary = self.pacientesArray[i] as! NSDictionary
                    let edad : Int = actual.valueForKey("edad") as! Int
                    if(min < edad && max > edad){
                        appenders.append(actual)
                    }
                }
                self.pacientesArray = appenders
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
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

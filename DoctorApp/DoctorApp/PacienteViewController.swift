//
//  PacienteViewController.swift
//  DoctorApp
//
//  Created by Felipe Macbook Pro on 5/6/15.
//  Copyright (c) 2015 Felipe-Otalora. All rights reserved.
//

import UIKit

class PacienteViewController: UIViewController {
    
    @IBOutlet weak var lblNombre : UILabel?
    @IBOutlet weak var lblFecha : UILabel?
    @IBOutlet weak var lblSangre : UILabel?
    
    var label = UILabel()
    var lineChart: LineChart!
    
    var paciente : NSDictionary = [ "dict":1 ]

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "..."
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        // Do any additional setup after loading the view.
        lblNombre?.text = paciente.valueForKey("nombre") as? String
        lblFecha?.text = paciente.valueForKey("fechaNacimiento") as? String
        lblSangre?.text = paciente.valueForKey("tipoSangre") as? String
        
        var episodios : NSArray = paciente.valueForKey("episodios") as! NSArray
        
        var data : [Float] = []
//        var vals : [Float] = [episodios.count]
        for (index, element) in enumerate(episodios) {
            let dictActual : NSDictionary = element as! NSDictionary
            data.append(dictActual.valueForKey("nivelDolor") as! Float)
        }
        
        if(episodios.count > 1){
            let chart = Chart(frame: CGRect(x: 20, y: 200, width: 340, height: 400))
            let series = ChartSeries(data)
            series.color = ChartColors.greenColor()
            chart.addSeries(series)
            self.view.addSubview(chart)
        }else{
            println("No hay episodios")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setPacienteVista(npaciente : NSDictionary) -> Void{
        paciente = npaciente
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

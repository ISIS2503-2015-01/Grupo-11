package models;

import java.sql.Time;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="Intervalos")
public class Intervalo {
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	
	private Time inicio;
	
	private Time fin;
	
	public Long getId(){
		return this.id;
	}
	
	public void setId(Long id){
		this.id = id;
	}
	public Time getInicio() {
		return inicio;
	}
	public void setInicio(Time inicio) {
		this.inicio = inicio;
	}
	public Time getFin() {
		return fin;
	}
	public void setFin(Time fin) {
		this.fin = fin;
	}

	
}
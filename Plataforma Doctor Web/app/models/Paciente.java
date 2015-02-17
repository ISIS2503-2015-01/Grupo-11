package models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.sun.istack.internal.NotNull;

@Entity
@Table(name="Pacientes")
public class Paciente{
	
	@NotNull
	private String nombre;

	@NotNull
	private String apellido;

	@Id
	@Column(name="id")
	private String identificacion;
	
	@NotNull
	private String password;

	@NotNull
	private Date fechaVinculacion;

	@NotNull
	private Date fechaNacimiento;
	
	@OneToMany
	private List<Episodio> episodios;
	
	@OneToMany
	private List<Medicamento> medicamentos;

	
	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido() {
		return apellido;
	}

	public void setApellido(String apellido) {
		this.apellido = apellido;
	}

	public String getIdentificacion() {
		return identificacion;
	}

	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Date getFechaVinculacion() {
		return fechaVinculacion;
	}

	public void setFechaVinculacion(Date fechaVinculacion) {
		this.fechaVinculacion = fechaVinculacion;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public List<Episodio> getEpisodios() {
		return episodios;
	}

	public void setEpisodios(List<Episodio> episodios) {
		this.episodios = episodios;
	}
	
	public void addEpisodio(Episodio episodio){
		if(this.episodios==null){
			this.episodios=new ArrayList<Episodio>();
		}
		this.episodios.add(episodio);
	}

	public List<Medicamento> getMedicamentos() {
		return medicamentos;
	}

	public void setMedicamentos(List<Medicamento> medicamentos) {
		this.medicamentos = medicamentos;
	}
	
	public void addMedicamento(Medicamento medicamento){
		if(this.medicamentos==null){
			this.medicamentos=new ArrayList<Medicamento>();
		}
		this.medicamentos.add(medicamento);
	}
	
	
}

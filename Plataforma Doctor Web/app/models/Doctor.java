package models;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;

import com.sun.istack.internal.NotNull;

import play.libs.F.Option;
import play.mvc.QueryStringBindable;

@Entity
public class Doctor implements QueryStringBindable<Doctor>{

	@NotNull
	private String nombre;

	@NotNull
	private String apellido;

	@Id
	@Column(name="id")
	private String identificacion;

	private boolean autorizado;

	@NotNull
	private String password;

	@NotNull
	private Date fechaVinculacion;

	@NotNull
	private Date fechaNacimiento;

	@OneToMany
	private List<Paciente> pacientes;

	@OneToMany
	private List<Comentario> comentarios;

	@ManyToMany
	private List<Episodio> segundasOpiniones;

	@ManyToMany
	private List<Doctor> colegas;

	@PrePersist
	private void prePersist() {
		this.fechaVinculacion = Calendar.getInstance().getTime();
		this.autorizado=false;
	}

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

	public boolean isAutorizado() {
		return autorizado;
	}

	public void setAutorizado(boolean autorizado) {
		this.autorizado = autorizado;
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

	public List<Paciente> getPacientes() {
		return pacientes;
	}

	public void setPacientes(List<Paciente> pacientes) {
		this.pacientes = pacientes;
	}

	public void addPaciente(Paciente paciente){
		if(this.pacientes==null){
			this.pacientes=new ArrayList<Paciente>();
		}
		this.pacientes.add(paciente);
	}

	public List<Comentario> getComentarios() {
		return comentarios;
	}

	public void setComentarios(List<Comentario> comentarios) {
		this.comentarios = comentarios;
	}

	public void addComentario(Comentario comentario){
		if(this.comentarios==null){
			this.comentarios=new ArrayList<Comentario>();
		}
		this.comentarios.add(comentario);
	}

	public List<Episodio> getSegundasOpiniones() {
		return segundasOpiniones;
	}

	public void setSegundasOpiniones(List<Episodio> segundasOpiniones) {
		this.segundasOpiniones = segundasOpiniones;
	}

	public void addSegundaOpinion(Episodio episodio){
		if(this.segundasOpiniones==null){
			this.segundasOpiniones=new ArrayList<Episodio>();
		}
		this.segundasOpiniones.add(episodio);
	}

	public List<Doctor> getColegas() {
		return colegas;
	}

	public void setColegas(List<Doctor> colegas) {
		this.colegas = colegas;
	}

	public void addColega(Doctor colega){
		if(this.colegas==null){
			this.colegas=new ArrayList<Doctor>();
		}
		this.colegas.add(colega);
	}

	@Override
	public Option<Doctor> bind(String key, Map<String, String[]> values) {
		try{
			this.nombre = values.containsKey("nombre")?values.get("nombre")[0]:"";
			this.apellido = values.containsKey("apellido")?values.get("apellido")[0]:"";
			this.password = values.containsKey("password")?values.get("password")[0]:"";
			this.identificacion = values.containsKey("identificacion")?values.get("identificacion")[0]:"";
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.US);
			this.fechaNacimiento = values.containsKey("fechaNacimiento")?sdf.parse(values.get("fechaNacimiento")[0]):null;
			return Option.Some(this);
		}
		catch(Exception e){
			return Option.None();
		}

	}

	@Override
	public String javascriptUnbind() {
		return null;
	}

	@Override
	public String unbind(String arg0) {
		return null;
	}
}

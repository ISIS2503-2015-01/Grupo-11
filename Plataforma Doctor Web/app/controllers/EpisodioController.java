package controllers;

import java.util.List;

import models.Comentario;
import models.Doctor;
import models.Episodio;
import play.data.Form;
import play.db.jpa.JPA;
import play.db.jpa.Transactional;
import play.mvc.Controller;
import play.mvc.Result;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class EpisodioController extends Controller {
	
	@Transactional
	public static Result getEpisodio(String idEpisodio){
		Episodio buscado = JPA.em().find(Episodio.class, idEpisodio);
		if(buscado != null){
			ObjectMapper mapper = new ObjectMapper(); 
			JsonNode node = mapper.convertValue(buscado, JsonNode.class);
			return ok(node);
		}else{
			return status(1,"El episodio con identificacion " + idEpisodio + " no existe");
		}
	}

	public static Result eliminarEpisodio(Long id){
		Episodio eliminar = JPA.em().find(Episodio.class, id);
		if(eliminar!=null){
			JPA.em().remove(eliminar);
			return ok("El episodio con id: " + id + " fue eliminado correctamente");
		}	
		else{
			return status(1,"El episodio con id: " + id + " no existe");
		}
	}
	
	public static Result crearComentario(Long id){
		Episodio actual = JPA.em().find(Episodio.class, id);
		Doctor doctor = JPA.em().find(Doctor.class, Form.form(Doctor.class).bindFromRequest().get().getIdentificacion());
		if(actual!=null && doctor!=null){
			Comentario nuevo = Form.form(Comentario.class).bindFromRequest().get();
			nuevo.setDoctor(doctor);
			JPA.em().persist(nuevo);
			actual.addComentario(nuevo);
			List<Comentario> comentarios = actual.getComentarios();
			ObjectMapper mapper = new ObjectMapper(); 
			JsonNode node = mapper.convertValue(comentarios, JsonNode.class);
			JPA.em().merge(actual);
			return ok(node);
		}	
		else{
			return status(1,"El episodio con identificacion: " + id+ " no existe en el sistema, o el doctor dado no existe.");
		}
	}
}

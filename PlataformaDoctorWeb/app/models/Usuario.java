package models;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import excepciones.TimeException;
import excepciones.UsuarioException;
import play.db.jpa.JPA;
import play.db.jpa.Transactional;
import play.libs.Json;
import javax.persistence.*;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public abstract class Usuario implements Comparable<Usuario>{

    protected static final String MASCULINO="Masculino";
    protected static final String FEMENINO="Femenino";
    public static final String ROL_ADMIN="Administrador";
    public static final String ROL_DOCTOR="Doctor";
    public static final String ROL_PACIENTE="Paciente";

    @Id
    @Column(name="id_usuario")
    @GeneratedValue(strategy = GenerationType.AUTO)
    protected Long id;

    protected String nombre;

    protected String apellido;

    protected String identificacion;

    @Column(length = 64, nullable = false)
    private byte[] shaPassword;

    protected String password;

    protected Date fechaVinculacion;

    protected Date fechaNacimiento;

    protected String email;

    protected String genero;

    @OneToOne
    protected S3File profilePicture;

    protected String rol;

    public String token;

    public void prePersist() {
        this.fechaVinculacion = Calendar.getInstance().getTime();
    }

    public Usuario(){

    }

    public Usuario(JsonNode node) throws UsuarioException {
        this.setNombre(node.findPath("nombre").asText());
        this.setApellido(node.findPath("apellido").asText());
        this.setPassword(node.findPath("password").asText());
        this.setGenero(node.findPath("genero").asInt());
        this.setEmail(node.findPath("email").asText());
        this.setIdentificacion(node.findPath("identificacion").asText());
        try {
            this.setFechaNacimiento(stringToDate(node.findPath("fechaNacimiento").asText()));
        }
        catch (TimeException e){
            throw new UsuarioException(e.getMessage());
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
        shaPassword = getSha512(password);
    }

    public Date getFechaVinculacion() {
        return fechaVinculacion;
    }

    public Date getFechaNacimiento() {
        return fechaNacimiento;
    }

    public void setFechaNacimiento(Date fechaNacimiento) {
        this.fechaNacimiento = fechaNacimiento;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(int genero) throws UsuarioException{
        if(genero==1){
            this.genero=MASCULINO;
        }
        else if(genero==0){
            this.genero=FEMENINO;
        }
        else{
            throw new UsuarioException("Error con el género del usuario");
        }
    }

    public S3File getProfilePicture(){
        return profilePicture;
    }
    public void setProfilePicture(S3File s3File) {
        this.profilePicture = s3File;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    private static Date stringToDate(String date) throws TimeException {
        try {
            DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
            return formatter.parse(date);
        }
        catch (ParseException e) {
            throw new TimeException("Error interpretando la fecha");
        }
    }

    private String dateToString(Date date){
        DateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
        return formatter.format(date);
    }

    public ObjectNode toJson(){
        ObjectNode node = Json.newObject();
        node.put("id", getId());
        node.put("nombre", getNombre());
        node.put("apellido", getApellido());
        node.put("genero", getGenero());
        node.put("identificacion", getIdentificacion());
        node.put("email", getEmail());
        node.put("fechaNacimiento", dateToString(getFechaNacimiento()));
        node.put("fechaVinculacion", dateToString(getFechaVinculacion()));
        node.put("picture", profilePicture!=null?profilePicture.getUrl().toString():null);
        node.put("rol", this.rol);
        return node;
    }

    public static ArrayNode listToJson(List<? extends Usuario> usuarios,boolean simplified){
        JsonNodeFactory factory = JsonNodeFactory.instance;
        ArrayNode array = new ArrayNode(factory);
        for (Usuario p : usuarios) {
            if(simplified){
                array.add(p.getId());
            }
            else{
                array.add(p.toJson());
            }
        }
        return array;
    }

    public static byte[] getSha512(String value) {
        try {
            return MessageDigest.getInstance("SHA-512").digest(value.getBytes("UTF-8"));
        }
        catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
        catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    public static Usuario findByAuthToken(String authToken) {
        if (authToken == null) {
            return null;
        }
        try  {
            Usuario usuario = JPA.withTransaction("default", false, new play.libs.F.Function0<Usuario>() {
                public Usuario apply() throws Throwable {
                    return JPA.em().createQuery("SELECT u FROM Usuario u WHERE u.token = ?1", Usuario.class).setParameter(1, authToken).getSingleResult();
                }
            });
            return usuario;
        }
        catch (Throwable e) {
            return null;
        }
    }

    @Transactional
    public String createToken() {
        if(token == null) {
            token = UUID.randomUUID().toString();
            JPA.em().merge(this);
        }
        return token;
    }

    @Transactional
    public void deleteAuthToken() {
        token = null;
        JPA.em().merge(this);
    }

    public int compareTo(Usuario o){
        if(this.id == o.getId()){
            return 0;
        }
        else if(this.id > o.getId()){
            return 1;
        }
        else{
            return -1;
        }
    }

    public boolean equals(Object o){
        if(o instanceof Usuario){
            return this.id == ((Usuario)o).getId();
        }
        return false;
    }

    public int hashCode() {
        return this.id.hashCode();
    }

}

class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String usuario;
  final String password;
  final String email;
  final String empresa; //opcional
  final String rol;

  Usuario(this.id, this.nombre, this.apellido, this.usuario, this.password,
      this.email, this.empresa, this.rol);
}

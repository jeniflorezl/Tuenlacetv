# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
Pais.create(nombre: 'COLOMBIA', usuario: 'admin')
Pais.create(nombre: 'PANAMA', usuario: 'admin')
Pais.create(nombre: 'VENEZUELA', usuario: 'admin')
Ciudad.create(pais_id: 1, nombre: 'MEDELLIN', codigoDane: '05001', codigoAlterno: '', usuario: 'admin')
Ciudad.create(pais_id: 1, nombre: 'BOGOTA', codigoDane: '05001', codigoAlterno: '', usuario: 'admin')
Ciudad.create(pais_id: 1, nombre: 'BUCARAMANGA', codigoDane: '05001', codigoAlterno: '', usuario: 'admin')
Ciudad.create(pais_id: 1, nombre: 'PEREIRA', codigoDane: '05001', codigoAlterno: '', usuario: 'admin')
Zona.create(ciudad_id: 1, nombre: 'ZONA GENERAL', usuario: 'admin')
Zona.create(ciudad_id: 1, nombre: 'ZONA NORTE', usuario: 'admin')
Zona.create(ciudad_id: 1, nombre: 'ZONA CENTRO', usuario: 'admin')
Zona.create(ciudad_id: 1, nombre: 'ZONA SUR', usuario: 'admin')
Zona.create(ciudad_id: 1, nombre: 'ZONA SUROESTE', usuario: 'admin')
Barrio.create(zona_id: 1, nombre: 'PRADO', usuario: 'admin')
Barrio.create(zona_id: 2, nombre: 'MIRADOR', usuario: 'admin')
Barrio.create(zona_id: 3, nombre: 'TRAPICHE', usuario: 'admin')
Barrio.create(zona_id: 4, nombre: 'SANTA ANA', usuario: 'admin')
Barrio.create(zona_id: 5, nombre: 'BOSTON', usuario: 'admin')
Banco.create(nit: '800226788', nombre: 'CAJA GENERAL', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '110505', cuentaContable: '', usuario: 'admin')
Banco.create(nit: '900938640', nombre: 'PTO PAGO SUR', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '110455', cuentaContable: '', usuario: 'admin')
Banco.create(nit: '860002964', nombre: 'PTO PAGO OESTE', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '125667', cuentaContable: '', usuario: 'admin')
Servicio.create(nombre: 'TELEVISION', usuario: 'admin')
Servicio.create(nombre: 'INTERNET', usuario: 'admin')
Concepto.create(servicio_id: 1, codigo: '001', nombre: 'SUSCRIPCION', porcentajeIva: '19',
abreviatura: 'AFI', operacion: '+', usuario: 'admin')
Concepto.create(servicio_id: 1, codigo: '002', nombre: 'MENSUALIDAD', porcentajeIva: '19',
abreviatura: 'FAC', operacion: '+', usuario: 'admin')
Concepto.create(servicio_id: 1, codigo: '003', nombre: 'PUNTO ADICIONAL', porcentajeIva: '19',
abreviatura: 'ETV', operacion: '+', usuario: 'admin')
Plan.create(servicio_id: 1, nombre: 'Plan tv', usuario: 'admin')
Tarifa.create(zona_id: 1, concepto_id: 1, plan_id: 1, valor: '35000', estado_id: 1, usuario: 'admin')
Tarifa.create(zona_id: 2, concepto_id: 2, plan_id: 1, valor: '50000', estado_id: 1, usuario: 'admin')
Tarifa.create(zona_id: 3, concepto_id: 3, plan_id: 1, valor: '20000', estado_id: 1, usuario: 'admin')
Tarifa.create(zona_id: 4, concepto_id: 1, plan_id: 1, valor: '15000', estado_id: 1, usuario: 'admin')
TipoDocumento.create(nombre: 'Cédula de Ciudadanía', usuario: 'admin')
TipoDocumento.create(nombre: 'Cédula de Extranjería', usuario: 'admin')
TipoDocumento.create(nombre: 'Pasaporte', usuario: 'admin')
TipoDocumento.create(nombre: 'NIT', usuario: 'admin')
Tecnologia.create(nombre: 'Análogo', usuario: 'admin')
Tecnologia.create(nombre: 'Digital', usuario: 'admin')
TipoInstalacion.create(nombre: 'Casa', usuario: 'admin')
TipoInstalacion.create(nombre: 'Edificio', usuario: 'admin')
TipoInstalacion.create(nombre: 'Hotel', usuario: 'admin')
TipoInstalacion.create(nombre: 'Negocio', usuario: 'admin')
Funcion.create(nombre: 'Suscriptor', usuario: 'admin')
Funcion.create(nombre: 'Empleado', usuario: 'admin')
Funcion.create(nombre: 'Proveedor', usuario: 'admin')
Funcion.create(nombre: 'Cliente', usuario: 'admin')
Funcion.create(nombre: 'Vendedor', usuario: 'admin')
Funcion.create(nombre: 'Esal', usuario: 'admin')
Funcion.create(nombre: 'Tecnico', usuario: 'admin')
Funcion.create(nombre: 'Cobrador', usuario: 'admin')
Estado.create(nombre: 'Activo', abreviatura: 'A', usuario: 'admin')
Estado.create(nombre: 'Cortado', abreviatura: 'C', usuario: 'admin')
Estado.create(nombre: 'Exentos', abreviatura: 'E', usuario: 'admin')
Estado.create(nombre: 'Pendiente',  abreviatura: 'P', usuario: 'admin')
Estado.create(nombre: 'Retirado', abreviatura: 'R', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '1020470055', nombre1: 'JENIFFER', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'LONDOÑO', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 1, zona_id: 1, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '7447852522', nombre1: 'ESTEFANIA', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'LONDOÑO', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 2, zona_id: 2, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '4115288555', nombre1: 'WALTER', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 3, zona_id: 3, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '4125599866', nombre1: 'ELIANA', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 4, zona_id: 4, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '5858963322', nombre1: 'CARLOS', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 5, zona_id: 5, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '695221145', nombre1: 'PEDRO', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 1, zona_id: 1, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')
Persona.create(tipo_documento_id: 1, documento: '215455269', nombre1: 'CAMILO', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', telefono1: '4540312', 
telefono2: '', barrio_id: 2, zona_id: 2, correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario: 'admin')

Entidad.create(funcion_id: 1, persona_id: 1, usuario: 'admin')
Entidad.create(funcion_id: 1, persona_id: 2, usuario: 'admin')
Entidad.create(funcion_id: 1, persona_id: 3, usuario: 'admin')
Entidad.create(funcion_id: 1, persona_id: 4, usuario: 'admin')
Entidad.create(funcion_id: 7, persona_id: 5, usuario: 'admin')
Entidad.create(funcion_id: 5, persona_id: 6, usuario: 'admin')
Entidad.create(funcion_id: 5, persona_id: 7, usuario: 'admin')
Senal.create(entidad_id: 1, servicio_id: 1, contrato: '4789963', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 1, zona_id: 1, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 2, servicio_id: 1, contrato: '145665', direccion: 'Cr 47', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 2, zona_id: 2, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 3, servicio_id: 1, contrato: '369669', direccion: 'Calle 8', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 3, zona_id: 3, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 4, servicio_id: 1, contrato: '325856', direccion: 'Cr 45', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 4, zona_id: 4, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 5, servicio_id: 1, contrato: '477586', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 5, zona_id: 5, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 6, servicio_id: 1, contrato: '365899', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 1, zona_id: 1, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
Senal.create(entidad_id: 8, servicio_id: 1, contrato: '147788', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', observacion: '',
barrio_id: 2, zona_id: 2, estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
precinto: '12321', vendedor_id: 6, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario: 'admin')
=end

Empresa.create(tipo: '01', nit: '900353347', razonsocial: 'enlace informatico s.a.s', direccion: 'cra 47 #53-41', 
telefono1: '4540312', telefono2: '', ciudad_id: 2, entidad_id: 2, logoempresa: '', correo: 'gerencia@enlaceinformatico.com',
regimen: 's', contribuyente: 's', centrocosto: '0001', fechacre: '15/02/2018', fechacam: '15/02/2018', usuario: 'admin')

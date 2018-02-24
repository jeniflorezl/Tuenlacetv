# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
Estado.create(nombre: 'Activo', abreviatura: 'A', usuario: 'admin')

Pais.create(nombre: 'COLOMBIA', usuario_id: 1)
Pais.create(nombre: 'PANAMA', usuario_id: 1)
Pais.create(nombre: 'VENEZUELA',usuario_id: 1)
Ciudad.create(pais_id: 1, nombre: 'MEDELLIN', codigoDane: '05001', codigoAlterno: '', usuario_id: 1)
Ciudad.create(pais_id: 1, nombre: 'BOGOTA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1)
Ciudad.create(pais_id: 1, nombre: 'BUCARAMANGA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1)
Ciudad.create(pais_id: 1, nombre: 'PEREIRA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA GENERAL', usuario_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA NORTE', usuario_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA CENTRO', usuario_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA SUR', usuario_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA SUROESTE', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'PRADO', usuario_id: 1)
Barrio.create(zona_id: 2, nombre: 'MIRADOR', usuario_id: 1)
Barrio.create(zona_id: 3, nombre: 'TRAPICHE', usuario_id: 1)
Barrio.create(zona_id: 4, nombre: 'SANTA ANA', usuario_id: 1)
Barrio.create(zona_id: 5, nombre: 'BOSTON', usuario_id: 1)
=end
Estado.create(nombre: 'Cortado', abreviatura: 'C', usuario: 'admin')
Estado.create(nombre: 'Exentos', abreviatura: 'E', usuario: 'admin')
Estado.create(nombre: 'Pendiente',  abreviatura: 'P', usuario: 'admin')
Estado.create(nombre: 'Retirado', abreviatura: 'R', usuario: 'admin')
Banco.create(nit: '800226788', nombre: 'CAJA GENERAL', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '110505', cuentaContable: '', usuario_id: 1)
Banco.create(nit: '900938640', nombre: 'PTO PAGO SUR', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '110455', cuentaContable: '', usuario_id: 1)
Banco.create(nit: '860002964', nombre: 'PTO PAGO OESTE', direccion: '', ciudad_id: 1, telefono1: '0',
telefono2: '0', contacto: '', cuentaBancaria: '125667', cuentaContable: '', usuario_id: 1)
Servicio.create(nombre: 'TELEVISION', usuario_id: 1)
Servicio.create(nombre: 'INTERNET', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '001', nombre: 'SUSCRIPCION', abreviatura: 'AFI',
porcentajeIva: '19', operacion: '+', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '002', nombre: 'MENSUALIDAD', abreviatura: 'FAC',
porcentajeIva: '19', operacion: '+', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '003', nombre: 'PUNTO ADICIONAL', abreviatura: 'ETV',
porcentajeIva: '19', operacion: '+', usuario_id: 1)
Plan.create(servicio_id: 1, nombre: 'Plan tv', usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 1, plan_id: 1, valor: '35000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 2, concepto_id: 2, plan_id: 1, valor: '50000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 3, concepto_id: 3, plan_id: 1, valor: '20000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 4, concepto_id: 1, plan_id: 1, valor: '15000', estado_id: 1, usuario_id: 1)
TipoDocumento.create(nombre: 'Cédula de Ciudadanía', usuario_id: 1)
TipoDocumento.create(nombre: 'Cédula de Extranjería', usuario_id: 1)
TipoDocumento.create(nombre: 'Pasaporte', usuario_id: 1)
TipoDocumento.create(nombre: 'NIT', usuario_id: 1)
Tecnologia.create(nombre: 'Análogo', usuario_id: 1)
Tecnologia.create(nombre: 'Digital', usuario_id: 1)
TipoInstalacion.create(nombre: 'Casa', usuario_id: 1)
TipoInstalacion.create(nombre: 'Edificio', usuario_id: 1)
TipoInstalacion.create(nombre: 'Hotel', usuario_id: 1)
TipoInstalacion.create(nombre: 'Negocio', usuario_id: 1)
Funcion.create(nombre: 'Suscriptor', usuario_id: 1)
Funcion.create(nombre: 'Empleado', usuario_id: 1)
Funcion.create(nombre: 'Proveedor', usuario_id: 1)
Funcion.create(nombre: 'Cliente', usuario_id: 1)
Funcion.create(nombre: 'Vendedor', usuario_id: 1)
Funcion.create(nombre: 'Esal', usuario_id: 1)
Funcion.create(nombre: 'Tecnico', usuario_id: 1)
Funcion.create(nombre: 'Cobrador', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '1020470055', nombre1: 'JENIFFER', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'LONDOÑO', direccion: 'Cra 47 #53-41', barrio_id: 1, zona_id: 1,
telefono1: '4540312', telefono2: '', correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '7447852522', nombre1: 'ESTEFANIA', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'LONDOÑO', direccion: 'Cra 47 #53-41', barrio_id: 2, zona_id: 2,
telefono1: '4540312', telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '4115288555', nombre1: 'WALTER', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', barrio_id: 3, zona_id: 3, 
telefono1: '4540312', telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '4125599866', nombre1: 'ELIANA', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', barrio_id: 4, zona_id: 4, 
telefono1: '4540312', telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '5858963322', nombre1: 'CARLOS', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', barrio_id: 5, zona_id: 5,
telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
telefono1: '4540312', tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '695221145', nombre1: 'PEDRO', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', barrio_id: 1, zona_id: 1,  
telefono1: '4540312', telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Persona.create(tipo_documento_id: 1, documento: '215455269', nombre1: 'CAMILO', nombre2: '',
apellido1: 'FLÓREZ', apellido2: 'VEGA', direccion: 'Cra 47 #53-41', barrio_id: 2, zona_id: 2,
telefono1: '4540312', telefono2: '',  correo: 'jeniferfl@gmail.com', fechanac: '13/07/1995', 
tipopersona: 'N', estrato: '3', condicionfisica: 'N', usuario_id: 1)
Entidad.create(funcion_id: 1, persona_id: 1, usuario_id: 1)
Entidad.create(funcion_id: 1, persona_id: 2, usuario_id: 1)
Entidad.create(funcion_id: 1, persona_id: 3, usuario_id: 1)
Entidad.create(funcion_id: 1, persona_id: 4, usuario_id: 1)
Entidad.create(funcion_id: 7, persona_id: 5, usuario_id: 1)
Entidad.create(funcion_id: 5, persona_id: 6, usuario_id: 1)
Entidad.create(funcion_id: 5, persona_id: 7, usuario_id: 1)
Senal.create(entidad_id: 1, servicio_id: 1, contrato: '4789963', direccion: 'Calle 11 #24-23', urbanizacion: '', 
torre: '', apto: '', barrio_id: 1, zona_id: 1, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4',
vivienda: 'P', observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
decos: '', precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 2, servicio_id: 1, contrato: '145665', direccion: 'Cr 47', urbanizacion: '', torre: '', 
apto: '', barrio_id: 2, zona_id: 2, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P',
observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 3, servicio_id: 1, contrato: '369669', direccion: 'Calle 8', urbanizacion: '', torre: '', 
apto: '', barrio_id: 3, zona_id: 3, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4',
vivienda: 'P', observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 4, servicio_id: 1, contrato: '325856', direccion: 'Cr 45', urbanizacion: '', torre: '', 
apto: '', barrio_id: 4, zona_id: 4, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P',
observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 5, servicio_id: 1, contrato: '477586', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 5, zona_id: 5, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 6, servicio_id: 1, contrato: '365899', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 1, zona_id: 1, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Senal.create(entidad_id: 8, servicio_id: 1, contrato: '147788', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 2, zona_id: 2, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', estado_id: 1, fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 6, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1)
Empresa.create(tipo: '01', nit: '900353347', razonsocial: 'enlace informatico s.a.s', direccion: 'cra 47 #53-41', 
telefono1: '4540312', telefono2: '', ciudad_id: 2, entidad_id: 2, logo: '', correo: 'gerencia@enlaceinformatico.com',
regimen: 's', contribuyente: 's', centrocosto: '0001', usuario_id: 1)

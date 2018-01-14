# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Pais.create(nombre: 'COLOMBIA', usuario: 'admin')
#Pais.create(nombre: 'PANAMA', usuario: 'admin')
#Pais.create(nombre: 'VENEZUELA', usuario: 'admin')
#Ciudad.create(pais_id: 1, nombre: 'MEDELLIN', codigo: '05001', usuario: 'admin')
#Ciudad.create(pais_id: 1, nombre: 'BOGOTA', codigo: '05001', usuario: 'admin')
#Ciudad.create(pais_id: 1, nombre: 'BUCARAMANGA', codigo: '05001', usuario: 'admin')
#Ciudad.create(pais_id: 1, nombre: 'PEREIRA', codigo: '05001', usuario: 'admin')
#Company.create(tipo: '01', nit: '1236737382', nombre: 'ENLACE INFORMÁTICO', direccion: 'Calle 54A #43-23', 
#telefono1: '4540312', telefono2: '', fax: '', contacto: '321342343', correo: 'enlaceinformatico@gmail.com',
#regimen: '', actividade: '', contribuyente: '', resolucionCntv: '', representante: 'Jeniffer Flórez', 
#idciudad: 1, prefijo: '', titulo1: '', titulo2: '', logo: '', usuario: 'admin')
#Concept.create(descripcion: 'SUSCRIPCION', operacion: '+', clase: 'O', iva: 0, tipodoc: 'AFI', observa: '',
#usuario: 'admin')
#Concept.create(descripcion: 'MENSUALIDAD', operacion: '+', clase: 'P', iva: 0, tipodoc: 'FAC', observa: '',
#usuario: 'admin')
#Concept.create(descripcion: 'PUNTO ADICIONAL', operacion: '+', clase: 'O', iva: 0, tipodoc: 'ETV', observa: '',
#usuario: 'admin')
#Zona.create(ciudad_id: 1, nombre: 'ZONA GENERAL', usuario: 'admin')
#Zona.create(ciudad_id: 1, nombre: 'ZONA NORTE', usuario: 'admin')
#Zona.create(ciudad_id: 1, nombre: 'ZONA CENTRO', usuario: 'admin')
#Zona.create(ciudad_id: 1, nombre: 'ZONA SUR', usuario: 'admin')
#Zona.create(ciudad_id: 1, nombre: 'ZONA SUROESTE', usuario: 'admin')
#Barrio.create(zona_id: 1, nombre: 'PRADO', usuario: 'admin')
#Barrio.create(zona_id: 2, nombre: 'MIRADOR', usuario: 'admin')
#Barrio.create(zona_id: 3, nombre: 'TRAPICHE', usuario: 'admin')
#Barrio.create(zona_id: 4, nombre: 'SANTA ANA', usuario: 'admin')
#Barrio.create(zona_id: 5, nombre: 'BOSTON', usuario: 'admin')
#Banco.create(nit: '800226788', nombre: 'CAJA GENERAL', direccion: '', ciudad_id: 1, telefono1: '0',
#telefono2: '0', contacto: '', cuentaBancaria: '110505', cuentaContable: '', usuario: 'admin')
#Banco.create(nit: '900938640', nombre: 'PTO PAGO SUR', direccion: '', ciudad_id: 1, telefono1: '0',
#telefono2: '0', contacto: '', cuentaBancaria: '110455', cuentaContable: '', usuario: 'admin')
#Banco.create(nit: '860002964', nombre: 'PTO PAGO OESTE', direccion: '', ciudad_id: 1, telefono1: '0',
#telefono2: '0', contacto: '', cuentaBancaria: '125667', cuentaContable: '', usuario: 'admin')
#Servicio.create(nombre: 'TELEVISION', usuario: 'admin')
#Servicio.create(nombre: 'INTERNET', usuario: 'admin')
#Concepto.create(servicio_id: 1, codigo: '001', nombre: 'SUSCRIPCION', porcentajeIva: '19',
#abreviatura: 'AFI', operacion: '+', usuario: 'admin')
#Concepto.create(servicio_id: 1, codigo: '002', nombre: 'MENSUALIDAD', porcentajeIva: '19',
#abreviatura: 'FAC', operacion: '+', usuario: 'admin')
#Concepto.create(servicio_id: 1, codigo: '003', nombre: 'PUNTO ADICIONAL', porcentajeIva: '19',
#abreviatura: 'ETV', operacion: '+', usuario: 'admin')
Plan.create(servicio_id: 1, nombre: 'Plan tv', usuario: 'admin')

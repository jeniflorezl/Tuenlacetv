# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
Estado.create(nombre: 'ACTIVO', abreviatura: 'A', tipo: 1, usuario: 'admin')
=end
Estado.create(nombre: 'INACTIVO', abreviatura: 'IN', tipo: 1, usuario: 'admin')
=begin
Estado.create(nombre: 'CORTADO', abreviatura: 'C', tipo: 1, usuario: 'admin')
Estado.create(nombre: 'EXENTOS', abreviatura: 'E', tipo: 1, usuario: 'admin')
Estado.create(nombre: 'PENDIENTE',  abreviatura: 'P', tipo: 1, usuario: 'admin')
Estado.create(nombre: 'RETIRADO', abreviatura: 'R', tipo: 1, usuario: 'admin')
Estado.create(nombre: 'NO INSTALADO', abreviatura: 'N', tipo: 1, usuario: 'admin')
Estado.create(nombre: 'PENDIENTE', abreviatura: 'PE', tipo: 2, usuario: 'admin')
Estado.create(nombre: 'ANULADO', abreviatura: 'AN', tipo: 2, usuario: 'admin')
Estado.create(nombre: 'APLICADO', abreviatura: 'AP', tipo: 2, usuario: 'admin')
Estado.create(nombre: 'PAGADO', abreviatura: 'PA', tipo: 2, usuario: 'admin')

Pais.create(nombre: 'COLOMBIA', usuario_id: 1)
Pais.create(nombre: 'PANAMA', usuario_id: 1)
Pais.create(nombre: 'VENEZUELA',usuario_id: 1)
Departamento.create(pais_id: 1, nombre: 'ANTIOQUIA', codigo: '', usuario_id: 1)
Ciudad.create(pais_id: 1, nombre: 'MEDELLIN', codigoDane: '05001', codigoAlterno: '', usuario_id: 1, departamento_id: 1)
Ciudad.create(pais_id: 1, nombre: 'BOGOTA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1, departamento_id: 1)
Ciudad.create(pais_id: 1, nombre: 'BUCARAMANGA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1, departamento_id: 1)
Ciudad.create(pais_id: 1, nombre: 'PEREIRA', codigoDane: '05001', codigoAlterno: '', usuario_id: 1, departamento_id: 1)
Zona.create(ciudad_id: 1, nombre: 'ZONA GENERAL', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'PRADO', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'MIRADOR', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'TRAPICHE', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'SANTA ANA', usuario_id: 1)
Barrio.create(zona_id: 1, nombre: 'BOSTON', usuario_id: 1)
Banco.create(nit: '800226788', nombre: 'CAJA GENERAL', direccion: 'Cll 23 #45-46', ciudad_id: 1, telefono1: '2344556',
telefono2: '0', contacto: '', cuentaBancaria: '1105055', cuentaContable: '', usuario_id: 1)
Banco.create(nit: '900938640', nombre: 'PTO PAGO SUR', direccion: 'Cra 20 #23-45', ciudad_id: 1, telefono1: '4347890',
telefono2: '0', contacto: '', cuentaBancaria: '1234235', cuentaContable: '', usuario_id: 1)
Banco.create(nit: '860002964', nombre: 'PTO PAGO OESTE', direccion: 'Cll 56 #10-9', ciudad_id: 1, telefono1: '7684523',
telefono2: '0', contacto: '', cuentaBancaria: '5667434', cuentaContable: '', usuario_id: 1)
Servicio.create(nombre: 'TELEVISION', usuario_id: 1)
Servicio.create(nombre: 'INTERNET', usuario_id: 1)
Documento.create(nombre: 'FACTURA DE VENTA', abreviatura: 'FTV', usuario_id: 1)
Documento.create(nombre: 'RECIBOS DE CAJA', abreviatura: 'REC', clase: 'P',usuario_id: 1)
Documento.create(nombre: 'COMPROBANTE EGRESO', abreviatura: 'OPA', clase: 'P', usuario_id: 1)
Documento.create(nombre: 'NOTA CRÉDITO', abreviatura: 'CRT', clase: 'P', usuario_id: 1)
Documento.create(nombre: 'NOTA DEBITO', abreviatura: 'DBT', clase: 'P', usuario_id: 1)
Documento.create(nombre: 'DESCUENTOS', abreviatura: 'DST', clase: 'P', usuario_id: 1)
Documento.create(nombre: 'CAUSACIONES', abreviatura: 'CAU', usuario_id: 1)
Documento.create(nombre: 'ORDENES', abreviatura: 'ORD', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '001', nombre: 'SUSCRIPCION TELEVISION', abreviatura: 'AFT',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '002', nombre: 'SUSCRIPCION INTERNET', abreviatura: 'AFI',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '003', nombre: 'MENSUALIDAD TELEVISION', abreviatura: 'MTV',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '004', nombre: 'MENSUALIDAD INTERNET', abreviatura: 'MIN',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '005', nombre: 'PUNTO ADICIONAL TELEVISION', abreviatura: 'ETT',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '006', nombre: 'PUNTO ADICIONAL INTERNET', abreviatura: 'ETI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '007', nombre: 'CORTE TELEVISION', abreviatura: 'COT',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '008', nombre: 'CORTE INTERNET', abreviatura: 'COI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '009', nombre: 'REVISION SEÑAL TELEVISION', abreviatura: 'MAN',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '010', nombre: 'REVISION SEÑAL INTERNET', abreviatura: 'REI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '011', nombre: 'INSTALACION TELEVISION', abreviatura: 'INT',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '012', nombre: 'INSTALACION INTERNET', abreviatura: 'INI',
porcentajeIva: '19', operacion: '+', clase: '', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '013', nombre: 'TRASLADO TELEVISION', abreviatura: 'TRT',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '014', nombre: 'TRASLADO INTERNET', abreviatura: 'TRI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '015', nombre: 'RECONEXIÓN TELEVISION', abreviatura: 'RCT',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '016', nombre: 'RECONEXIÓN INTERNET', abreviatura: 'RCI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '017', nombre: 'RETIRO DEFINITIVO TELEVISION', abreviatura: 'RET',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '018', nombre: 'RETIRO DEFINITIVO INTERNET', abreviatura: 'RTI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '019', nombre: 'MULTA TELEVISION', abreviatura: 'MUT',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '020', nombre: 'MULTA INTERNET', abreviatura: 'MUI',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '021', nombre: 'RECIBO DE CAJA', abreviatura: 'REC',
porcentajeIva: '19', operacion: '+', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '022', nombre: 'NOTA CREDITO TELEVISION', abreviatura: 'CDT',
porcentajeIva: '19', operacion: '-', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '023', nombre: 'NOTA CREDITO INTERNET', abreviatura: 'CDI',
porcentajeIva: '19', operacion: '-', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '024', nombre: 'NOTA DEBITO TELEVISION', abreviatura: 'DBT',
porcentajeIva: '19', operacion: '+', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '025', nombre: 'NOTA DEBITO INTERNET', abreviatura: 'DBI',
porcentajeIva: '19', operacion: '+', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '026', nombre: 'DESCUENTOS TELEVISION', abreviatura: 'DCT',
porcentajeIva: '19', operacion: '-', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 2, codigo: '027', nombre: 'DESCUENTOS INTERNET', abreviatura: 'DCI',
porcentajeIva: '19', operacion: '-', clase: 'P', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '028', nombre: 'ADICCIONAR DECODIFICADORES', abreviatura: 'DCO',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Concepto.create(servicio_id: 1, codigo: '029', nombre: 'RETIRAR DECODIFICADORES', abreviatura: 'RDC',
porcentajeIva: '19', operacion: '+', clase: 'O', usuario_id: 1)
Parametro.create(descripcion: 'Permite anular recibos', valor: 'N')
Parametro.create(descripcion: 'Genera factura de venta', valor: 'S')
Parametro.create(descripcion: 'formato impresion cta cobro', valor: 'ImprimeProvisional')
Parametro.create(descripcion: 'Imprime Fra o Cta cobro', valor: 'N')
Parametro.create(descripcion: 'formato impresion Factura', valor: 'Imprimefac4')
Parametro.create(descripcion: 'Genera recibo en afiliacion', valor: 'N')
Parametro.create(descripcion: 'Tipo facturacion', valor: 'V')
Parametro.create(descripcion: 'Inventario consolidado', valor: 'N')
Parametro.create(descripcion: 'Tarifas x zona', valor: 'N')
Parametro.create(descripcion: 'Habilita fecha ingreso recibo', valor: 'N')
Parametro.create(descripcion: 'Nivel que puede cambiar fecha recibo', valor: '1')
Parametro.create(descripcion: 'Maneja ploiticas de afiliacion', valor: 'N')
Parametro.create(descripcion: 'Dias de politica de afiliacion', valor: '0')
Parametro.create(descripcion: 'Orden de facturacion', valor: 'movcarte.nrofact')
Parametro.create(descripcion: 'Imprime recibo en afiliacion', valor: 'N')
Parametro.create(descripcion: 'Imprime factura en afiliacion', valor: 'N')
Parametro.create(descripcion: 'Nombre clientes', valor: 'SUSCRIPTORES')
Parametro.create(descripcion: 'Nro asociados activos', valor: '0')
Parametro.create(descripcion: 'Maneja base de datos consolidada', valor: 'N')
Parametro.create(descripcion: 'Genera facturacion por zonas', valor: 'S')
Parametro.create(descripcion: 'Imprime estados de cuenta retirados', valor: 'N')
Parametro.create(descripcion: 'Permite cambiar valor de ordenes', valor: 'N')
Parametro.create(descripcion: 'Muestra saldo en listado de suscriptores', valor: 'S')
Parametro.create(descripcion: 'Meses inicio facturacion', valor: '1')
Parametro.create(descripcion: 'Maneja facturacion POS', valor: 'N')
Parametro.create(descripcion: 'Imprime factura al editar instalacion', valor: 'N')
Parametro.create(descripcion: 'Maneja tabla de suscriptores por meses', valor: 'S')
Parametro.create(descripcion: 'Permite ingresar pagos anticipados', valor: 'S')
Parametro.create(descripcion: 'Muestra contrato en impresion estado de cuenta', valor: 'N')
Parametro.create(descripcion: 'Nombre de campo reserva', valor: 'Precinto')
Parametro.create(descripcion: 'Numero copias al imprimir recibo', valor: '1')
Parametro.create(descripcion: 'Imprime en impresora pos', valor: 'S')
Parametro.create(descripcion: 'Imprime recibo al grabar automaticamente', valor: 'N')
Parametro.create(descripcion: 'Imprime bancos en estado de cuenta', valor: 'N')
Parametro.create(descripcion: 'maneja numero de consignacion', valor: 'N')
Parametro.create(descripcion: 'Valor para corte', valor: '36000')
Parametro.create(descripcion: 'muestra pago inmediato en saldo anterior', valor: 'S')
Parametro.create(descripcion: 'Permite ingresar permanencua', valor: 'N')
Parametro.create(descripcion: 'Muestra observaciones en estado de cuenta', valor: 'N')
Parametro.create(descripcion: 'permite cambiar fecha de trabajo', valor: 'N')
Parametro.create(descripcion: 'formato de estado de cuenta', valor: 'V')
Parametro.create(descripcion: 'Imprime factura al generar factura manual', valor: 'N')
Parametro.create(descripcion: 'Permite entrar fecha de facturacion en instalacion', valor: 'N')
Parametro.create(descripcion: 'Muestra opcion listado facturación', valor: 'N')
Parametro.create(descripcion: 'Desarrollo propio', valor: 'N')
Parametro.create(descripcion: 'muestra referencia de pago en desarrollos propios', valor: 'S')
Parametro.create(descripcion: 'sube archivos texto de gana', valor: 'N')
Parametro.create(descripcion: 'sube archivos texto de efecty', valor: 'N')
Parametro.create(descripcion: 'usuario de facturacion', valor: 'COORDINADORA1')
Parametro.create(descripcion: 'codigo del proyecto de efecty', valor: '102')
Parametro.create(descripcion: 'oculta fecha de suspension en estado de cuenta', valor: 'N')
Parametro.create(descripcion: 'Muestra observaciones en estado de cuenta', valor: 'N')
Parametro.create(descripcion: 'permite cambiar fecha de trabajo', valor: 'N')
Parametro.create(descripcion: 'formato de estado de cuenta', valor: 'V')
Parametro.create(descripcion: 'tipo documento que se imprime automaticamente', valor: 'REC')
Parametro.create(descripcion: 'Pregunta si desea generar factura', valor: 'S')
Parametro.create(descripcion: 'numero de copias recibo pos', valor: '1')
Parametro.create(descripcion: 'Descuento discapacitados', valor: '15')
Parametro.create(descripcion: 'Maneja internet en documentos separado', valor: 'S')
Parametro.create(descripcion: 'Maneja direccion de correspondencia', valor: 'S')
Parametro.create(descripcion: 'Maneja nomenclatura DIAN', valor: 'S')
Parametro.create(descripcion: 'Permite modificar valor de afiliación', valor: 'N')
Parametro.create(descripcion: 'Maneja consecutivos separados ordenes', valor: 'N')
Parametro.create(descripcion: 'Permite ordenes en meses anteriores', valor: 'N')
Parametro.create(descripcion: 'Permite ordenes en meses posteriores', valor: 'N')
Parametro.create(descripcion: 'Maneja fecha corte servicio', valor: 'S')
Parametro.create(descripcion: 'Maneja fecha pagos vencidos', valor: 'S')
Parametro.create(descripcion: 'Pregunta si desea cobrar dias al editar instalacion', valor: 'S')
Parametro.create(descripcion: 'Pregunta si desea cobrar dias al editar corte', valor: 'S')
Parametro.create(descripcion: 'Pregunta si desea cobrar dias al editar reconexion', valor: 'S')
Parametro.create(descripcion: 'Pregunta si desea cobrar dias al editar retiro', valor: 'S')
Parametro.create(descripcion: 'Cobra dias al editar instalacion', valor: 'S')
Parametro.create(descripcion: 'Cobra dias al editar corte', valor: 'S')
Parametro.create(descripcion: 'Cobra dias al editar reconexion', valor: 'S')
Parametro.create(descripcion: 'Cobra dias al editar retiro', valor: 'S')
Parametro.create(descripcion: 'Genera factura en reconexion', valor: 'S')
Parametro.create(descripcion: 'Maneja cobradores', valor: 'S')
Parametro.create(descripcion: 'Permite facturas manuales mayor a la tarifa', valor: 'S')
Plan.create(servicio_id: 1, nombre: 'Television', usuario_id: 1)
Plan.create(servicio_id: 2, nombre: 'Internet 2 megas', usuario_id: 1)
Unidad.create(unidad: 'MTS', usuario_id: 1)
Unidad.create(unidad: 'PAQ', usuario_id: 1)
Unidad.create(unidad: 'UND', usuario_id: 1)
Unidad.create(unidad: 'UNI', usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 1, plan_id: 1, valor: '35000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 3, plan_id: 1, valor: '20000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 5, plan_id: 1, valor: '18000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 13, plan_id: 1, valor: '21000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 15, plan_id: 1, valor: '10000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 2, plan_id: 2, valor: '25000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 4, plan_id: 2, valor: '25000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 6, plan_id: 2, valor: '18000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 14, plan_id: 2, valor: '21000', estado_id: 1, usuario_id: 1)
Tarifa.create(zona_id: 1, concepto_id: 16, plan_id: 2, valor: '10000', estado_id: 1, usuario_id: 1)
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
Funcion.create(nombre: 'Representante', usuario_id: 1)
FormaPago.create(nombre: 'Efectivo', usuario_id: 1)
FormaPago.create(nombre: 'Transferencias', usuario_id: 1)
FormaPago.create(nombre: 'Cheque', usuario_id: 1)
FormaPago.create(nombre: 'Consignación', usuario_id: 1)
FormaPago.create(nombre: 'Traslados', usuario_id: 1)
TipoFacturacion.create(nombre: 'ANTICIPADA', usuario_id: 1)
TipoFacturacion.create(nombre: 'VENCIDA', usuario_id: 1)
=begin
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

Empresa.create(tipo: '01', nit: '900353347', razonsocial: 'enlace informatico s.a.s', direccion: 'cra 47 #53-41', 
telefono1: '4540312', telefono2: '', ciudad_id: 2, entidad_id: 50003, logo: '', correo: 'gerencia@enlaceinformatico.com',
regimen: 's', contribuyente: 's', centrocosto: '0001', usuario_id: 1)
Resolucion.create(empresa_id: 1, nroResolucion: '18762002425502', tipo: 'AUTORIZADO', prefijo: 'AR',
rangoRI: '0', rangoRF: '0', rangoI: '0', rangoF: '0', fechainicio: '28/02/2018', 
fechavence: '28/02/2018', usuario_id: 1)

Senal.create(entidad_id: 1, contrato: '4789963', direccion: 'Calle 11 #24-23', urbanizacion: '', 
torre: '', apto: '', barrio_id: 1, zona_id: 1, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4',
vivienda: 'P', observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, 
decos: '', precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 2, contrato: '145665', direccion: 'Cr 47', urbanizacion: '', torre: '', 
apto: '', barrio_id: 2, zona_id: 2, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P',
observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 3, contrato: '369669', direccion: 'Calle 8', urbanizacion: '', torre: '', 
apto: '', barrio_id: 3, zona_id: 3, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4',
vivienda: 'P', observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 4, contrato: '325856', direccion: 'Cr 45', urbanizacion: '', torre: '', 
apto: '', barrio_id: 4, zona_id: 4, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P',
observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 5, contrato: '477586', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 5, zona_id: 5, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 6, contrato: '365899', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 1, zona_id: 1, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 5, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
Senal.create(entidad_id: 7, contrato: '147788', direccion: 'Calle 11 #24-23', urbanizacion: '', torre: '', 
apto: '', barrio_id: 2, zona_id: 2, telefono1: '4540312', telefono2: '', contacto: '', estrato: '4', vivienda: 'P', 
observacion: '', fechacontrato: '01/01/2017', permanencia: '', televisores: 2, decos: '',
precinto: '12321', vendedor_id: 6, tipo_instalacion_id: 1, tecnologia_id: 1, tiposervicio: 'residencial', 
areainstalacion: 'urbana', usuario_id: 1, tipo_facturacion_id: 1)
=end

=begin
InfoInternet.create(senal_id: 1, direccionip: '123.455.566.777', velocidad: '3', mac1: '123.0.0.77', mac2: '', 
serialm: '', marcam: '', mascarasub: '', dns: '128.0.0.0', gateway: '123.4.4.4', nodo: '', 
clavewifi: '353534545', equipo: 'S', usuario_id: 1)
InfoInternet.create(senal_id: 2, direccionip: '123.455.566.777', velocidad: '3', mac1: '123.0.0.77', mac2: '', 
serialm: '', marcam: '', mascarasub: '', dns: '128.0.0.0', gateway: '123.4.4.4', nodo: '', 
clavewifi: '353534545', equipo: 'S', usuario_id: 1)
PlantillaFact.create(senal_id: 1, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 2, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 3, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 4, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 5, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 6, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 7, concepto_id: 3, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 1, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 2, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 3, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 4, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 5, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 6, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)
PlantillaFact.create(senal_id: 7, concepto_id: 4, estado_id: 1, tarifa_id: 3, fechaini: '01/01/2018', 
fechafin: '01/01/2118', usuario_id: 1)


RegistroOrden.create(nombre: 'fecha creacion', usuario_id: 1)
RegistroOrden.create(nombre: 'usuario creacion', usuario_id: 1)
RegistroOrden.create(nombre: 'tecnico asigando', usuario_id: 1)
RegistroOrden.create(nombre: 'fecha ejecucion', usuario_id: 1)
RegistroOrden.create(nombre: 'tecnico ejecucion', usuario_id: 1)
RegistroOrden.create(nombre: 'usuario cierra orden', usuario_id: 1)
RegistroOrden.create(nombre: 'solucion orden', usuario_id: 1)
RegistroOrden.create(nombre: 'fecha anulacion', usuario_id: 1)
RegistroOrden.create(nombre: 'usuario anula orden', usuario_id: 1)
RegistroOrden.create(nombre: 'motivo anulacion', usuario_id: 1)
RegistroOrden.create(nombre: 'solicitado por', usuario_id: 1)

Grupo.create(descripcion: 'INVENTARIOS', usuario_id: 1)
=end

    
    
    
    
    
    







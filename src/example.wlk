class Personaje{
	var casa
	const conyuges = []
	var estaVivo = true
	const acompaniantes = []
	var personalidad
	
	method estaVivo() = estaVivo
	
	method estaSoltero() = conyuges.isEmpty()
	
	method ejecutarAccionConsp(objetivo){
		personalidad.accionConsp(objetivo)
	}
	
	method sacarPorcentajeCasa(porcentaje){
		casa.sacarPorcentaje(porcentaje)
	}
	
	method tieneUnaPareja() = conyuges.size() == 1
	method casa() = casa
	
	method esHodor() = false
	
	method mePuedoCasarCon(otro) = self.casaAdmiteCasCon(otro) && otro.casaAdmiteCasCon(self)
	
	method casaAdmiteCasCon(otro) = casa.puedeCasarse(self,otro)
	
	method patrimonio() = casa.patrimonio() / casa.cantMiembros()
	
	method casarCon(otro){
		self.validarCasamiento(otro)
		self.agregarConyuge(otro)
		otro.agregarConyuge(self)
	}
	
	method validarCasamiento(otro){
		if(self.mePuedoCasarCon(otro)){
			self.error("NO SE PUEDE CASAR")
		}
	}
	
	method agregarConyuge(otro){
		conyuges.add(otro)
	}
	
	method estaSolo() = acompaniantes.isEmpty()
	
	method morir(){
		estaVivo = false
	}
	
	method aliados() = acompaniantes + conyuges + casa.miembros()
	
	method esPeligroso() = estaVivo && self.otrasCondiciones()
	
	method otrasCondiciones() = self.dineroAliadosMayorA1000() || self.conyuguesRicos() || self.alianzaPeligrosa()
	
	method dineroAliadosMayorA1000() = self.aliados().sum({unA => unA.patrimonio()})
	
	method conyuguesRicos() = conyuges.all({unC => unC.casa().esRica()})
	
	method alianzaPeligrosa() = self.aliados().any({unA => unA.esPeligroso()})
	
	method esAliadoCon(alguien) = self.aliados().contains(alguien)
}

object hodor inherits Personaje{
	override method esHodor() = true
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Animal{
	method patrimonio() = 0
}

object dragon inherits Animal{
	method esPeligroso() = true
}

class Lobo inherits Animal{
	const raza
	
	method esPeligroso() = raza == "huargo"
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Casa{
	var patrimonio
	var nombre
	const miembros = []
	
	method miembros() = miembros
	
	method perteneceALaCasa(alguien) = miembros.contains(alguien)
	
	method puedeCasarse(personaje,otro)
	
	method esRica() = patrimonio > 1000
	
	method cantMiembros() = miembros.size()
	method patrimonio() = patrimonio
	
	method sacarPorcentaje(porcentaje){
		patrimonio*= porcentaje
	}
	
	method solterosYVivos() = miembros.filter({unM => unM.estaSoltero() && unM.estaVivo()})
}

object lannister inherits Casa{
	override method puedeCasarse(personaje,otro) = personaje.tieneUnaPareja()
	 
}

object stark inherits Casa{
	override method puedeCasarse(personaje,otro) = self.perteneceALaCasa(otro)
}

object guardiaDeLaNoche inherits Casa{
	override method puedeCasarse(personaje,otro) = false
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

class Conspiracion{
	const complotados = []
	const objetivo
	var fueEjecutada = false
	
	method crearConsp(){
		if(not self.sePuedeRealizar()){
			self.error("NO SE PUEDE CREAR")
		}
	}
	
	method sePuedeRealizar() = not objetivo.esPeligroso() || objetivo.esHodor()
	
	method ejecutarConsp(){
		complotados.forEach({unC => unC.ejecutarAccionConsp(objetivo)})
		fueEjecutada = true
	}
	
	method cantTraidores() = self.traidores().size()
	
	method traidores() = complotados.filter({unC => unC.esAliadoCon(objetivo)})
	
	method conspiracionCumplida() = not objetivo.esPeligroso()
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

object sutil{
	const casas = [lannister,stark,guardiaDeLaNoche]
	
	method accionConsp(objetivo){
		const casaPobre = casas.min({unaC => unaC.patrimonio()})
		const pretendiente = casaPobre.solterosYVivos().anyOne()
		
		if(casaPobre.solterosYVivos().isEmpty() || not objetivo.mePuedoCasarCon(pretendiente)){
			self.error("NO SE PUEDEN CASAR")
		}else{
			objetivo.casarCon(pretendiente)
		}
	}
}

class Asesino{
	method accionConsp(objetivo){
		self.matarA(objetivo)
	}
	
	method matarA(alguien){
		alguien.morir()
	}
}

object asesinoPrecavido inherits Asesino{
	override method accionConsp(objetivo){
		if(objetivo.estaSolo()){
			super(objetivo)
		}
	}
}

class Disipado{
	const porcentaje
	
	method accionConsp(objetivo){
		objetivo.sacarPorcentajeCasa(porcentaje)
	}
}

object miedoso{
	method accionConsp(objetivo){
	}
}
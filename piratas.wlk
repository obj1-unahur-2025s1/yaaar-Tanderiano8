class Pirata {
    const items = []
    var nivelDeEbriedad
    var cantidadDeDinero
    method agregarItem(unItem) {items.add(unItem)}
    method quitarItem(unItem) {items.remove(unItem)}
    method agregarListaDeItems(lista) = items.addAll(lista)
    method esUtilParaMision(unaMision) = unaMision.pirataUtil(self)
    method tieneMenosMonedasQue(cantMonedas) = cantidadDeDinero < cantMonedas 
    method tieneItems(unaLista) = unaLista.any({i => self.tieneItem(i)})
    method tieneItem(unItem) = items.contains(unItem)
    method tieneAlMenosCantidadDeItems(unNumero) = items.size() >= unNumero
    method estaPasadoDeGrog() = nivelDeEbriedad >= 90 
    method seAnimaASaquear(unObjetivo) = unObjetivo.puedeSerSaqueadoPor(self)
    method tieneNivelDeEbriedad(unNumero) = nivelDeEbriedad  >= unNumero
    method beberGrog(cantidad) {nivelDeEbriedad += cantidad} 
    method gastar(unaCantidad) {cantidadDeDinero = (cantidadDeDinero - unaCantidad).max(0)}
    method nivelDeEbriedad() = nivelDeEbriedad 
     
}
class Barco {
    const property tripulantes = #{}
    var misionActual
    var capacidad   
    method agregarTripulante(unTripulante) {if(unTripulante.esUtilParaMision(misionActual) and capacidad > tripulantes.size())tripulantes.add(unTripulante)}    
    method quitarTripulante(unTripulante) {tripulantes.remove(unTripulante)}    
    method tieneSuficienteTripulacion() = tripulantes.size() >= capacidad * 0.9
    method barcoContieneItem(unItem) = tripulantes.any({t => t.tieneItem(unItem)})
    method puedeSerSaqueadoPor(unPirata) = unPirata.estaPasadoDeGrog()
    method esVulnerableA(unBarco) = self.cantidadDeTripulantes() <= unBarco.cantidadDeTripulantes() / 2
    method cantidadDeTripulantes() = tripulantes.size()
    method tripulacionPasadaDeGrog() = tripulantes.all({p=>p.estaPasadoDeGrog()})
    method cambiarMision(nuevaMision) {
        misionActual = nuevaMision
        tripulantes.removeAll(self.piratasQueNoCalificanParaMision(nuevaMision))
        }
    method piratasQueNoCalificanParaMision(unaMision) = tripulantes.filter({p=> not p.esUtilParaMision(unaMision)})
    method anclar(unaCiudad) {
        tripulantes.forEach({t=> t.beberGrog(5)}) /// posible subtarea
        tripulantes.forEach({t=> t.gastar(1)}) /// posible subtarea
        self.removerAlMasBorracho()
        unaCiudad.aumentarHabitantes(1)
    }    
    method removerAlMasBorracho() {tripulantes.remove(self.pirataMasBorracho())}
    method pirataMasBorracho() = tripulantes.max({t=>t.nivelDeEbriedad()})
    method puedeCompletarMision() = misionActual.barcoCumpleCondicion(self)
}
class Ciudad{
    var habitantes
    method aumentarHabitantes(unaCantidad) {habitantes += unaCantidad}
    method puedeSerSaqueadoPor(unPirata) = unPirata.tieneNivelDeEbriedadMasQue(50)
    method esVulnerableA(unBarco) = unBarco.cantidadDeTripulantes() >= habitantes * 0.4 or unBarco.tripulacionPasadaDeGrog() 
}

class Mision{
   method barcoCumpleCondicion(unBarco) = unBarco.tieneSuficienteTripulacion()
}


class MisionBusquedaDelTesoro inherits Mision{
    /// OTRA SOLUCION /// method pirataUtil(unPirata) = unPirata.items().asSet().intersection(itemsRequeridos).isEmpty() /// variable items en Pirata debe ser property para que funciones
    method pirataUtil(unPirata) = unPirata.tieneItems(["brujula","mapa","botella de grog"]) and unPirata.tieneMenosMonedasQue(5) 
    override method barcoCumpleCondicion(unBarco) = unBarco.barcoContieneItem("llave de cofre") and super(unBarco)
}
class MisionConvertirseEnLeyenda inherits Mision{
    const itemObligatorio
    method pirataUtil(unPirata) = unPirata.tieneAlMenosCantidadDeItems(10) and unPirata.tieneItem(itemObligatorio)
}
class MisionDeSaqueo inherits Mision{
    const objetivo
    method pirataUtil(unPirata) =  unPirata.tieneMenosMonedasQue(monedasDeterminadas) and unPirata.seAnimaASaquear(objetivo)
    override method barcoCumpleCondicion(unBarco) = objetivo.esVulnerableA(unBarco) and super(unBarco)
}

object monedasDeterminadas {
    var property cantidad = 0 
}
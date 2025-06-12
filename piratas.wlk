class Pirata {
    const items = []
    var nivelDeEbriedad
    var cantidadDeDinero
    method agregarItem(unItem) {items.add(unItem)}
    method quitarItem(unItem) {items.remove(unItem)}
    method agregarListaDeItems(lista) = items.addAll(lista)
    method esUtilParaMision(unaMision) = unaMision.pirataUtil(self)
    method tieneMenosMonedasQue(cantMonedas) = cantidadDeDinero < cantMonedas 
    method tieneItems(unaLista) = unaLista.all({i => items.contains(i)})
    method tieneItem(unItem) = items.contains(unItem)
    method tieneAlMenosCantidadDeItems(unNumero) = unNumero >= items.size() 
}
class Barco {
    const property tripulantes = #{}
    var misionActual
    var capacidad   
    method agregarTripulante(unTripulante) {if(unTripulante.esUtilParaMision(misionActual))tripulantes.add(unTripulante)}    
    method quitarTripulante(unTripulante) {tripulantes.remove(unTripulante)}    
    method tieneSuficienteTripulacion() = tripulantes.size() >= capacidad * 0.9
    method barcoContieneItem(unItem) = tripulantes.any({t => t.tieneItem(unItem)})
}
class Ciudad{}

class Mision{
   method barcoTieneSuficienteTripulacion(unBarco) = unBarco.tieneSuficienteTripulacion()
}


class MisionBusquedaDelTesoro inherits Mision{
    method pirataUtil(unPirata) = unPirata.tieneItems(["brujula","mapa","botella de grog"]) and unPirata.tieneMenosMonedasQue(5)
    method barcoCumpleCondicion(unBarco) = unBarco.barcoContieneItem("llave de cofre") and self.barcoTieneSuficienteTripulacion(unBarco)
}
class MisionConvertirseEnLeyenda inherits Mision{
    var itemObligatorio
    method pirataUtil(unPirata) = unPirata.tieneAlMenosCantidadDeItems(10) and unPirata.tieneItem(itemObligatorio)
    method barcoCumpleCondicion(unBarco) = self.barcoTieneSuficienteTripulacion(unBarco)
}
class MisionDeSaqueo inherits Mision{
    var property cantidadMonedas 
    method pirataUtil(unPirata) = unPirata.tieneMenosMonedasQue(cantidadMonedas) and 
    method barcoCumpleCondicion(unBarco) = and self.barcoTieneSuficienteTripulacion(unBarco)
}

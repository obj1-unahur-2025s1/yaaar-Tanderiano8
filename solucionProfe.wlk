class BarcoPirata{
    const property tripulantes = #{}
    var mision
    const capacidad
    method cambiarMision(unaMision)
    method agregarTripulante(unTripulante) {if(unTripulante.esUtilParaMision(mision) && capacidad > tripulantes.size())tripulantes.add(unTripulante)}    
    method quitarTripulante(unTripulante) {tripulantes.remove(unTripulante)}    
}



% Base de conocimientos para los animales
frame(animalia, subclase_de([]), propiedades(tiene(celulas_animales))).
frame(cordado, subclase_de(animalia), propiedades(tiene(vertebra), tiene(cuerpo_segmentado))).
frame(invertebrado, subclase_de(animalia), propiedades(no_tiene(vertebra))).

% Clases bajo Cordados
frame(mamifero, subclase_de(cordado), propiedades(tiene(pelo), tiene(glandulas_mamarias))).
frame(carnivoro, subclase_de(mamifero), propiedades(come(carne))).
frame(herbivoro, subclase_de(mamifero), propiedades(come(plantas))).
frame(felidae, subclase_de(carnivoro), propiedades(tiene(garras_afiladas))).
frame(canidae, subclase_de(carnivoro), propiedades(tiene(olfato_agudo))).
frame(panthera, subclase_de(felidae), propiedades(tiene(melena), es(grande))).
frame(felis, subclase_de(felidae), propiedades(es(pequenio), es(agil))).
frame(leon, subclase_de(panthera), propiedades(es(social))).
frame(tigre, subclase_de(panthera), propiedades(tiene(rayas))).

% Aves
frame(ave, subclase_de(cordado), propiedades(tiene(plumas), tiene(pico))).
frame(passeriforme, subclase_de(ave), propiedades(tiene(canto_melodico))).
frame(rapaces, subclase_de(ave), propiedades(tiene(garras_afiladas))).
frame(accipitridae, subclase_de(rapaces), propiedades(tiene(pico_curvado))).
frame(falconidae, subclase_de(rapaces), propiedades(tiene(vision_aguda))).
frame(aquila, subclase_de(accipitridae), propiedades(es(grande))).
frame(buteo, subclase_de(accipitridae), propiedades(es(mediano))).
frame(buteo_jamaicensis, subclase_de(buteo), propiedades(tiene(vientre_claro))).
frame(buteo_platypterus, subclase_de(buteo), propiedades(tiene(vientre_oscuro))).

% Reptiles
frame(reptil, subclase_de(cordado), propiedades(tiene(escamas), pone(huevos))).
frame(escamosos, subclase_de(reptil), propiedades(tiene(escamas))).
frame(crocodylia, subclase_de(reptil), propiedades(tiene(piel_rugosa))).
frame(alligatoridae, subclase_de(crocodylia), propiedades(tiene(cuerpo_masivo))).
frame(crocodylidae, subclase_de(crocodylia), propiedades(tiene(cuerpo_alargado))).
frame(alligator, subclase_de(alligatoridae), propiedades(es(pequenio))).
frame(caiman, subclase_de(alligatoridae), propiedades(es(mediano))).
frame(caiman_crocodilus, subclase_de(caiman), propiedades(tiene(cabeza_grande))).
frame(caiman_yacare, subclase_de(caiman), propiedades(tiene(cabeza_pequenia))).

% Anfibios
frame(anfibio, subclase_de(cordado), propiedades(tiene(piel_humedecida), vive_en(agua_y_tierra))).
frame(anuros, subclase_de(anfibio), propiedades(tiene(patas_traseras_largas))).
frame(urodelos, subclase_de(anfibio), propiedades(tiene(cola_larga))).
frame(hylidae, subclase_de(anuros), propiedades(tiene(piel_adherente))).
frame(bufonidae, subclase_de(anuros), propiedades(tiene(glandulas_venenosas))).
frame(hyla, subclase_de(hylidae), propiedades(es(pequenio))).
frame(phyllomedusa, subclase_de(hylidae), propiedades(es(mediano))).
frame(phyllomedusa_bicolor, subclase_de(phyllomedusa), propiedades(tiene(color_verde))).
frame(phyllomedusa_sauvagii, subclase_de(phyllomedusa), propiedades(tiene(color_gris))).

% Peces
frame(pez, subclase_de(cordado), propiedades(tiene(escamas), tiene(aletas), respira_bajo_agua)).
frame(osteictios, subclase_de(pez), propiedades(tiene(esqueleto_oseo))).
frame(selacimorfos, subclase_de(pez), propiedades(tiene(esqueleto_cartilaginoso))).
frame(clupeidae, subclase_de(osteictios), propiedades(tiene(aletas_adiposas))).
frame(cyprinidae, subclase_de(osteictios), propiedades(tiene(aletas_simples))).
frame(cyprinus, subclase_de(cyprinidae), propiedades(es(pequenio))).
frame(carassius, subclase_de(cyprinidae), propiedades(es(mediano))).
frame(carassius_auratus, subclase_de(carassius), propiedades(tiene(color_dorado))).
frame(carassius_carassius, subclase_de(carassius), propiedades(tiene(color_plateado))).

% Reglas de inferencia para determinar si una clase es subclase de otra
subc(C1, C2) :- frame(C1, subclase_de(C2), _).
subc(C1, C2) :- frame(C1, subclase_de(C3), _), subc(C3, C2).
subclase(X) :- frame(X, subclase_de(_), _).

% Para consultar propiedades incluyendo las heredadas
propiedadesc(Clase, PropiedadesUnicas) :-
    findall(P, propiedad_directa_o_heredada(Clase, P), Propiedades),
    flatten(Propiedades, PropiedadesAplanadas),
    list_to_set(PropiedadesAplanadas, PropiedadesUnicas).

propiedad_directa_o_heredada(Clase, P) :-
    frame(Clase, _, propiedades(P)).
propiedad_directa_o_heredada(Clase, P) :-
    frame(Clase, subclase_de(SuperClase), _),
    SuperClase \= [],
    propiedad_directa_o_heredada(SuperClase, P).

% Para manejar clases sin superclases o cuando no se encuentra la clase
buscar_propiedades_superclases(_, []).

% Para consultar todas las clases representadas en los frames
clases(L) :- findall(X, frame(X, subclase_de(_), propiedades(_)), L).

% Para consultar todas las subclases de una clase
subclases_de(X, L) :- findall(C1, subc(C1, X), L).

% Para consultar todas las superclases de una clase
superclases_de(X, L) :- findall(C1, subc(X, C1), L).

% Para consultar qué objetos tienen UNA propiedad determinada
tiene_propiedad(P, Objs) :-
    findall(X, (frame(X, _, propiedades(L)), member(P, L)), Objs).

% Obtiene todas las propiedades de todos los objetos
todas_propiedades(L) :-
    findall(P, frame(_, _, propiedades(P)), NL),
    flatten(NL, L).

% Obtiene una lista de clases con los objetos que tienen las propiedades
% de la lista de entrada en P
consulta_por_propiedades(P, C) :-
    consulta(P, C1),
    list_to_set(C1, C2),
    sort(C2, C).

consulta([], []).
consulta([H|T], C) :-
    consulta(T, C1),
    tiene_propiedad(H, C2),
    append(C1, C2, C).

% Formatear propiedad para mostrarla de manera amigable
formatear_propiedad((Accion, Objeto), Resultado) :-
    atom_concat(Accion, '(', Temp1),
    atom_concat(Temp1, Objeto, Temp2),
    atom_concat(Temp2, ')', Resultado).
formatear_propiedad(PropiedadSimple, PropiedadSimple) :- atom(PropiedadSimple).

% Verificar si una clase es hoja (no tiene subclases)
es_hoja(Clase) :-
    subclases_de(Clase, L),
    L = [].
#!/bin/bash
salir=0 #si es 1 es salir
while [ $salir -ne 1 ]
do
opcion=$(yad --list \
             --title="SIGRE APACHE" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Instalar_Apache" false "Levantar_Apache" false "Bajar_Apache" false "Reiniciar_Apache")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Inst*) ansible-playbook playbookInstalarApache.yml ;;
	*Levantar*) ansible-playbook LevantarApache.yml ;;
	*Bajar*) ansible-playbook BajarApache.yml ;;
	*Reiniciar*) ansible-playbook ReiniciarApache.yml ;;
    esac
else
    salir=1    
fi
done
sh Principal.sh

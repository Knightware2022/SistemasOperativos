#!/bin/bash
salir=0
while [ $salir -ne 1 ]
do
opcion=$(yad --list \
             --title="SIGRE SSH" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Habilitar_SSH" false "Deshabilitar_SSH")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Habilitar*) ansible-playbook HabilitarSSH.yml ;;
	*Des*) ansible-playbook DeshabilitarSSH.yml ;;

    esac
else
    salir=1
fi
done
sh Principal.sh

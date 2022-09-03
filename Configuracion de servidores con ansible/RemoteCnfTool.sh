#!/bin/bash

InstalacionMinima(){

       ansible-playbook RecursosGenerales.yml
    
}

MenuPrincipal(){
opcion=$(yad --list \
             --title="RemoteCnfTool" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cerrar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Apache" false "My_SQL" false "servicio SSH" false "Instalar_Recursos_Necesarios" false "Salir")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Apa*) MenuApache;;
	*My_*) MenuMySQL;;
	*serv*) MenuSsh;;
	*Inst*) InstalacionMinima;;
	*Sal*) (yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1;;

    esac

else
	salir=1
	yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Gracias por preferirnos" \
    	           --text-align=center
fi
}


MenuApache(){

salirA=0 #si es 1 es salir
while [ $salirA -ne 1 ]
do
opcion=$(yad --list \
             --title="RemoteCnfTool APACHE" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Instalar_Apache" false "Levantar_Apache" false "Bajar_Apache" false "Reiniciar_Apache" false "Salir")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Inst*) ansible-playbook playbookInstalarApache.yml ;;
	*Levantar*) ansible-playbook LevantarApache.yml ;;
	*Bajar*) ansible-playbook BajarApache.yml ;;
	*Reiniciar*) ansible-playbook ReiniciarApache.yml ;;
	*Sal*) (yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirA=1;;
    esac
else
    	salirA=1
	yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No ha seleccionado nada" \
    	           --text-align=center   
fi
done

}

MenuMySQL(){

salirM=0
while [ $salirM -ne 1 ]
do
opcion=$(yad --list \
             --title="RemoteCnfTool MYSQL" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Instalar_MySQL" false "Levantar_MySQL" false "Bajar_MySQL" false "Reiniciar_MySQL" false "Salir")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Inst*) ansible-playbook playbookInstalarSQL.yml ;;
	*Levantar*) ansible-playbook LevantarSQL.yml ;;
	*Bajar*) ansible-playbook BajarSQL.yml ;;
	*Reiniciar*) ansible-playbook ReiniciarSQL.yml ;;
	*Sal*) (yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirM=1;;
    esac
else
    salirM=1
	yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No ha seleccionado nada" \
    	           --text-align=center
fi
done

}

MenuSsh(){

salirS=0
while [ $salirS -ne 1 ]
do
opcion=$(yad --list \
             --title="RemoteCnfTool SSH" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Habilitar_SSH" false "Deshabilitar_SSH" false "Salir")

ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Habilitar*) ansible-playbook HabilitarSSH.yml ;;
	*Des*) ansible-playbook DeshabilitarSSH.yml ;;
	*Sali*) (yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirS=1;;

    esac
else
    	salirS=1
	yad --title="RemoteCnfTool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No ha seleccionado nada" \
    	           --text-align=center
fi
done


}



salir=0
while [ $salir -ne 1 ]
do

MenuPrincipal
 
done





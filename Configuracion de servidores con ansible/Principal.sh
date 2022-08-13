opcion=$(yad --list \
             --title="SIGRE" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cerrar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Apache" false "My_SQL" false "servicio SSH" false "Instalar_Recursos_Necesarios")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Apache*) sh YADapache.sh;;
	*My_SQL*) sh YADMySQL.sh;;
	*servicio*) sh YADssh.sh;;
	*Instala*) sh InstalacionMinima.sh;;

    esac

else
	yad --title="SIGRE" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Gracias por preferirnos" \
    	           --text-align=center
fi

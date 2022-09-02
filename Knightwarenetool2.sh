
#!/bin/bash

VerPing(){

	ping -c 4 8.8.8.8 | yad --list --center --title "Knightwarenetool2" --width=500  --height=400  --text "VER ESTADO DE CONEXION" --column "CON ISP"   --no-buttons

}


VerConexion(){
	nmcli device status|grep ens33 | awk '{print $2"  " $3}'| yad --list --center --title "Knightwarenetool2" --width=200  --height=150  --text "VER ESTADO DE CONEXION" --column " DEL SERVIDOR"   --no-buttons # aclaracion ens33 es MI tarjeta de red
} # con el comando nmcli podemos ver la tarjeta de red, cambiaremos ens33 por el nombre que nos corresponda

LevantarConexion(){
	 ifup ens33 # levanto tarjeta de red
	nmcli device status|grep ens33 | awk '{print $2"  " $3}'| yad --list --center --title "Knightwarenetool2" --width=200  --height=150  --text "LEVANTANDO CONEXION" --column " DEL SERVIDOR"   --no-buttons # informo el estado de la tarjeta de red	
}

BajarConexion(){
	 ifdown ens33 # bajo tarjeta de red
	nmcli device status|grep ens33 | awk '{print $2"  " $3}' | yad --list --center --title "Knightwarenetool2" --width=200  --height=150  --text "BAJANDO CONEXION" --column " DEL SERVIDOR"   --no-buttons # informo estado de tarjeta  de red	
}

Ssh(){
	 systemctl status sshd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "ESTADO " --column " SSH"   --no-buttons #informo estado sel servicio SSH
     }
ConectarSsh(){
	 systemctl start sshd # levanto SSH
	 systemctl status sshd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "CONECTANDO " --column " SSH"   --no-buttons # informo estado de SSH
}


DesconectarSsh(){
	 systemctl stop sshd # detengo servicio SSH
	 systemctl status sshd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "DESCONECTANDO " --column " SSH"   --no-buttons # Bajo servicio SSH	
}

Mysql(){
	 systemctl status mariadb | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "VER ESTADO " --column " MySQL"   --no-buttons # muestro servicio MySQL el cual esta ligado a mariadb
}
ConectarMysql(){
	 systemctl start mariadb # detengo el MySQL server
	 systemctl status mariadb | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "CONECTANDO" --column " MySQL"   --no-buttons # informo el estado del server MySQL
}


DesconectarMysql(){
	 systemctl stop mariadb # detengo el MySQL server
	 systemctl status mariadb | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "DESCONECTANDO" --column " MySQL"   --no-buttons # informo el estado del server MySQL
	}


Apache(){
	  systemctl status httpd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "VER ESTADO" --column " APACHE"   --no-buttons # muestro estado sel servicio de APACHE
	}
ConectarApache(){
	 systemctl start httpd # levanto APACHE
	 systemctl status httpd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "CONECTANDO" --column " APACHE"   --no-buttons # informo el estado del server APACHE
}

DesconectarApache(){
	 systemctl stop httpd # desconecto apache
	 systemctl status httpd | awk 'NR==3{print $2"  "$3"  "$4"  "$5"  "$6"  "$7}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=200  --text "DESCONECTAR" --column " APACHE"   --no-buttons # informo el estado del server APACHE
}

InspeccionarRed(){
	netstat -punta | awk '{print $2"  "$3"  "$4"  "$5"  "$6}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=600  --text "AUDITAR" --column " RED"   --no-buttons
	#consulto estado de la red
}

InspeccionarPuertoslocalhost(){
nmap 'localhost' | awk '{print $1"  "$2"  "$3}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=400  --text "AUDITAR PUERTOS" --column "DEL SERVIDOR"   --no-buttons
	# nmap sobre localhost
}
AuditarPuertoX(){
puerto=$(yad --entry \
	--title="Knightnetool2" \
    --center \
    --width=250 \
    --heigth=80 \
    --text-aling=center \
    --button=Aceptar:0 \
    --button=Cancelar:1 \
    --text="Ingrese el pueto que desea inspeccionar del servidor")
if [ $ans -eq 0 ]
then

	nmap -p $puerto 'localhost'| awk '{print $1"  "$2"  "$3}'| yad --list --center --title "Knightwarenetool2" --width=400  --height=600  --text "AUDITAR" --column " PUERTO"   --no-buttons
else

yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
}

ListarProcesos (){
ps | yad --list --center --title "Knightwarenetool2" --width=400  --height=600  --text "LISTA DE" --column "    PROCESOS ACTIVOS"   --no-buttons
}

TrazarRuta(){
	dom=$(yad --entry \
	--title="Knightnetool2" \
    	--center \
    	--width=250 \
   	--heigth=80 \
   	--text-aling=center \
    	--button=Aceptar:0 \
    	--button=Cancelar:1 \
    	--text="Ingrese el Dominio o IPV4 que desea alcanzar")
if [ $ans -eq 0 ]
then

	traceroute $dom | yad --list --center --title "Knightwarenetool2" --width=600  --height=600  --text "TRAZANDO " --column "RUTA"   --no-buttons
else

yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
}

MenuPrincipal(){

opcion=$(yad --list \
             --title="Knightnetool2" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "CONEXION" false "SSH" false "MySQL" false "APACHE" false "Opciones_Avanzadas"  false "SALIR")
ans=$?

if [ $ans -eq 0 ]
then
    case $opcion in
        *CON*) MenuConexion;;
	*SSH*) MenuSsh;;	
	*MyS*) MenuMySQL;;			      
	*APA*) MenuApache;;
	*es_Ava*) MenuAvanzado;;	
        *SAL*) (yad --title="Knightnetool2" \
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
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
}



MenuConexion(){
salirC=0
while [ $salirC -ne 1 ]
do
opcion=$(yad --list \
             --title="CONEXIONES" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "PING" false "VER_CONEXION" false "LEVANTAR_CONEXION" false "BAJAR_CONEXION" false "VOLVER" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *PI*) VerPing;;
	*VER_CON*) VerConexion;;
	*TAR_CON*) LevantarConexion;;
	*JAR_CON*) BajarConexion;;
	*VOL*)MenuPrincipal;;	
        *SAL*) (yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirC=1;;
        
    esac

else
	salirC=1
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
done
}

MenuSsh(){
salirS=0
while [ $salirS -ne 1 ]
do
opcion=$(yad --list \
             --title="SSH" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "ESTADO_SSH" false "LEVANTAR_SSH" false "BAJAR_SSH" false "VOLVER" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *DO_SSH*) Ssh;;
	*TAR_SSH*) ConectarSsh;;
        *JAR_SSH*) DesconectarSsh;;
	*VOL*)MenuPrincipal;;	
        *SAL*) (yad --title="Knightnetool2" \
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
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
done
}

MenuMySQL(){
salirM=0
while [ $salirM -ne 1 ]
do
opcion=$(yad --list \
             --title="MySQL" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "ESTADO_MySQL" false "LEVANTAR_MySQL" false "BAJAR_MySQL" false "VOLVER" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *DO_MyS*) Mysql;;
	*TAR_MyS*) ConectarMysql;;
        *JAR_MyS*) DesconectarMysql;;
	*VOL*)MenuPrincipal;;	
        *SAL*) (yad --title="Knightnetool2" \
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
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
done
}

MenuApache(){
salirA=0
while [ $salirA -ne 1 ]
do
opcion=$(yad --list \
             --title="APACHE" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "ESTADO_APACHE" false "LEVANTAR_APACHE" false "BAJAR_APACHE" false "VOLVER" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *DO_APA*) Apache;;
	*TAR_APA*) ConectarApache;;
	*JAR_APA*) DesconectarApache;;
	*VOL*)MenuPrincipal;;	
        *SAL*) (yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirA=1
		aafire;; #Eastern egg sale cuando damos salir desde el menu de apache
        
    esac

else
	salirA=1
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
done
}

MenuAvanzado(){
salirAv=0
while [ $salirAv -ne 1 ]
do
opcion=$(yad --list \
             --title="OPCIONES AVANZADAS" \
             --height=400 \
             --width=400 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "INSPECCIONAR_RED" false "INSPECCIONAR_PUERTOS_del_SERVIDOR" false "AUDITAR_PUERTO" false "LISTAR_PROCESOS" false "TRAZAR_RUTA_con_DOMINIO" false "VOLVER" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *NAR_RE*) InspeccionarRed;;
		*NAR_PU*) InspeccionarPuertoslocalhost;;
		*TAR_PU*) AuditarPuertoX;;
		*TAR_PRO*) ListarProcesos;;
		*ZAR_RU*) TrazarRuta;;
		*VOL*)MenuPrincipal;;	
        *SAL*) (yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirAv=1
		
        
    esac

else
	salirAv=1
	yad --title="Knightnetool2" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
done
}

salir=0
while [ $salir -ne 1 ]
do

MenuPrincipal
 
done





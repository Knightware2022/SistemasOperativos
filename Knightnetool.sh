#!/bin/bash


VerConexion(){
	nmcli device status|grep ens33 | awk '{print $3}' # aclaracion ens33 es MI tarjeta de red
	} # con el comando nmcli podemos ver la tarjeta de red, cambiaremos ens33 por el nombre que nos corresponda

LevantarConexion(){
	sudo ifup ens33 # levanto tarjeta de red
	nmcli device status|grep ens33 | awk '{print $3}' # informo el estado de la tarjeta de red	
	}

BajarConexion(){
	sudo ifdown ens33 # bajo tarjeta de red
	nmcli device status|grep ens33 | awk '{print $3}' # informo estado de tarjeta  de red	
	}

Ssh(){#ssh
	sudo systemctl status sshd | awk 'NR==3{print $2}' #informo estado sel servicio SSH
     }
ConectarSsh(){
	sudo systemctl start sshd # levanto SSH
	sudo systemctl status sshd | awk 'NR==3{print $2}' # informo estado de SSH
	}


DesconectarSsh(){
	sudo systemctl stop sshd # detengo servicio SSH
	sudo systemctl status sshd | awk 'NR==3{print $2}' # muestro servicio SSH	
	}

Mysql(){
	sudo systemctl status mariadb | awk 'NR==3{print $2}' # muestro servicio MySQL el cual esta ligado a mariadb
	}
ConectarMysql(){
	sudo systemctl start mariadb # detengo el MySQL server
	sudo systemctl status mariadb | awk 'NR==3{print $2}' # informo el estado del server MySQL
	}


DesconectarMysql(){
	sudo systemctl stop mariadb # detengo el MySQL server
	sudo systemctl status mariadb | awk 'NR==3{print $2}' # informo el estado del server MySQL
	}


Apache(){
	 sudo systemctl status httpd | awk 'NR==3{print $2}' # muestro estado sel servicio de APACHE
	}
ConectarApache(){
	sudo systemctl start httpd # levanto APACHE
	sudo systemctl status httpd | awk 'NR==3{print $2}' # informo el estado del server APACHE
	}

DesconectarApache(){
	sudo systemctl stop httpd # desconecto apache
	sudo systemctl status httpd | awk 'NR==3{print $2}' # informo el estado del server APACHE
	}

opcion=$(yad --list \
             --title="Knightnetool" \
             --height=500 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "PING" false "VER_CONEXION" false "LEVANTAR_CONEXION" false "BAJAR_CONEXION" false "ESTADO_SSH" false "LEVANTAR_SSH" false "BAJAR_SSH" false "ESTADO_MySQL" false "LEVANTAR_MySQL" false "BAJAR_MySQL" false "ESTADO_APACHE" false "LEVANTAR_APACHE" false "BAJAR_APACHE" false "SALIR")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *PI*) ping -c 4 8.8.8.8;;
	*VER_CON*) VerConexion;;
	*TAR_CON*) LevantarConexion;;
	*JAR_CON*) BajarConexion;;
	*DO_SSH*) Ssh;;
	*TAR_SSH*) ConectarSsh;;
        *JAR_SSH*) DesconectarSsh;;
	*DO_MyS*) Mysql;;
	*TAR_MyS*) ConectarMysql;;
        *JAR_MyS*) DesconectarMysql;;		      
	*DO_APA*) Apache;;
	*TAR_APA*) ConectarApache;;
	*JAR_APA*) DesconectarApache;;
        *SAL*) (yad --title="Knightnetool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center);;
        
    esac

else
	yad --title="Knightnetool" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi

#!/bin/bash

BorrarIpTables(){
	iptables -F
	yad --title="KnightwareFirewall" \
    		   		 --center \
    	             --width=300 \
    	             --timeout=2 \
    	             --no-buttons \
    	             --timeout-indicator=bottom \
    	             --text="Borrando iptables" \
    	             --text-align=center
}

ListarIpTables(){
	iptables -L| yad --list --center --title "KnightwareFirewall" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "Lista de reglas iptables"   --no-buttons
}
AuditarPuertos(){
	netstat -punta | yad --list --center --title "KnightwareFirewall" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "Auditoria de puertos"   --no-buttons
	#mostrar puertos 
}

AuditarPuertoX(){
puerto=$(yad --entry \
	--title="KnightwareFirewall" \
    --center \
    --width=250 \
    --heigth=80 \
    --text-aling=center \
    --button=Aceptar:0 \
    --button=Cancelar:1 \
    --text="Ingrese el pueto que desea inspeccionar del servidor")
if [ $ans -eq 0 ]
then

	nmap -p $puerto 'localhost'| awk '{print $1"  "$2"  "$3}'| yad --list --center --title "KnightwareFirewall" --width=400  --height=600  --text "AUDITAR" --column " PUERTO"   --no-buttons
else

yad --title="KnightwareFirewall" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
}



ConvertirEquipoEnFirewall(){
	echo 1 > /proc/sys/net/ipv4/ip_forward # Activamos el bit de forwarding del sistema


	WAN=eth0
	LAN=eth2

	 
	iptables -F


	iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE # Cambiamos la direccion de origen de los paquetes que salen

	iptables -A FORWARD -j ACCEPT	# Permitimos el forward de paquetes

	yad --title="KnightwareFirewall" \
    		   		 --center \
    	             --width=400 \
    	             --timeout=2 \
    	             --no-buttons \
    	             --timeout-indicator=bottom \
    	             --text="Tranformando equipo en Firewall"
    	             --text-align=center
}

VolverAequipoNormal(){

	echo 0 > /proc/sys/net/ipv4/ip_forward # Desactivamos el bit de forwarding del sistema
	iptables -F
}

BloquearPing(){
	iptables -F
	iptables -A INPUT -p icmp -j DROP
	yad --title="KnightwareFirewall" \
    		   		 --center \
    	             --width=300 \
    	             --timeout=2 \
    	             --no-buttons \
    	             --timeout-indicator=bottom \
    	             --text="PING bloqueado!" \
    	             --text-align=center

}

PermitirIngreso(){
	iptables -F
	iptables -A INPUT -p tcp -dport 80 -j ACCEPT
	iptables -A INPUT -p tcp -dport 22 -j ACCEPT # habilitamos SSH
	iptables -A INPUT -p tcp -dport 443 -j ACCEPT #habilito puerto de Apache server
	yad --title="KnightwareFirewall" \
    		   		 --center \
    	             --width=300 \
    	             --timeout=2 \
    	             --no-buttons \
    	             --timeout-indicator=bottom \
    	             --text="Internet habilitada!" \
    	             --text-align=center
	
}

MenuPrincipal(){

opcion=$(yad --list \
             --title="Knightware Firewall" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             false "Borrar_iptables" true "Listar_iptables"  false "Auditar_puertos" false "Inspeccionar_puerto" false "Convertir_equipo_en_firewall" false "Volver_equipo_normal" false "Bloquear_PING" false "Permitir_ingreso" false "SALIR")
ans=$?

if [ $ans -eq 0 ]
then
    case $opcion in
	*rrar_ipt*) BorrarIpTables;;
	*star_ipt*) ListarIpTables;;
	*tar_puer*) AuditarPuertos;;
	*nar_puer*) AuditarPuertoX;;
	*tir_equ*) ConvertirEquipoEnFirewall;;
	*ver_equ*) VolverAequipoNormal;;
	*ear_PI*) BloquearPing;;
	*tir_ing*) PermitirIngreso;;	
	*SAL*) (yad --title="Creador de SISRDadmin" \
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
	yad --title="Creador de SISRDadmin" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="No se ha selecciondo ninguna opcion" \
    	           --text-align=center    
fi
}

salir=0
while [ $salir -ne 1 ]
do
MenuPrincipal 
done

#!/bin/bash

crearUsuario(){	
	useradd -d /home/SISRDadmin -m -c "Administrador Infra Sistema SISRD" SISRDadmin
	grep SISRD /etc/passwd #Esto hará que tenga un intérprete /bin/bash (por valor predeterminado)
	passwd SISRDadmin
	#doy permiso para cat en /var/log/secure
	echo SISRDadmin ALL=NOPASSWD: /bin/cat /var/log/secure>>/etc/sudoers
	
	
	}

CrearUsuarioMySQL(){
	
	mysql -u root -p  -e "CREATE USER 'SISRDadmin'@'localhost' IDENTIFIED BY 'contraseña';
	CREATE DATABASE SISRDdb;
	GRANT ALL PRIVILEGES ON SISRDdb.* TO 'SISRDadmin'@'localhost';
	exit"
	#autorizo a SISRDadmin de linux a usar el SISRDadmin de MySQL sin necesidad de cotraseña
	
	echo '[mysql]'>> ~/.my.cnf
	echo 'user=SISRDadmin'>> ~/.my.cnf
	echo 'password=contraseña'>> ~/.my.cnf
	echo ' '>> ~/.my.cnf
	echo '[mysqldump]'>> ~/.my.cnf
	echo 'user=SISRDadmin'>> ~/.my.cnf
	echo 'password=contraseña'>> ~/.my.cnf
	chmod 600 ~/.my.cnf
	}

GenerarScriptBackupMySQL(){ #Generador de script de Backup
	mkdir /home/SISRDadmin/bin
	mkdir /home/SISRDadmin/bkp
	echo '#!/bin/bash'>>/home/SISRDadmin/bin/MySQLbkp.sh
	echo 'fecha=$(date +%Y%m%d)'>>/home/SISRDadmin/bin/MySQLbkp.sh
	echo 'echo Respaldo iniciado : $(date)'>>/home/SISRDadmin/bin/MySQLbkp.sh
	echo 'mysqldump --no-tablespaces SISRDdb -u SISRDadmin>>/home/SISRDadmin/bkp/My$fecha.sql'>>/home/SISRDadmin/bin/MySQLbkp.sh
	echo 'echo Respaldo finalizado : $(date)>>/home/SISRDadmin/bin/MySQLbkp'>>/home/SISRDadmin/bin/MySQLbkp.sh
	chmod a+x /home/SISRDadmin/bin/MySQLbkp.sh
	chown SISRDadmin /home/SISRDadmin/bin/MySQLbkp.sh
}
cronTab(){
			
	(crontab -l ; echo "0 3 * * * /home/SISRDadmin/bin/MySQLbkp.sh >>/home/SISRDadmin/bin/MySQLbkp.std 2>>/home/SISRDadmin/bin/MySQLbkp.err") | crontab -	
			
}
# verificar que existe el archivo de respaldo ;
verArchResp(){
	ls -lrt /home/SISRDadmin/bkp |awk 'NR==2'  | yad --list --center --title "CreadorSISRDadmin" --width=600  --height=200  --text "VISUALIZADOR KNIGHTWARE tm  " --column "ARCHIVO DE RESPALDO"   --no-buttons	
}
#inspeccionar el archivo de volcado de respaldo
VerArchDeVolcado(){
	less /home/SISRDadmin/bkp/* | yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "ARCHIVO DE VOLCADO"   --no-buttons
}

# verificar los archivos de salida estándar, aca queda el registro del inicio y fin del backup
VerSalidaStd(){
	less /homeSISRDadmin/bin/MySQLbkp.std | yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "SALIDA " --column "STANDARD"   --no-buttons
}
VerSalidaDeErrores(){
	less /home/SISRDadmin/bin/MySQLbkp.err | yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "SALIDA de " --column "ERRORES"   --no-buttons
}

VerUsuariosLogueados(){

	who -u | yad --list --center --title "CreadorSISRDadmin" --width=500  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "USUARIOS"   --no-buttons

}

VerUsuarios(){

	compgen -u | yad --list --center --title "CreadorSISRDadmin" --width=200  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "USUARIOS"   --no-buttons

}

AuditarMalUsoDeSudo(){
	
	sudo cat /var/log/secure | awk '$5=="sudo:" && $8" "$9" "$10=="command not allowed" { print $1"_"$2, $3, $6, $18"_"$19}' | yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "Mal uso de sudo"   --no-buttons 
	
}

LogueosFallidos(){

	sudo cat /var/log/secure | awk '$5=="gdm-password]:" && $8" "$14=="password invalid." { print $1"_"$2, $3, $7, $8, $9, $10, $11, $12, $13, $14}'| yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "Logueos fallidos"   --no-buttons

}

LogueosAlSistema(){

	sudo cat /var/log/secure | awk '$5=="gdm-password]:" && $6== "pam_unix(gdm-password:session):" { print $1"_"$2, $3, $7, $8, $9, $10, $11}'| yad --list --center --title "CreadorSISRDadmin" --width=600  --height=600  --text "VISUALIZADOR KNIGHTWARE tm " --column "Logueos al sistema"   --no-buttons

}


MenuPrincipal(){

opcion=$(yad --list \
             --title="Creador SISRDadmin" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             false "Crear_SISRDadmin" true "Listar_usuarios_logueados"  false "Auditar_logs" false "Listar_usuarios" false "Crear_Usuario_SISadmin_de_MySQL" false "Menu_Backup" false "SALIR")
ans=$?

if [ $ans -eq 0 ]
then
    case $opcion in
	*r_SIS*) crearUsuario;;
	*rios_log*) VerUsuariosLogueados;;
	*tar_log*) MenuAuditarLogs;;
	*tar_usu*) VerUsuarios;;
	*de_My*) CrearUsuarioMySQL;;	
	*u_Bac*) MenuBackup;;		
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

MenuBackup(){

salirB=0
while [ $salirB -ne 1 ]
do
opcion=$(yad --list \
             --title="Creador SISadmin" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Generar_Script_respaldo_MySQL" false "Empezar_Backup_Automatico" false "Verificar"  false "Ver_archivo_de_volcado" false "Ver_salida_std" false "Ver_salida_de_errores" false "Volver" false "SALIR")

ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
	*rar_Scr*) GenerarScriptBackupMySQL;;
	*zar_Bac*) cronTab;;
	*Ver*) verArchResp;;
	*de_volc*) VerArchDeVolcado;;
	*da_std*) VerSalidaStd;;	
	*de_err*) VerSalidaDeErrores;;
	*Vol*) MenuPrincipal;;		
        *SAL*) (yad --title="Creador de SISRDadmin" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirB=1;;
        
    esac

else
	salirB=1
	yad --title="Creador de SISRDadmin" \
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

MenuAuditarLogs(){

salirAu=0
while [ $salirAu -ne 1 ]
do
opcion=$(yad --list \
             --title="Auditar Logueos" \
             --height=400 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Cancelar:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Mal_uso_de_sudo" false "Logueos_fallidos" false "Logueos_al_sistema" false "Volver" false "SALIR")

ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
	*al_uso*) AuditarMalUsoDeSudo;;
	*os_fall*) LogueosFallidos;;
	*al_sis*) LogueosAlSistema;;
	*Vol*) MenuPrincipal;;		
        *SAL*) (yad --title="Creador de SISRDadmin" \
    		   --center \
    	           --width=300 \
    	           --timeout=2 \
    	           --no-buttons \
    	           --timeout-indicator=bottom \
    	           --text="Saliendo" \
    	           --text-align=center)
		salir=1
		salirAu=1;;
        
    esac

else
	salirAu=1
	yad --title="Creador de SISRDadmin" \
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





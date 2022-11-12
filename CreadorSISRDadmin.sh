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
	create DATABASE KnightWareV2;
	GRANT ALL PRIVILEGES ON KnightWareV2.* TO 'SISRDadmin'@'localhost';
	use KnightWareV2;
	create table Deportes(
		idDeporte int primary key,
	    categoria varchar(50) not null,
	    nombre varchar(50) not null unique
	); 
	create table Ocurrencias
	(
		idOcurrencia int primary key,
	    nombre varchar(50) not null unique
	);
	create table Hacen
	(
		idIncidencia int,
	    idOcurrencia int,
	    primary key (idIncidencia,idOcurrencia)
	);
	create table Notifica
	(
		idIncidencia int,
	    idOcurrencia int,
		idEncuentro int,
	    idDeporte int,
	    primary key (idIncidencia,idOcurrencia, idEncuentro)
	);
	create table Genera (
		idResultado int,
	    idEncuentro int,
	    idDeporte int,
	    primary key (idResultado, idEncuentro, idDeporte)
	);
	create table Incidencias
	(
		idIncidencia int,
	    idJugador int,
	    minuto int,
	    puntos int,
	    primary key (idIncidencia)
	);
	create table Resultados
	(
		idResultado int primary key auto_increment
	);
	create table Rankings
	(
		idResultado int primary key,
	    puntuacion int,
	    idEquipo int not null
	);
	create table Particular
	(
		idResultado int primary key,
	    setsGanados int default 0,
	    idEquipo int not null
	    );
	create table Puntos
	(
		idResultado int primary key,
	    puntos int not null default 0,
	    idEquipo int not null
	);
	create table Jugador
	(
		idJugador int primary key,
	    nombre varchar(50) not null,
	    apellido varchar(50) not null,
	    edad int not null,
	    sexo varchar(1),
	    paisNacimiento varchar(30) not null
	#	constraint cstrUnique unique(nombre, apellido)
	);
	create table Equipos
	(
		idDeporte int,
		idEquipo int ,
	    categoria varchar(50) not null,
	    logo varchar(200),
	    nombre varchar(30) not null,
	    pais varchar(30) not null,
	    primary key(idDeporte, idEquipo)
	);
	create table Forman
	(
		idJugador int ,
	    idDeporteEquipo  int,
	    idEquipo int,
	    primary key (idJugador,idEquipo, idDeporteEquipo)
	);
	#select * from Encuentros;
	create table Encuentros
	(
	    idDeporte int,
		idEncuentro int unique,
	    fechaComienzo datetime not null,
	    fechaFinaliza datetime not null,
	    descripcionEncuentro varchar(100) not null,
	    primary key(idDeporte, idEncuentro)
	);

	create table Compite
	(
		idDeporteEncuentro int,
		idEncuentro int,
	    idJugador int,
	    idDeporteEquipo int,
	    idEquipo int,
	    primary key (idDeporteEncuentro, idEncuentro,idEquipo, idDeporteEquipo,idJugador)
	);
	create table Alineacion
	(
		idAlineacion int,
		idJugador int,
	    Poscion varchar(60) not null,
		primary key(idAlineacion, idJugador)
	);
	create table Torneos
	(
		idTorneo int ,
	    idDeporte int,
	    fechaComienzo datetime not null,
	    fechaFinalizado datetime not null,
	    nombreTorneo varchar(50) not null,
	    primary key (idTorneo, idDeporte)
	);

	create table torneosTienenEncuentros(
		idTorneo int , 
	    idDeporteTorneo int, 
	    idEncuentro int,
	    idEquipo int,
	    idDeporteEncuentro int,
	    primary key (idTorneo,idDeporteTorneo, idEncuentro, idEquipo, idDeporteEncuentro)
	);
	create table Usuarios
	(
		idUsuario int primary key
	);
	create table Vip
	(
		idUsuario int primary key,
	    correo varchar(60) not null ,
	    contrasenia varchar(60) not null,
	    nombre varchar(40) not null unique,
	    mesesSuscritos int not null,
	    rol int not null
	);
	create table EquiposFavoritos
	(
		idUsuario int,
	    idEquipoFavorito int,
	    idDeporte int, 
	    primary key (idUsuario,idEquipoFavorito, idDeporte)
	);
	create table DeportesFavoritos
	(
		idUsuario int,
	    deporteFavorito int,
	    primary key (idUsuario,deporteFavorito)
	);
	create table Guest
	(
		idUsuario int primary key,
	    mac varchar(30) not null unique,
	    nombreAutogen varchar(100) not null unique
	);
	create table Visualiza
	(
		idUsuario int,
	    idEncuentro int,
	    idDeporte int,
	    primary key (idUsuario,idEncuentro, idDeporte)
	);	
	create table Publicidad
	(
		idPublicidad int primary key,
	    url varchar(500) unique
	);
	create table Tiene_Usuario
	(
		idPublicidad int,
	    idUsuario int,
	    primary key (idPublicidad,idUsuario)
	);

	create table Utiliza
	(
		idAlineacion int,
	    idEncuentro int,
	    idDeporte int,
	    primary key(idAlineacion,idEncuentro, idDeporte)
	);
	alter table Forman add constraint rs_Unique unique(idJugador); 
	alter table Vip add constraint uk_correo unique(correo);
	alter table Compite add constraint fk_compiteENCU foreign key (idEncuentro, idDeporteEncuentro) references Encuentros(idEncuentro, idDeporte) on delete cascade;
	alter table DeportesFavoritos add constraint fk_depoFavUSU foreign key (idUsuario) references Vip(idUsuario) on delete cascade;
	alter table DeportesFavoritos add constraint fk_depoFavDEPO foreign key (deporteFavorito) references Deportes(idDeporte) on delete cascade;
	alter table Forman add constraint fk_formanJUGA foreign key (idJugador) references Jugador(idJugador) on delete cascade;
	alter table Guest add constraint fk_guest foreign key (idUsuario) references Usuarios(idUsuario) on delete cascade;
	alter table Equipos add constraint fk_idDeporte foreign key (idDeporte) references Deportes(idDeporte);
	alter table Encuentros add constraint fk_idDeporteEn foreign key (idDeporte) references Deportes(idDeporte);
	alter table Tiene_Usuario add constraint fk_tiene_usuPUB foreign key (idPublicidad) references Publicidad(idPublicidad);
	alter table Tiene_Usuario add constraint fk_tiene_usuUSU foreign key (idUsuario) references Guest(idUsuario) on delete cascade;
	alter table Vip add constraint fk_vip foreign key (idUsuario) references Usuarios(idUsuario) on delete cascade;

	alter table Visualiza add constraint fk_visaUSU foreign key (idUsuario) references Usuarios(idUsuario) on delete cascade;
	alter table Jugador add constraint ck_jugaSexo check(sexo = 'f' or sexo = 'm');
	alter table Vip add constraint ck_usuRol check(rol >= 0);
	alter table Vip add constraint ck_vipMesesSus check(mesesSuscritos >= 0);

	alter table Utiliza add CONSTRAINT `fk_utiliALI` FOREIGN KEY (`idAlineacion`) REFERENCES `Alineacion` (`idAlineacion`);
	alter table Hacen add CONSTRAINT `fk_hacenOcu` FOREIGN KEY (`idOcurrencia`) REFERENCES `Ocurrencias` (`idOcurrencia`);
	alter table Hacen add CONSTRAINT `fk_hacenInci` FOREIGN KEY (`idIncidencia`) REFERENCES `Incidencias` (`idIncidencia`);
	alter table Notifica add CONSTRAINT `fk_notificaInci` FOREIGN KEY (idIncidencia, idOcurrencia) REFERENCES Hacen (idIncidencia, idOcurrencia) on delete cascade ;
	alter table EquiposFavoritos add constraint fk_EquipoidUsu foreign key (idUsuario) references VIP(idUsuario) on delete cascade;
	alter table Alineacion add constraint fk_idJugadorAline foreign key (idJugador) references Jugador(idJugador);
	alter table Compite add constraint ck_CompiteDeporte check(idDeporteEncuentro = idDeporteEquipo);

	Alter table Torneos add constraint fk_torneosIndiviDepo foreign key(idDeporte) references Deportes(idDeporte);
	alter table torneosTienenEncuentros add constraint ck_TorneoColeDeporEncuentro check(idDeporteEncuentro = idDeporteTorneo);
	alter table Forman add constraint fk_formanEQUIDepo foreign key (idDeporteEquipo, idEquipo) references Equipos(idDeporte, idEquipo);

	alter table Visualiza add constraint fk_visaENCU foreign key (idDeporte, idEncuentro) references Encuentros(idDeporte, idEncuentro) on delete cascade on update cascade;
	alter table Utiliza add CONSTRAINT `fk_utiliENCU` FOREIGN KEY (idDeporte, idEncuentro) REFERENCES `Encuentros` (idDeporte, idEncuentro) on delete cascade;
	alter table Notifica add CONSTRAINT `fk_notificaEncu` FOREIGN KEY (idDeporte, idEncuentro) REFERENCES `Encuentros` (idDeporte, idEncuentro) on delete cascade;
	alter table EquiposFavoritos add constraint fk_EquipoFavUSU foreign key (idDeporte, idEquipoFavorito) references Equipos(idDeporte, idEquipo);
	alter table Compite add constraint fk_compiteJUGAEquiDepo foreign key (idJugador,idEquipo,idDeporteEquipo) references Forman(idJugador,idEquipo, idDeporteEquipo) ;

	alter table torneosTienenEncuentros add constraint fkTorneoColeTorn foreign key (idTorneo, idDeporteTorneo) references Torneos (idTorneo, idDeporte);
	alter table torneosTienenEncuentros add constraint fkTorneoColeEncu foreign key (idDeporteEncuentro, idEncuentro,idEquipo) references Compite (idDeporteEncuentro,idEncuentro, idEquipo) on delete cascade;
	alter table Encuentros add constraint ck_Fechas check(fechaFinaliza > fechaComienzo);
	alter table Torneos add constraint ck_FechasTorn check(fechaFinalizado > fechaComienzo);

	alter table torneosTienenEncuentros add constraint ck_DepoColecTorn check(idDeporteTorneo = idDeporteEncuentro);

	alter table Rankings add constraint fkInciRAnk foreign key(idResultado) references Resultados(idResultado);
	alter table Particular add constraint fkInciParti foreign key(idResultado) references Resultados(idResultado);
	alter table Puntos add constraint fkInciParti_par foreign key(idResultado) references Resultados(idResultado);

	alter table Genera add constraint fkGeneraResu foreign key(idResultado) references Resultados(idResultado);
	alter table Genera add constraint fkGeneraEve foreign key(idEncuentro, idDeporte) references Encuentros(idEncuentro, idDeporte);
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





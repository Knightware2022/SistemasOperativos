salir=0
while [ salir -ne 1 ]
do
opcion=$(yad --list \
             --title="SIGRE MYSQL" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Instalar_MySQL" false "Levantar_MySQL" false "Bajar_MySQL" false "Reiniciar_MySQL")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Inst*) ansible-playbook playbookInstalarSQL.yml ;;
	*Levantar*) ansible-playbook LevantarSQL.yml ;;
	*Bajar*) ansible-playbook BajarSQL.yml ;;
	*Reiniciar*) ansible-playbook ReiniciarSQL.yml ;;
    esac
else
    salir=1
fi
done
sh Principal.sh

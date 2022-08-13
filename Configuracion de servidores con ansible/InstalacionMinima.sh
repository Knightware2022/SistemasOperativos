salir=0
while [ $salir -ne 1 ]
do
opcion=$(yad --list \
             --title="SIGRE RECURSOS" \
             --height=250 \
             --width=300 \
             --button=Aceptar:0 \
             --button=Volver:1 \
             --center \
             --text="Selecciona una opcion:" \
             --radiolist \
             --column="" \
             --column="Opciones" \
             true "Instalar_recursos_necesarios")
ans=$?
if [ $ans -eq 0 ]
then
    case $opcion in
        *Inst*) ansible-playbook RecursosGenerales.yml ;;
    esac
else
    salir=1
fi
done
sh Principal.sh

#!/bin/bash
echo "##### Inicio de la instalacion de Snort #####"

echo "Instalando DAQ"
cd /home/instalacion/daq-2.0.6
./configure  >> /dev/null
make  >> /dev/null
make install >> /dev/null
echo "Instalando LuaJIT"
cd /home/instalacion/LuaJIT-2.0.5
make >> /dev/null
make install >> /dev/null
echo "Instalando Snort"
cd /home/instalacion/snort-2.9.12
./configure --enable-sourcefire --disable-open-appid  >> /dev/null
make  >> /dev/null
make install >> /dev/null
echo "Ejecutando la configuracion inicial"
ldconfig >> /dev/null
echo "Creando enlaces simbolicos"
ln -s /usr/local/bin/snort /usr/sbin/snort >> /dev/null
echo "Creando directorios de configuracion"
mkdir /etc/snort
mkdir /etc/snort/preproc_rules
mkdir /etc/snort/rules
mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules
echo "Creando archivos basicos de configuracion"
touch /etc/snort/rules/white_list.rules
touch /etc/snort/rules/black_list.rules
touch /etc/snort/rules/local.rules
echo "Dando permisos"
chmod -R 5775 /etc/snort/
chmod -R 5775 /var/log/snort/
chmod -R 5775 /usr/local/lib/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules/
echo "Copiando los archivos de configuracion de snort"
cd /home/instalacion/snort-2.9.12/etc && cp -avr *.conf *.config *.map *.dtd /etc/snort/ >> /dev/null
echo "Copiando los archivos de "
cd /home/instalacion/snort-2.9.12 && cp -avr src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/* /usr/local/lib/snort_dynamicpreprocessor/ >> /dev/null
echo "Configurando"
sed -i "s/include \$RULE\_PATH/#include \$RULE\_PATH/" /etc/snort/snort.conf
sed -i "s/ipvar HOME_NET any/ipvar HOME_NET any/" /etc/snort/snort.conf
sed -i "s/var RULE_PATH ..\/rules/var RULE_PATH \/etc\/snort\/rules/" /etc/snort/snort.conf
sed -i "s/var SO_RULE_PATH ..\/so_rules/var SO_RULE_PATH \/etc\/snort\/so_rules/" /etc/snort/snort.conf
sed -i "s/var PREPROC_RULE_PATH ..\/preproc_rules/var PREPROC_RULE_PATH \/etc\/snort\/preproc_rules/" /etc/snort/snort.conf
sed -i "s/var WHITE_LIST_PATH ..\/rules/var WHITE_LIST_PATH \/etc\/snort\/rules/" /etc/snort/snort.conf
sed -i "s/var BLACK_LIST_PATH ..\/rules/var BLACK_LIST_PATH \/etc\/snort\/rules/" /etc/snort/snort.conf
echo "include \$RULE_PATH/local.rules" >> /etc/snort/snort.conf
echo "Verificando"
snort -T -i eth0 -c /etc/snort/snort.conf
echo "Creando regla de prueba"
echo "alert icmp any any -> \$HOME_NET any (msg:\"ICMP connection attempt\"; sid:1000002; rev:1;)" >> /etc/snort/rules/local.rules
echo "Creando el archivo de logging"
touch /var/log/snort/snort.log

echo "##### Finaliza la instalacion de Snort #####"
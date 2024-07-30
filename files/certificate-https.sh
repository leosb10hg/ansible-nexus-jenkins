#!/bin/bash

# Solicitar los datos al usuario
read -p "Ingrese la contraseña (PASSWORD): " PASSWORD
echo
read -p "Ingrese el nombre del host (HOSTNAME): " HOSTNAME
echo
read -p "Ingrese el nombre del archivo (NAME): " NAME
echo
read -p "Ingrese la dirección IP (IP-ADDRESS): " IP_ADDRESS
echo

# Ejecutar los comandos con los datos proporcionados
keytool -genkeypair -keystore keystore.jks -storepass "$PASSWORD" -keypass "$PASSWORD" -alias jetty -keyalg RSA -keysize 2048 -validity 5000 -dname "CN=$HOSTNAME, OU=Sonatype, O=Sonatype, L=Unspecified, ST=Unspecified, C=US" -ext "SAN=DNS:$HOSTNAME,IP:$IP_ADDRESS" -ext "BC=ca:true"

keytool -exportcert -keystore keystore.jks -alias jetty -rfc > "$NAME.cert"
keytool -importkeystore -srckeystore keystore.jks -destkeystore "$NAME.p12" -deststoretype PKCS12 -srcstorepass "$PASSWORD" -deststorepass "$PASSWORD"
keytool -list -keystore "$NAME.p12" -storetype PKCS12 -storepass "$PASSWORD"
openssl pkcs12 -nokeys -in "$NAME.p12" -out "$NAME.pem" -passin pass:"$PASSWORD"
openssl pkcs12 -nocerts -nodes -in "$NAME.p12" -out "$NAME.key" -passin pass:"$PASSWORD"

echo '┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐'
echo '│                                                                                                                                 │'
echo '│ Certificates generated successfully!                                                                                            │'
echo '│                                                                                                                                 │'
echo '└──│ STEP 1...                                                                                                                    │'
echo '│    Is necesary change the values for the <password> in the file jetty-https.xml in /opt/app/nexus/etc/jetty/jetty-https.xml     │'
echo '│                                                                                                                                 │'
echo '│    Change parameter <password> with the value set in the certificate-https.sh bash                                              │'
echo '│                                                                                                                                 │'
echo '│    <Set name="KeyStorePassword"><password></Set>                                                                                │'
echo '│    <Set name="KeyManagerPassword"><password></Set>                                                                              │'
echo '│    <Set name="TrustStorePassword"><password></Set>                                                                              │'
echo '│                                                                                                                                 │'
echo '└──│ STEP 2...                                                                                                                    │'
echo '│    Modify the file nexus-default.properties in /opt/app/nexus/etc/nexus-default.properties to accept service https.             │'
echo '│    Add parameters                                                                                                               │'
echo '│                                                                                                                                 │'
echo '│    application-port-ssl=8443                                                                                                    │'
echo '│    nexus-args=${jetty.etc}/jetty.xml,${jetty.etc}/jetty-https.xml,${jetty.etc}/jetty-requestlog.xml                             │'
echo '│                                                                                                                                 │'
echo '└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘'

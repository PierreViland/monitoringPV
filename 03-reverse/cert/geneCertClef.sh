#!/bin/bash

# Définition des fichiers
CA_KEY="../../../../../00-serveurLemp/openSSL/ca.key"   #Clef privee du CA
CA_CERT="../../../../../00-serveurLemp/openSSL/ca.crt"  #Certificat du CA

SERVER_KEY="reverseProxy.key"  #Clef privee du serveur
SERVER_CSR="reverseProxy.csr"  #Certificat du serveur en attente de signature Certificate Signing Request
SERVER_CERT="reverseProxy.crt" #Certificat du serveur
SERVER_EXT="reverseProxy.ext"  #Contient des options pour la generation du certificat serveur (pas utilise apres)

# Common name du CA
CA_CN="CA_Broce"	#Nom courant du CA

# Variables du serveur
SERVER_CN="reverseProxy.com"   #Nom courant du serveur
IP_SERVER="192.168.1.30"        #Adresse IP du serveur


# Création de la CA SI VOUS VOULEZ UN NOUVEAU CA => Decommente
#echo "Création de la clé privée de la CA..."
#openssl genrsa -out $CA_KEY 2048

#echo "Création du certificat auto-signé de la CA..."
#openssl req -x509 -new -key $CA_KEY -sha256 -days 3650 -out $CA_CERT -subj "/CN=$CA_CN"

# Création de la clé privée du serveur
echo "Création de la clé privée du serveur..."
#openssl genrsa -out $SERVER_KEY 2048

# Création de la demande de signature du certificat serveur (CSR)
echo "Création de la demande de certificat du serveur..."
#openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "/CN=$SERVER_CN"

# Ajout de l'IP dans SAN
cat > $SERVER_EXT <<EOF
[ v3_ext ]
subjectAltName = IP:$IP_SERVER
EOF

# Signature du certificat du serveur par la CA
echo "Signature du certificat serveur avec la CA..."
openssl x509 -req -in $SERVER_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $SERVER_CERT -days 365 -sha256 -extfile $SERVER_EXT -extensions v3_ext

echo "Certificats générés avec succès => Certificat : "
openssl x509 -in $SERVER_CERT  -text -noout

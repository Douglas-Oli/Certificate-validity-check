#!/bin/bash
# -----------------------------------------------------------------------
# Script criado em 17/09/2024 por Douglas Oli. Silva
# Email: contact@douglas-olis.com.br
#
# Compatível com Nagios Plugin - Permite verificar a validade  de
# certificados de um domínio.
# -----------------------------------------------------------------------

# Define o nome do servidor e a porta (465 para SMTPS)
SERVER_NAME="$1"
PORT="$2"

# Obtem a data de expiração do certificado
expiration_date=$(echo | openssl s_client -connect "$SERVER_NAME:$PORT" -servername "$SERVER_NAME" 2>/dev/null | openssl x509 -noout -enddate) # O echo foi necessário
# Foi constatado que o comando openssl s_client espera por uma entrada adicional antes de liberar o terminal e que pode se usar echo para enviar um comando de término, como QUIT, para o openssl s_client.

# Verifica se o comando obteve a data de expiração
if [ -z "$expiration_date" ]; then
    echo "Não foi possível obter o certificado. Verifique o servidor e a porta."
    exit 1
fi

# Extrai a data da string
expiration_date=${expiration_date#*=}

# Converte a data de expiração para o formato epoch
expiration_epoch=$(date -d "$expiration_date" +%s)

# Obtem a data atual em formato epoch
current_epoch=$(date +%s)

# Calcula a diferença em dias
days_until_expiration=$(( (expiration_epoch - current_epoch) / 86400 ))

# Verifica o intervalo de validade do certificado
if [[ "$days_until_expiration" -le 45 && "$days_until_expiration" -ge 10 ]]; then
    echo "WARNING - $SERVER_NAME -O certificado expira em $days_until_expiration dias."
    exit 1
elif [[ "$days_until_expiration" -le 10 ]]; then
    echo "CRITICAL - $SERVER_NAME - O certificado expira em $days_until_expiration dias."
    exit 2
else
    echo "OK - $SERVER_NAME - O certificado é válido por mais de 45 dias. Validade atual: $days_until_expiration dias."
    exit 0
fi

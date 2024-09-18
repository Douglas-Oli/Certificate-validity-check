# Verificador de Validade de Certificados
Este script Bash foi criado para verificar a validade de certificados SSL de um domínio, permitindo sua integração como um plugin no Nagios.

## Informações
Autor: Douglas Oli. Silva
Email: contact@douglas-olis.com.br
Data de Criação: 17/09/2024
## Requisitos
- Linux com bash
- openssl
- Acesso à internet para realizar a verificação do certificado

## Uso
O script aceita dois argumentos:

- `SERVER_NAME`: O nome do servidor ou domínio que você deseja verificar.
- `PORT`: A porta a ser utilizada (465 para SMTPS, por exemplo).

## Sintaxe
```
./verificador_certificado.sh <SERVER_NAME> <PORT>
```
**Exemplo:**
```
./verificador_certificado.sh exemplo.com 465
```

## Funcionamento
O script usa openssl s_client para conectar ao servidor e obter a data de expiração do certificado.
Se não conseguir obter a data, exibe uma mensagem de erro e sai com código 1.
A data de expiração é convertida para o formato epoch e a diferença em dias é calculada.
Dependendo do número de dias restantes até a expiração do certificado, o script retornará:
- `0 (OK)` se o certificado é válido por mais de 45 dias.
- `1 (WARNING)` se o certificado expira em 10 a 45 dias.
- `2 (CRITICAL)` se o certificado expira em menos de 10 dias.

### Saídas

- **OK: **O certificado é válido por mais de 45 dias.
- **WARNING:** O certificado expira em 10 a 45 dias.
- **CRITICAL: **O certificado expira em menos de 10 dias.
- **Erro: **Não foi possível obter o certificado.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou enviar um pull request.

## Licença
Este projeto não possui uma licença definida. Sinta-se à vontade para usar e modificar conforme necessário.

> Para qualquer dúvida ou sugestão, entre em contato pelo email acima.

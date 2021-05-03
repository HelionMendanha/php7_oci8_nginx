# DockerPhp-FpmPdoOci
Dokerfile da criação de imagem docker com php e drivers (oci8/pdo_oci) 

*********
Dependências / Arquivos
*********
<< Baixe os seguintes arquivos do site da Oracle >>
-  `instantclient-basic-linux.x64-21.1.0.0.0.zip`
-  `instantclient-sdk-linux.x64-21.1.0.0.0.zip`
-  `instantclient-sqlplus-linux.x64-21.1.0.0.0.zip`

*********
Gerando Build
*********
nohup docker build -t helionmendanha/php7_oci8_nginx:7.3.28 . &

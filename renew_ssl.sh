#! /bin/bash


# space delimited

###### ADJUST THE FOLLOWING LINE #####
# NOTE: In most cases you will need only one domain, the second one is just an example
domains=("subdomain1.mydomain.com" "subdomain2.mydomain.com")

##### NO NEED TO AJUST ANYTHING BELOW THIS LINE ########
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

cd $SCRIPTPATH
for domain in "${domains[@]}"
do
    mkdir -p ${SCRIPTPATH}/www/pub/$domain/.well-known/acme-challenge
    mkdir -p ${SCRIPTPATH}/ssl/$domain
    docker run \
         -it \
         -v ${SCRIPTPATH}/ssl:/data \
         -v ${SCRIPTPATH}/www/pub/:/webroot -u $(id -u) \
         --rm zerossl/client \
         --key $domain/account.key \
         --csr $domain/domain.csr \
         --csr-key $domain/domain.key \
         --crt $domain/domain.crt \
         --domains "$domain" \
         --generate-missing \
         --path /webroot/$domain/.well-known/acme-challenge \
         --unlink --live

   cat >${SCRIPTPATH}/conf.d/${domain}.conf <<EOL
     server {
        listen     443;
        ssl        on;
        server_name ${domain};
        ssl_certificate /etc/nginx/ssl/${domain}/domain.crt;
        ssl_certificate_key /etc/nginx/ssl/${domain}/domain.key;
        location / {
            proxy_pass http://metabase:3000;
        }
    }
EOL
done

${SCRIPTPATH}/stop.sh
${SCRIPTPATH}/start.sh

#!/bin/bash

mkdir /var/pangolin
cd /var/pangolin

git config --global init.defaultBranch main
read -p "Git E-Mail: " MAIL
read -p "Git Username: " NAME
git config --global user.email "$MAIL"
git config --global user.name "$NAME"

git init

wget -O dyndns.bash "https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/dyndns.bash" && chmod +x ./dyndns.bash
wget -O installer "https://github.com/fosrl/pangolin/releases/latest/download/installer_linux_$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')" && chmod +x ./installer

read -p "DynDNS Domain: " ZONE
read -p "Auth Token: " TK

cat <<EOL > .cron-env
ZONE=$ZONE
TK=$TK
EOL

./dyndns.bash
./installer

git add --all
git commit -m installer

sed -i 's+image: fosrl/pangolin:.*+image: fosrl/pangolin:latest+g' docker-compose.yml
sed -i 's+image: fosrl/gerbil:.*+image: fosrl/gerbil:latest+g' docker-compose.yml
sed -i 's+image: traefik:.*+image: traefik:v3+g' docker-compose.yml

cat <<'EOL' > update.bash
#!/bin/bash
cd /var/pangolin
git add --all
git commit -m $(date "+%Y%m%d%H%M%S")
docker compose pull
docker compose build --pull
docker compose up -d
docker system prune -a -f
EOL
cat update.bash
chmod +x update.bash

git add --all
git commit -m autoupdate

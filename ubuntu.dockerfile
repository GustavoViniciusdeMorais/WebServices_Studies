FROM gustavovinicius/webserver:jenkins

# RUN apt update

# RUN apt install nginx -y

# RUN apt install nano

# RUN apt install curl -y

# RUN apt update

# RUN apt install systemctl -y

# RUN mkdir /var/www/mysite

# RUN mkdir /var/www/other

ENTRYPOINT ["tail", "-f", "/dev/null"]
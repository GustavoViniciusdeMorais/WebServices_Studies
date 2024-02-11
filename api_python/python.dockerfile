FROM gustavovinicius/guspy:fastapi
WORKDIR /code
EXPOSE 8000
ENTRYPOINT ["tail", "-f", "/dev/null"]
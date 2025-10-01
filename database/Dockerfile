FROM postgres:16-alpine

#Installe postgresql-contrib si nécessaire
RUN apk add --no-cache postgresql-contrib

#Copie le script init.sql
COPY init.sql /docker-entrypoint-initdb.d/

#Définit un healthcheck avec pg_isready
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pg_isready -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-postgres} || exit 1


EXPOSE 5432
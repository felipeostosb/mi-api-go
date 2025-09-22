# ---- Fase de Construcción ----
# Usamos una imagen oficial de Go como base para compilar nuestra app
FROM golang:1.25-alpine AS builder

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos de módulos para descargar dependencias
COPY go.mod ./
# COPY go.sum ./
RUN go mod download

# Copiamos el resto del código fuente
COPY . .

# Compilamos la aplicación. Las flags son para crear un binario estático y pequeño
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mi-api-go .

# ---- Fase Final ----
# Usamos una imagen base mínima ya que solo necesitamos el binario compilado
FROM alpine:latest

WORKDIR /root/

# Copiamos el binario compilado desde la fase de construcción
COPY --from=builder /app/mi-api-go .

# Exponemos el puerto 8080, que es el que usa nuestra app
EXPOSE 8080

# Este es el comando que se ejecutará cuando el contenedor inicie
CMD ["./mi-api-go"]
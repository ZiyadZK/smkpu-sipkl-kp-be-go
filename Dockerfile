# Use the official Golang image as a build environment
FROM golang:1.21 AS builder

# Set the working directory
WORKDIR /app

# Copy the Go modules manifest and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go app
RUN go build -o main .

# Use a lightweight image for the final stage
FROM gcr.io/distroless/base-debian11

# Copy the compiled Go binary
COPY --from=builder /app/main /main

# Expose port 8080 to the outside world
EXPOSE 8080

# Command to run the executable
CMD ["/main"]

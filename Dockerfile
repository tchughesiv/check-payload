FROM registry.ci.openshift.org/ocp/builder:rhel-8-golang-1.20-openshift-4.14 AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download
COPY . ./
RUN make

FROM registry.ci.openshift.org/ocp/4.14:base
RUN dnf -y update && dnf install -y binutils go file && dnf clean all
COPY --from=builder /app/check-payload /check-payload

ENTRYPOINT ["/check-payload"]
LABEL com.redhat.component="check-payload"

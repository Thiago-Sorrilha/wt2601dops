.PHONY: start stop restart clean status

KUBE_DIR=kube
FILES=$(KUBE_DIR)/postgres.yaml $(KUBE_DIR)/authentik.yaml $(KUBE_DIR)/keycloak.yaml $(KUBE_DIR)/whoami.yaml $(KUBE_DIR)/traefik.yaml

start:
	@echo "A iniciar a infraestrutura com Podman..."
	@for file in $(FILES); do \
		echo "A aplicar $$file..."; \
		podman kube play $$file; \
	done
	@echo "Tudo inicializado com sucesso!"

stop:
	@echo "A parar a infraestrutura..."
	@for file in $(FILES); do \
		echo "A remover $$file..."; \
		podman kube down $$file || true; \
	done
	@echo "Infraestrutura parada."

clean: stop
	@echo "A limpar volumes e caches do Podman..."
	podman volume prune -f
	@echo "Ambiente limpo."

restart: stop start

status:
	podman pod ps
	podman ps
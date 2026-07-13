.PHONY: start stop clean

start:
	@echo "Iniciar a infraestrutura..."
	# Criando os recursos do banco primeiro
	podman kube play kube/postgres.yaml
	podman kube play kube/authentik.yaml
	podman kube play kube/traefik.yaml
	podman kube play kube/postgres.yaml
	@echo "Aguardando manifestos serem aplicados..."

stop:
	@echo "Parar a infraestrutura..."
	podman kube down kube/postgres.yaml || true

clean: stop
	@echo "Limpar volumes e resquícios..."
	# Remove os volumes criados pelo podman kube play
	podman volume rm postgres-pvc || true
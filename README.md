# wt2601dops
Practical Challenge

For simplicity the PoC stores credentials in ConfigMaps/environment variables. In production these values should be Kubernetes Secrets.

Because the deployment is executed with rootless Podman, privileged ports (80/443) cannot be bound without changing system configuration. Therefore Traefik is exposed on ports 8080 and 8443, preserving the same architecture while respecting the challenge requirement of running without root privileges.



#authentik configs:
  user: akadmin
  Pass: ChangeMe123!

  alterar no traefik  o servers:- url: http://localhost:9000


  Keycloak → autentica os usuários.
Authentik → usa o Keycloak como provedor de identidade.
Traefik → protege o whoami usando o Authentik.

C:\Windows\System32\drivers\etc\hosts
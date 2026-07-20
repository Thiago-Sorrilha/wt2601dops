# wt2601dops
Practical Challenge

Keycloak → autentica os usuários.
Authentik → usa o Keycloak como provedor de identidade.
Traefik → protege o whoami usando o Authentik.

Adicionar
127.0.0.1 authentik.localhost keycloak.localhost whoami.localhost
C:\Windows\System32\drivers\etc\hosts

Depois das aplicações UP:

1. Keycloak — criar o realm, utilizador e client SAML
Acede a http://keycloak.localhost:8080 → login admin/admin.
1.1 Realm
Create Realm → nome wavecom → Create
1.2 Utilizador de teste
Users → Add user → username thiago → Create
Aba Credentials → Set password → define uma password → desliga Temporary → Save

1.3 Client SAML
Clients → Create client
Client type: SAML
Client ID: http://authentik.localhost:8080/source/saml/keycloak/metadata/
Name: Authentik SP → Next → Save
Dentro do client, aba Settings:
Home URL: http://authentik.localhost:8080
Valid redirect URIs: http://authentik.localhost:8080/source/saml/keycloak/acs/
Master SAML Processing URL: http://authentik.localhost:8080/source/saml/keycloak/acs/

Aba Keys (ou secção "Signature and Encryption" dentro de Settings, dependendo da versão): confirma que Client signature required está desligado
Save

2. Authentik — configuração completa
Acede a http://authentik.localhost:8080 → login akadmin / ChangeMe123!.
2.1 Criar a SAML Source

Directory → Federation and Social login → New Source → tipo SAML Source
Name: Keycloak / Slug: keycloak
User matching mode / Group matching mode: Link users on unique identifier
Expande Protocol settings:

SSO URL: http://keycloak.localhost:8080/realms/wavecom/protocol/saml
Issuer: http://authentik.localhost:8080/source/saml/keycloak/metadata/
Binding Type: Redirect binding
Signing keypair: deixa vazio
NameID Policy: Email address (não deixes em X509 Subject, dá erro de validação)


Finish

4.2 Mostrar a Source no ecrã de login

Flows and Stages → Flows → default-authentication-flow
Aba Stage Bindings → localiza default-authentication-identification → Edit Stage
Secção Source settings → Selected sources: adiciona Keycloak
Update

4.3 Proxy Provider + Application (proteger o Whoami)

Applications → Providers → Create → tipo Proxy Provider

Name: whoami-proxy
Mode: Forward auth (single application)
External host: http://whoami.localhost:8080
Finish
No ecrã do provider, botão Create ao lado de Assigned to application:
Name: Whoami / Slug: whoami / Provider: whoami-proxy → Create


4.4 Embedded Outpost

Applications → Outposts → editar (lápis) authentik Embedded Outpost
Confirma Whoami marcado em Selected Applications
Advanced settings → no editor YAML, define (linhas authentik_host e authentik_host_browser):

yamlauthentik_host: "http://authentik.localhost:8080"
authentik_host_browser: "http://authentik.localhost:8080"

Update

5. Testar
Separador anónimo/privado novo → http://whoami.localhost:8080/

Redireciona para login do Authentik
Clica no ícone/botão do Keycloak
Login com thiago + a password que definiste
Deve voltar para whoami.localhost já autenticado, mostrando os headers X-authentik-*
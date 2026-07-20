Please answer the following questions in your README.md. We are looking for clear,
architectural thinking rather than textbook definitions.

1. Analise o ciclo de vida da requisição: como o Traefik e o Authentik interagem para bloquear
   uma requisição não autenticada, redirecionar o usuário para o provedor SAML e, por fim,
   conceder acesso ao serviço de backend?
   R: Bloqueio: o traefik intercepta para verificar se o usuario está autenticado,
      Redirecionamento: ao ver que nao está autenticado ele direciona para o Authentik, e como o Authentik está integrado ao keycloak, ele autentica.
      Autenticação: Sendo um user já constando no Keycloak ele libera o acesso.


2. Ao converter essa arquitetura do Docker Compose padrão para manifestos do Kubernetes destinados ao `podman kube play`, 
   como você lidará com o DNS interno e a descoberta de serviços entre o Traefik, o Authentik, o provedor SAML externo e o PostgreSQL?
   R: o Podman trata isto automaticamente, usando os services de cada serviço, criado um DNS automático internamente.


3. Imagine que você executa seu Makefile, todos os contêineres iniciam e você se autentica com sucesso no seu provedor SAML. 
No entanto, em vez de ver a página "Whoami", seu navegador exibe um erro "502 Bad Gateway" do Traefik. 
Qual é a sua metodologia passo a passo para isolar a falha dentro desse conjunto específico de ferramentas?
   R: 1- Verificar status dos Pods: ex: podman ps -a
      2- Analise dos logs do Traefik: ex: podman logs traefik
      3- Verificação dos yaml: deployment da app, services
      4- Testar conectividade interna: curl, wget
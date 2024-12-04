# Projeto Consulta CEPs

## Descrição
O **Projeto Consulta CEPs** é uma aplicação desenvolvida em **Delphi**, composta por uma **API Backend** utilizando o framework **Horse** e uma interface frontend também em Delphi. A solução é projetada para realizar consultas de CEPs, retornando dados em formato JSON a partir de uma base de dados. Além disso, a aplicação está configurada para ser executada em ambientes containerizados com Docker.

## Funcionalidades
- **API Backend**
  - Permite consultar CEPs na base de dados.
  - Retorna resultados em formato JSON.
- **Frontend**
  - Interface gráfica para consulta de CEPs.
  - Permite configurar consultas automáticas para faixas de CEP.
- **Execução em Docker**
  - Configuração simplificada para implantação em containers.

## Tecnologias Utilizadas
- **Delphi**: Desenvolvimento do backend e frontend.
- **Horse Framework**: Estruturação da API.
- **Docker**: Containerização do projeto.
- **MySQL**: Base de dados para a API.

## Configuração do Ambiente

### Requisitos
- Docker e Docker Compose instalados.
- Delphi configurado para compilação do projeto.
- Banco de dados MySQL.

### Configuração do Docker
Arquivo `src/docker/docker-compose.yml`:
```yaml
docker-compose up -d
```
Inclui configurações para:
- MySQL (base de dados principal).

### Configuração do Docker api
Arquivo `src/docker/docker-api/dockerfile`:
1. Compile o projeto Delphi (pasta `src/backend/api_consultaCeps.dpr`).
2. Cole o arquivo gerado no diretorio do dockerfile `src/docker/docker-api`
3. Certifique-se de que as variáveis de ambiente no Docker estão configuradas para conectar ao MySQL.
4. Execute o container da API com:

```bash
# Comando para construir a imagem
 docker build -t api/consultaceps .

# Comando para rodar o contêiner
 docker run --env-file .env -p 8082:8082 -d api/consultaceps
```
Inclui configurações para:
- API (compilação e execução).


### Frontend
1. Compile a aplicação Delphi do frontend (pasta `src/frontend/vclConsultaCEP.dpr`).
2. Inicie o programa.

## Funcionalidades Avançadas
- **Consultas Automáticas**:
  - Configure uma faixa de CEPs e intervalo de execução.
  - Habilite pelo frontend, utilizando threads para evitar travamentos.
- **Cache de Resultados**:
  - Resultados de consultas são armazenados no PostgreSQL para melhorar a eficiência.
  - A aplicação consulta o cache antes de realizar novas chamadas à API.



## Como Usar
### Consultar CEP
1. Insira o CEP no campo apropriado no frontend.
2. Clique em **Consultar**.
3. Os resultados serão exibidos e armazenados no banco de dados.

### Configurar Consulta Automática
1. Defina a faixa de CEPs e o intervalo de execução no frontend.
2. Clique em **Configurar**.
3. Acompanhe o status na barra de progresso.

## Contribuição
Sugestões e melhorias são bem-vindas. Envie um pull request ou entre em contato com o desenvolvedor.

## Licença
Este projeto é de uso privado e não possui licença aberta no momento.


# Documento de Requisitos - E-commerce Backend

## Objetivo
Desenvolver um backend completo para um sistema de e-commerce, utilizando Node.js e Express com PostgreSQL. O sistema será responsável por gerenciar os produtos, usuários, pedidos e pagamentos, além de funcionalidades de carrinho e autenticação.

## Requisitos Funcionais

1. **Gerenciamento de Usuários**
   - Registrar novos usuários com dados como nome, e-mail e senha.
   - Autenticação de usuários utilizando JWT (JSON Web Token).
   - Login de usuários utilizando e-mail e senha.
   - Recuperação de senha via e-mail.
   - Atualização de perfil do usuário.
   - Exclusão de conta de usuário.
   - Listar informações básicas de outros usuários (somente admin).

2. **Gerenciamento de Produtos**
   - Adicionar novos produtos com campos como nome, descrição, preço, quantidade em estoque, categoria e imagens.
   - Atualizar detalhes dos produtos.
   - Deletar produtos (somente admin).
   - Listar todos os produtos com paginação e filtros (por categoria, preço, popularidade).
   - Buscar produtos por nome ou descrição.
   - Exibir detalhes de um produto específico.

3. **Gerenciamento de Categorias**
   - Adicionar e deletar categorias de produtos.
   - Listar todas as categorias disponíveis.

4. **Carrinho de Compras**
   - Adicionar produtos ao carrinho.
   - Atualizar a quantidade de produtos no carrinho.
   - Remover produtos do carrinho.
   - Exibir o conteúdo atual do carrinho de compras.
   - Limpar o carrinho de compras (remover todos os itens).

5. **Pedidos**
   - Criar um pedido a partir dos itens no carrinho de compras.
   - Exibir o histórico de pedidos do usuário.
   - Cancelar pedidos (se o pedido ainda não foi processado).
   - Exibir detalhes de um pedido (produtos, quantidade, status).
   - Atualizar status do pedido (somente admin).

6. **Gerenciamento de Pagamentos**
   - Integração com gateway de pagamento (ex: Stripe, PayPal).
   - Processar pagamento dos pedidos e verificar status de sucesso/falha.
   - Armazenar informações do pagamento e associar ao pedido.
   - Exibir detalhes do pagamento de um pedido (data, valor, status).

7. **Autenticação e Autorização**
   - Autenticação via JWT.
   - Middleware de proteção de rotas para usuários autenticados.
   - Middleware de autorização para verificar permissões (ex: admin).

## Requisitos Não Funcionais

1. **Banco de Dados**
   - PostgreSQL será utilizado como banco de dados relacional.
   - Utilizar migrações para controle de versão do banco de dados.
   - Consultas SQL otimizadas para performance.

2. **Escalabilidade**
   - O sistema deve ser projetado para suportar crescimento, tanto em termos de número de usuários quanto de produtos e pedidos.

3. **Segurança**
   - Criptografia de senhas utilizando bcrypt.
   - Tokens JWT com validade limitada.
   - Proteção contra ataques comuns (SQL Injection, XSS, CSRF).

4. **Testes**
   - Cobertura de testes unitários e de integração utilizando Jest.
   - Testes de API para verificar o comportamento de todas as rotas principais.

5. **Logs e Monitoramento**
   - Logs de erros e acessos em arquivos separados.
   - Integração com uma ferramenta de monitoramento (ex: Loggly, Sentry) para capturar exceções.

6. **Performance**
   - Respostas da API devem ser rápidas (idealmente abaixo de 200ms).
   - Uso eficiente de cache para dados estáticos (ex: Redis).

7. **Documentação da API**
   - A API deve ser documentada utilizando Swagger ou outro padrão similar.

## Casos de Uso

### 1. Usuário não autenticado
- **Registrar** uma nova conta com nome, e-mail e senha.
- **Fazer login** utilizando e-mail e senha.
- **Visualizar** lista de produtos e categorias.
- **Filtrar** e buscar produtos.

### 2. Usuário autenticado
- **Gerenciar perfil** (atualizar nome, senha, e-mail).
- **Adicionar** produtos ao carrinho de compras.
- **Visualizar** e **atualizar** o carrinho.
- **Criar um pedido** com os produtos no carrinho.
- **Pagar um pedido** utilizando o gateway de pagamento.
- **Visualizar** histórico de pedidos.
- **Cancelar** um pedido se não tiver sido processado.

### 3. Administrador
- **Adicionar, atualizar e deletar** produtos.
- **Gerenciar categorias** de produtos.
- **Visualizar todos os pedidos**.
- **Atualizar status** de pedidos.
- **Gerenciar usuários** (excluir contas, ver lista de usuários).

## Entidades do Banco de Dados

### 1. Usuário (users)
- `id`: chave primária
- `name`: nome do usuário
- `email`: e-mail do usuário (único)
- `password`: senha criptografada
- `role`: papel do usuário (admin, cliente)
- `created_at`: data de criação
- `updated_at`: data de atualização

### 2. Produto (products)
- `id`: chave primária
- `name`: nome do produto
- `description`: descrição do produto
- `price`: preço
- `stock`: quantidade em estoque
- `category_id`: referência à categoria
- `image_url`: URL da imagem do produto
- `created_at`: data de criação
- `updated_at`: data de atualização

### 3. Categoria (categories)
- `id`: chave primária
- `name`: nome da categoria
- `created_at`: data de criação
- `updated_at`: data de atualização

### 4. Pedido (orders)
- `id`: chave primária
- `user_id`: referência ao usuário que fez o pedido
- `status`: status do pedido (pendente, pago, enviado, cancelado)
- `total`: valor total do pedido
- `created_at`: data de criação
- `updated_at`: data de atualização

### 5. Item do Pedido (order_items)
- `id`: chave primária
- `order_id`: referência ao pedido
- `product_id`: referência ao produto
- `quantity`: quantidade do produto no pedido
- `price`: preço do produto no momento do pedido
- `created_at`: data de criação

### 6. Pagamento (payments)
- `id`: chave primária
- `order_id`: referência ao pedido
- `amount`: valor pago
- `status`: status do pagamento (sucesso, falha)
- `transaction_id`: ID da transação do gateway de pagamento
- `created_at`: data de criação

## Diagrama de Fluxo

**Fluxo de Usuário:**
- Usuário se registra ou faz login.
- Navega pela lista de produtos, podendo filtrar por categorias ou realizar buscas.
- Adiciona produtos ao carrinho.
- Visualiza o carrinho e decide fechar o pedido.
- Realiza o pagamento.
- O pedido é registrado e o usuário pode acompanhar o status.

**Fluxo de Administrador:**
- Admin realiza login.
- Gerencia produtos e categorias (criação, atualização, exclusão).
- Visualiza todos os pedidos e gerencia o status de cada um.

## Requisitos de Implantação
- O sistema será implantado em um servidor com Node.js e PostgreSQL configurados.
- Uso de variáveis de ambiente para configurar a conexão com o banco de dados e credenciais do gateway de pagamento.
- Automatização de deploy com scripts de CI/CD.

## Tecnologias
- **Node.js** com **Express** para o servidor web.
- **PostgreSQL** como banco de dados relacional.
- **JWT** para autenticação de usuários.
- **Jest** para testes unitários e de integração.
- **Bcrypt** para criptografia de senhas.
- **Swagger** ou **Postman** para documentação da API.

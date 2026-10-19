# 🚀 Portfólio de Análise de Dados em SQL 

Bem-vindo(a) ao meu portfólio de projetos em SQL! Este repositório reúne estudos de caso práticos desenvolvidos sobre a base de dados pública do e-commerce **Olist** (~100 mil pedidos).

O objetivo principal é resolver problemas reais de negócios — como retenção de clientes, eficiência logística e desempenho comercial — utilizando técnicas avançadas de **SQL** (CTEs, Window Functions, Funções de Data e Agregações Complexas).

---

##  Índice dos Cases
- [Case 1: Análise Comportamental e Segmentação RFM de Clientes]([Case 1: Análise Comportamental e Segmentação RFM de Clientes](https://github.com/AV9922/sql-portfolio-anavilha/blob/ad5222bc322403c7c5fc640588bc7b1713aaef36/Case%201%3A%20An%C3%A1lise%20Comportamental%20e%20Segmenta%C3%A7%C3%A3o%20RFM%20de%20Clientes))
- [Case 2: Experiência do Cliente e Impacto Logístico](#-case-2-experiência-do-cliente-e-impacto-logístico-em-breve) *(Em desenvolvimento)*
- [Case 3: Desempenho de Vendedores e Curva ABC de Produtos](#-case-3-desempenho-de-vendedores-e-curva-abc-de-produtos-em-breve) *(Em desenvolvimento)*

---

## Case 1: Análise Comportamental e Segmentação RFM de Clientes

### Problema de Negócio
Plataformas de marketplace precisam identificar o valor de sua base de clientes para otimizar campanhas de marketing e reter usuários. Este case mapeia o comportamento de compra dos clientes da Olist aplicando a metodologia **RFM (Recência, Frequência e Valor Monetário)**.

### Conceitos e Técnicas de SQL Utilizadas
- **CTEs Encadeadas (`WITH ... AS`):** Organização modular do código em etapas lógicas.
- **Window Functions (`NTILE(5)`):** Divisão da base em quintis para geração das notas RFM de 1 a 5.
- **Funções de Data (`JULIANDAY`):** Cálculo exato da recência de compra em dias.
- **Múltiplos `JOIN`s:** Unificação das tabelas de pedidos, clientes e itens.
- **Lógica Condicional (`CASE WHEN`):** Agrupamento final dos clientes em segmentos de negócio.

### Principais Insights Encontrados
- **Alta Comportabilidade Transacional:** A esmagadora maioria da base possui apenas 1 pedido realizado, revelando uma oportunidade crítica para estratégias de *cross-sell* e fidelização.
- **Concentração de Receita:** Os segmentos de alto valor (*Champions* e *Leais*) concentram a maior parte do faturamento, demandando ações de atendimento diferenciadas.

 **Código do Case 1:** [`case_1_segmentacao_rfm.sql`](./case_1_segmentacao_rfm.sql)

---

## Case 2: Experiência do Cliente e Impacto Logístico *(Em breve)*

### Problema de Negócio
Analisar como o tempo de frete e os atrasos nas entregas impactam diretamente a satisfação do cliente (notas de avaliação).

**Código do Case 2:** *(Em breve)*

---

## Case 3: Desempenho de Vendedores e Curva ABC de Produtos *(Em breve)*

### Problema de Negócio
Avaliar a concentração de vendas por categoria de produto e a distribuição de receita entre os vendedores cadastrados no marketplace (Análise de Pareto).

**Código do Case 3:** *(Em breve)*

---

## Autora
**Ana Vilha**  
*Análise de Dados & SQL*  
- GitHub: [@AV9922]
- Linkedin: (www.linkedin.com/in/ana-beatriz-couto-pires-vilha)

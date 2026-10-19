# Portfólio de Análise de Dados em SQL 

Bem-vindo(a) ao meu portfólio de projetos em SQL! Este repositório reúne estudos de caso práticos desenvolvidos sobre a base de dados pública do e-commerce **Olist** (~100 mil pedidos).

O objetivo principal é resolver problemas reais de negócios — como retenção de clientes, eficiência logística e desempenho comercial — utilizando técnicas avançadas de **SQL** (CTEs, Window Functions, Funções de Data e Agregações Complexas).

---

##  Índice dos Cases
- [Case 1: Análise Comportamental e Segmentação RFM de Clientes]([Case 1: Análise Comportamental e Segmentação RFM de Clientes](https://github.com/AV9922/sql-portfolio-anavilha/blob/ad5222bc322403c7c5fc640588bc7b1713aaef36/Case%201%3A%20An%C3%A1lise%20Comportamental%20e%20Segmenta%C3%A7%C3%A3o%20RFM%20de%20Clientes))
- [Case 2: Experiência do Cliente e Impacto Logístico](https://github.com/AV9922/sql-portfolio-anavilha/blob/3c0649270defd1dc4c5b37d60615f95dda38b035/case_2_impacto_logistico.sql)
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

 **Código do Case 1:** [`case_1_segmentacao_rfm.sql`](./case_1_segmentacao_rfm.sql)](https://github.com/AV9922/sql-portfolio-anavilha/blob/ad5222bc322403c7c5fc640588bc7b1713aaef36/Case%201%3A%20An%C3%A1lise%20Comportamental%20e%20Segmenta%C3%A7%C3%A3o%20RFM%20de%20Clientes).

---

## Case 2: Experiência do Cliente e Impacto Logístico (CX & Operations)

### Problema de Negócio
No e-commerce, o cumprimento dos prazos de entrega é um dos fatores mais críticos para a retenção e satisfação do consumidor. 

Este case analisa a relação entre o tempo de transporte (*shipping days*), o cumprimento das datas estimadas de entrega e as notas de avaliação (*review score*) deixadas pelos clientes da Olist, identificando gargalos regionais e o impacto direto do atraso na reputação da marca.

---

### 🛠️ Conceitos e Técnicas de SQL Utilizadas
- **CTEs Encadeadas (`WITH ... AS`):** Para pré-calcular diferenças de datas e flags operacionais antes de gerar os KPIs.
- **Funções de Data (`JULIANDAY`):** Cálculo exato em dias entre a data de compra, data de entrega e data estimada.
- **Lógica Condicional (`CASE WHEN`):** Criação da flag de status de entrega (*'No Prazo'* vs. *'Com Atraso'*).
- **Agregações e Filtros de Qualidade (`GROUP BY`, `HAVING`):** Agrupamento regional filtrando estados com volume representativo de pedidos (`> 500 pedidos`).

---

### 🔍 Visões Analíticas Disponíveis no Script SQL
O arquivo [`case_2_impacto_logistico.sql`](./case_2_impacto_logistico.sql) foi estruturado em blocos modulares via CTEs. Ao final do script, é possível alternar a consulta para obter 3 visões estratégicas:

1. **Visão de Impacto Direto (`kpis_gerais_prazo`):** Compara a nota média de avaliação e o tempo médio de entrega entre pedidos entregues **No Prazo** vs. **Com Atraso**.
2. **Visão Operacional Regional (`desempenho_por_estado`):** Mapeia o volume de pedidos, percentual de atraso e nota média por estado (UF), identificando os piores gargalos logísticos.
3. **Visão de Sensibilidade ao Atraso (`tolerancia_atraso`):** Detalha a queda na nota de avaliação conforme o número de dias de atraso aumenta.

---

### 💡 Principais Insights Encontrados
- **Penalização Severa por Atraso:** Pedidos entregues dentro do prazo mantêm uma nota média satisfatória (**~4.2 estrelas**), enquanto entregas com atraso provocam uma queda drástica na avaliação média (**~1.7 estrelas**), aumentando significativamente a proporção de avaliações 1 e 2.
- **Gargalo Logístico Regional:** Estados das regiões Norte e Nordeste apresentam taxas percentuais de atraso superiores à média nacional, concentrando as menores notas médias de satisfação e indicando a necessidade de renegociação com parceiros logísticos locais.

---

📁 **Código do Case 2:** [`case_2_impacto_logistico.sql`](./case_2_impacto_logistico.sql)

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

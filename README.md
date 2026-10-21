# Portfólio de Análise de Dados em SQL (Base Olist)

Análises exploratórias e resolução de problemas de negócios utilizando a base pública do e-commerce Olist (~100 mil pedidos). 

Neste projeto, usei SQL para analisar três aspectos da operação da Olist: recorrência de compra dos clientes, relação entre atrasos e avaliações e concentração do faturamento por categoria e vendedor. Para isso, trabalhei com CTEs, funções de janela, cálculos de datas e agregações.

---

## Tecnologias e Fonte de Dados

**Banco de dados:** SQLite

**Linguagem:** SQL

**Base de dados:** [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

O projeto utiliza a base pública de e-commerce disponibilizada pela Olist no Kaggle, com aproximadamente 100 mil pedidos realizados entre 2016 e 2018. O conjunto de dados contém informações sobre pedidos, clientes, produtos, vendedores, pagamentos, entregas e avaliações.

As consultas foram desenvolvidas em SQLite, utilizando CTEs, funções de janela (*Window Functions*), agregações, cálculos de datas e expressões condicionais para investigar padrões de compra, desempenho logístico e concentração de faturamento.

---

## Como reproduzir

1. Baixe o dataset no Kaggle (Brazilian E-Commerce Public Dataset by Olist).
2. Importe os CSVs no SQLite, usando as tabelas `tb_orders`, `tb_customers`, `tb_order_items`, `tb_order_reviews`, `tb_products` e `tb_sellers`.
3. Execute os scripts da pasta correspondente a cada case.

---

##  Links Rápidos para os Scripts
**Case 1:** [Segmentação RFM de Clientes](./case_1_segmentacao_rfm.sql)

**Case 2:** [Impacto Logístico e Satisfação (CX)](./case_2_impacto_logistico.sql)

**Case 3:** [Curva ABC e Desempenho de Sellers](./case_3_vendedores_curva_abc.sql)

---

## Case 1: Segmentação RFM de Clientes

### Contexto
Para orientar estratégias de marketing e retenção, classifiquei a base de clientes da Olist com a metodologia **RFM** (Recência, Frequência e Valor Monetário).

### O que foi aplicado em SQL
* **CTEs Encadeadas:** Estruturação em etapas para manter o código limpo e legível.
* **Window Functions (`NTILE(5)`):** Separação dos clientes em quintis de recência e valor monetário (notas de 1 a 5). A frequência usa faixas fixas (1, 2 e 3+ pedidos), porque a maioria esmagadora dos clientes tem um único pedido e quintis gerariam empates sem sentido.
* **Cálculos de Data (`JULIANDAY`):** Identificação exata dos dias desde a última compra.
* **Lógica Condicional (`CASE WHEN`):** Agrupamento final nos perfis de negócio (Ex: *Champions*, *Leais*, *Em Risco*).
* **Definição de Valor Monetário:** soma de `price + freight_value` dos pedidos entregues, ou seja, o quanto o cliente efetivamente pagou (diferente do Case 3, que considera só o preço dos produtos).
* **Data de referência da recência:** 17/10/2018, correspondente ao fim do período coberto pela base. Como os dados são históricos, usar a data atual distorceria todos os cálculos.

### Regras de segmentação

| Segmento | Regra |
|---|---|
| Champions | R ≥ 4, F ≥ 3 e M ≥ 4 |
| Leais | R ≥ 3 e F ≥ 3 |
| Novos Promissores | R ≥ 4 e F = 1 |
| Em Risco de Churn | R ≤ 2 e F ≥ 3 |
| Inativos / Perdidos | R ≤ 2 e F = 1 |
| Geral / Em Atenção | demais combinações |

### Resultado: Segmentos RFM

| Segmento | Clientes | % Clientes | Receita (R$) | % Receita |
|---|---:|---:|---:|---:|
| Novos Promissores | 36.139 | 38,7% | 5.948.724,32 | 38,6% |
| Inativos / Perdidos | 36.357 | 38,9% | 5.871.130,96 | 38,1% |
| Geral / Em Atenção | 18.061 | 19,3% | 2.735.731,01 | 17,7% |
| Champions | 985 | 1,1% | 367.539,93 | 2,4% |
| Em Risco de Churn | 987 | 1,1% | 287.825,33 | 1,9% |
| Leais | 829 | 0,9% | 208.822,20 | 1,4% |
> Percentuais arredondados; a soma pode diferir de 100% por arredondamento.


### Destaques da Análise
- **A maioria dos clientes comprou apenas uma vez:** cerca de 97% da base tem um único pedido, o que evidencia o desafio de retenção do marketplace.
- **Receita pulverizada em clientes de compra única:** Novos Promissores e Inativos/Perdidos juntos respondem por ~77% da receita. Champions e Leais somam apenas 3,8%, com ticket médio mais alto (R$ 252 a R$ 373, contra ~R$ 162 dos demais, valores incluindo frete).
- **Oportunidade:** com 97% da base em compra única, aumentar a taxa de segundo pedido entre os ~36 mil Novos Promissores é a principal alavanca de retenção apontada pela análise.

> **Limitação:** como ~97% dos clientes têm um único pedido, a frequência separa pouco os perfis e a segmentação é guiada principalmente por recência e valor. Os segmentos Champions e Leais ficam pequenos por natureza da base, não por falha do método.
---

## Case 2: Impacto Logístico e Satisfação do Cliente (CX)

### Contexto
Esta análise compara a nota de avaliação entre pedidos entregues no prazo e com atraso, além de mapear gargalos operacionais por estado (UF). Os resultados mostram associação entre atraso e nota baixa, sem isolar outras causas de insatisfação.

### O que foi aplicado em SQL
* **Geração de KPIs Operacionais:** Diferenças de datas em dias entre compra, previsão de entrega e entrega real.
* **Filtros de Representatividade (`HAVING`):** Análise regional focada apenas em estados com mais de 500 pedidos, o que exclui vários estados com menor volume, em especial do Norte.
* **Múltiplas Visões na Consulta:** O script permite chavear CTEs para analisar o impacto geral no score, a quebra por UF ou a sensibilidade por dia de atraso.
*  **Nota média por pedido:** como um pedido pode ter mais de uma avaliação, calculei a média por `order_id` antes do JOIN, evitando duplicar pedidos e inflar contagens.
* **Atraso medido em dias corridos:** diferença entre a data real de entrega e a data estimada, comparando apenas a data (sem horário).

### Destaques da Análise
- **Impacto na nota:** pedidos no prazo têm nota média de **4,28**; pedidos atrasados caem para **2,26**. Os atrasos somam ~6,8% das entregas, e o tempo médio de entrega vai de 11 para 34 dias.
- **Sensibilidade ao atraso:** apenas 1 a 3 dias já derrubam a nota para 3,28; de 4 a 7 dias ela cai para 2,09, e a partir de 8 dias estabiliza em torno de 1,7.
- **Gargalo regional:** entre os estados com mais de 500 pedidos, o MA tem o maior índice de atraso (17,4%, nota 3,81), seguido de CE (13,8%) e BA (12,2%). O RJ também se destaca (12,1%) e, pelo volume, soma quase 1,5 mil pedidos atrasados. PR, SP e MG têm os menores índices (~4 a 4,6%) e notas em torno de 4,2.

> **Limitações:**
> - A análise considera apenas pedidos com status `delivered`. Cancelados e não entregues ficam de fora, e podem ser os casos mais graves de insatisfação.
> - Só existe nota para quem avaliou, então há viés de resposta.
> - Não foram controladas outras causas (categoria, vendedor, preço, região). A relação atraso × nota é uma associação, não prova causalidade.
---

## Case 3: Curva ABC de Categorias e Vendedores

### Contexto
Aplicação do Princípio de Pareto para entender a concentração de receita por categoria de produto e identificar a dependência do marketplace em relação aos principais vendedores (*sellers*).

### O que foi aplicado em SQL
* **Window Functions Acumuladas (`SUM() OVER(...)`):** Cálculo de faturamento acumulado e % do total para classificação automática da Curva ABC.
* **Tratamento de Dados (`COALESCE`):** Produtos sem categoria cadastrada são agrupados como `sem_categoria`, para não distorcer a soma.
* **Regras de Negócio (`CASE WHEN`):** Classificação automática em Classe A (até 80% da receita), B (80% a 95%) e C (95% a 100%), aplicada a categorias e a vendedores. A categoria ou vendedor que ultrapassa o corte entra na classe anterior. O faturamento considera apenas pedidos entregues e usa o preço dos produtos, sem frete.

### Destaques da Análise

- **Concentração em categorias:** 18 das 74 categorias (~24%) geram **81,3%** do faturamento. As maiores são Beleza e Saúde (9,3%), Relógios e Presentes (8,8%) e Cama, Mesa e Banho (7,7%). As 40 categorias da Classe C somam apenas **4,8%** da receita.
- **Concentração em vendedores:** 533 vendedores (17,9% dos 2.970) respondem por **80,0%** do faturamento, enquanto 1.702 (57,3%) formam a Classe C, com apenas 5,0%.
- **Dependência do grupo, não de um nome:** o maior vendedor representa 1,7% do total e os 10 maiores somam 13,3%. O risco está na Classe A como conjunto, o que justifica um plano de retenção para esses 533 parceiros.
- **Observação de qualidade de dados:** a categoria `sem_categoria` representa ~1,3% do faturamento, indicando produtos sem cadastro.

### Tabela Resumo - Case 3

| Classe | Vendedores | % dos vendedores | % do faturamento |
|--------|-----------:|-----------------:|-----------------:|
| A      | 533        | 17,9%            | 80,0%            |
| B      | 735        | 24,7%            | 15,0%            |
| C      | 1.702      | 57,3%            | 5,0%             |

---

## Autora
**Ana Vilha**  
*Análise de Dados & SQL*  
* GitHub: [@AV9922](https://github.com/AV9922)  
* LinkedIn: [Ana Beatriz Couto Pires Vilha](https://www.linkedin.com/in/ana-beatriz-couto-pires-vilha)

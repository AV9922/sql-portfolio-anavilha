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
* **Window Functions (`NTILE(5)`):** Separação dos clientes em quintis para a nota de 1 a 5.
* **Cálculos de Data (`JULIANDAY`):** Identificação exata dos dias desde a última compra.
* **Lógica Condicional (`CASE WHEN`):** Agrupamento final nos perfis de negócio (Ex: *Champions*, *Leais*, *Em Risco*).

### Destaques da Análise
- **A maioria dos clientes comprou apenas uma vez:** cerca de 97% da base tem um único pedido, o que evidencia o desafio de retenção do marketplace.
- **Receita pulverizada em clientes de compra única:** Novos Promissores e Inativos/Perdidos juntos respondem por ~77% da receita. Champions e Leais somam apenas 3,8%, com ticket médio mais alto (R$ 252 a R$ 373, contra ~R$ 162 dos demais).
- **Oportunidade:** converter parte dos 36 mil Novos Promissores em segundo pedido teria mais impacto no faturamento do que fidelizar o pequeno grupo que já é recorrente.

---

## Case 2: Impacto Logístico e Satisfação do Cliente (CX)

### Contexto
O prazo de entrega afeta diretamente a nota de avaliação no e-commerce. Esta análise mede a correlação entre atrasos no transporte e queda no *review score*, além de mapear gargalos operacionais por estado (UF).

### O que foi aplicado em SQL
* **Geração de KPIs Operacionais:** Diferenças de datas em dias entre compra, previsão de entrega e entrega real.
* **Filtros de Representatividade (`HAVING`):** Análise regional focada apenas em estados com volume relevante (> 500 pedidos).
* **Múltiplas Visões na Consulta:** O script permite chavear CTEs para analisar o impacto geral no score, a quebra por UF ou a sensibilidade por dia de atraso.

### Destaques da Análise
- **Impacto na nota:** pedidos no prazo têm nota média de **4,28**; pedidos atrasados caem para **2,26**. Os atrasos somam ~6,8% das entregas, e o tempo médio de entrega vai de 11 para 34 dias.
- **Sensibilidade ao atraso:** apenas 1 a 3 dias já derrubam a nota para 3,28; de 4 a 7 dias ela cai para 2,09, e a partir de 8 dias estabiliza em torno de 1,7.
- **Gargalo regional:** entre os estados com mais de 500 pedidos, o MA tem o maior índice de atraso (17,4%, nota 3,81), seguido de CE (13,8%) e BA (12,2%). O RJ também se destaca (12,1%) e, pelo volume, soma quase 1,5 mil pedidos atrasados. PR, SP e MG têm os menores índices (~4 a 4,6%) e notas em torno de 4,2.

---

## Case 3: Curva ABC de Produtos e Sellers

### Contexto
Aplicação do Princípio de Pareto para entender a concentração de receita por categoria de produto e identificar a dependência do marketplace em relação aos principais vendedores (*sellers*).

### O que foi aplicado em SQL
* **Window Functions Acumuladas (`SUM() OVER(...)`):** Cálculo de faturamento acumulado e % do total para classificação automática da Curva ABC.
* **Tratamento de Dados (`COALESCE`):** Imputação de categorias não cadastradas para não enviesar a soma.
* **Regras de Negócio (`CASE WHEN`):** Classificação automática entre Classe A (até 80% da receita), B (80%-95%) e C (95%-100%).

### Destaques da Análise
* **Concentração na Classe A:** Poucas categorias (como *Cama, Mesa e Banho*, *Beleza e Saúde* e *Esporte e Lazer*) concentram cerca de **80% do faturamento total**.
* **Acompanhamento dos principais vendedores:** O mapeamento dos vendedores da Classe A permite que o time comercial crie planos específicos de retenção para evitar a perda desses parceiros.

---

## Autora
**Ana Vilha**  
*Análise de Dados & SQL*  
* GitHub: [@AV9922](https://github.com/AV9922)  
* LinkedIn: [Ana Beatriz Couto Pires Vilha](https://www.linkedin.com/in/ana-beatriz-couto-pires-vilha)

WITH entregas_analise AS(
    SELECT 
        t1.order_id,
        t3.customer_state,
        t2.review_score,
        CAST(julianday(t1.order_delivered_customer_date) - julianday(t1.order_purchase_timestamp) AS INT) AS dias_para_entrega,
        CAST(julianday(t1.order_delivered_customer_date) - julianday(t1.order_estimated_delivery_date) AS INT) AS dias_atraso,
        CASE 
            WHEN julianday(t1.order_delivered_customer_date) > julianday(t1.order_estimated_delivery_date) THEN 'Com Atraso'
            ELSE 'No Prazo'
        END AS status_prazo
    FROM tb_orders AS t1
    JOIN tb_order_reviews AS t2 ON t1.order_id = t2.order_id
    JOIN tb_customers AS t3 ON t1.customer_id = t3.customer_id
    WHERE t1.order_status = 'delivered'
      AND t1.order_delivered_customer_date IS NOT NULL
),

kpis_gerais_prazo AS (
    SELECT 
        status_prazo,
        COUNT(order_id) AS total_pedidos,
        ROUND(AVG(review_score), 2) AS nota_media_avaliacao,
        ROUND(AVG(dias_para_entrega), 1) AS media_dias_entrega
    FROM entregas_analise
    GROUP BY status_prazo
),

desempenho_por_estado AS (
    SELECT 
        customer_state,
        COUNT(order_id) AS total_pedidos,
        ROUND(AVG(review_score), 2) AS nota_media_estado,
        SUM(CASE WHEN status_prazo = 'Com Atraso' THEN 1 ELSE 0 END) AS pedidos_atrasados,
        ROUND(
            (SUM(CASE WHEN status_prazo = 'Com Atraso' THEN 1 ELSE 0 END) * 100.0) / COUNT(order_id), 
            2
        ) AS pct_atraso
    FROM entregas_analise
    GROUP BY customer_state
    HAVING COUNT(order_id) > 500
    ORDER BY pct_atraso DESC
),

tolerancia_atraso AS (
    SELECT 
        CASE 
            WHEN dias_atraso <= 0 THEN '01. No Prazo / Antecipado'
            WHEN dias_atraso BETWEEN 1 AND 3 THEN '02. 1 a 3 dias de atraso'
            WHEN dias_atraso BETWEEN 4 AND 7 THEN '03. 4 a 7 dias de atraso'
            WHEN dias_atraso BETWEEN 8 AND 14 THEN '04. 8 a 14 dias de atraso'
            ELSE '05. Mais de 14 dias de atraso'
        END AS faixas_atraso,
        COUNT(order_id) AS total_pedidos,
        ROUND(AVG(review_score), 2) AS nota_media_avaliacao
    FROM entregas_analise
    GROUP BY 1
    ORDER BY 1 ASC
)

-- Consulta final (altere o SELECT conforme o insight que quiser visualizar):
-- Cada bloco corresponde a uma análise diferente.
-- Execute apenas o bloco referente à análise desejada.

--  VISÃO 1: Impacto Geral do Atraso na Nota Média
SELECT * FROM kpis_gerais_prazo

-- VISÃO 2: Ranking de Atraso e Satisfação por Estado (UF)
-- SELECT * FROM desempenho_por_estado

-- VISÃO 3: Sensibilidade da Nota por Dias de Atraso
-- SELECT * FROM tolerancia_atraso

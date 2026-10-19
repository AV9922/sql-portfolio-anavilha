WITH rf_base as(
    SELECT 
        t2.customer_unique_id,
        MAX(t1.order_purchase_timestamp) as ultima_compra,
        COUNT(DISTINCT t1.order_id) as frequencia,
        SUM(t3.price + t3.freight_value) as valor_monetario
    FROM tb_orders as t1

    JOIN tb_customers AS t2 ON t1.customer_id = t2.customer_id

    JOIN tb_order_items AS t3 ON t1.order_id = t3.order_id

    WHERE t1.order_status = 'delivered'

    GROUP BY t2.customer_unique_id
),

rfm_calculado AS (
    SELECT 
        customer_unique_id,
        frequencia,
        valor_monetario,
        CAST(julianday('2018-10-17 00:00:00') - julianday(ultima_compra) AS INT) AS recencia_dias
    FROM rf_base
),

rfm_scores AS (
    SELECT 
        customer_unique_id,
        recencia_dias,
        frequencia,
        valor_monetario,
        NTILE(5) OVER (ORDER BY recencia_dias DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequencia ASC) AS f_score,
        NTILE(5) OVER (ORDER BY valor_monetario ASC) AS m_score
    FROM rfm_calculado
)

SELECT 
    customer_unique_id,
    recencia_dias,
    frequencia,
    valor_monetario,
    r_score,
    f_score,
    m_score,
    (CAST(r_score AS TEXT) || CAST(f_score AS TEXT) || CAST(m_score AS TEXT)) AS rfm_cell,
    CASE 
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions (Super Clientes)'
        WHEN r_score >= 4 AND f_score <= 2 AND m_score >= 3 THEN 'Novos Promissores'
        WHEN r_score >= 3 AND f_score >= 2 AND m_score >= 3 THEN 'Leais / Alto Valor'
        WHEN r_score <= 2 AND f_score >= 2 THEN 'Em Risco de Churn'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Inativos / Perdidos'
        ELSE 'Geral / Em Atenção'
    END AS segmento_cliente
FROM rfm_scores
ORDER BY valor_monetario DESC;

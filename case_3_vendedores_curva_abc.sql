WITH faturamento_por_categoria AS (
    SELECT 
        COALESCE(t2.product_category_name, 'sem_categoria') AS categoria,
        COUNT(DISTINCT t1.order_id) AS total_pedidos,
        COUNT(t1.product_id) AS total_itens_vendidos,
        SUM(t1.price) AS faturamento
    FROM tb_order_items AS t1
    JOIN tb_products AS t2 ON t1.product_id = t2.product_id
    JOIN tb_orders AS t3 ON t1.order_id = t3.order_id
    WHERE t3.order_status = 'delivered'
    GROUP BY COALESCE(t2.product_category_name, 'sem_categoria')
),

curva_abc_categorias AS (
    SELECT 
        categoria,
        total_pedidos,
        total_itens_vendidos,
        faturamento,
        ROUND(faturamento * 100.0 / SUM(faturamento) OVER (), 2) AS pct_individual,
        ROUND(
            SUM(faturamento) OVER (
                ORDER BY faturamento DESC, categoria
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) * 100.0 / SUM(faturamento) OVER (), 2
        ) AS pct_acumulado
    FROM faturamento_por_categoria
),

classificacao_abc AS (
    SELECT *,
        CASE 
            WHEN pct_acumulado - pct_individual < 80 THEN 'Classe A'
            WHEN pct_acumulado - pct_individual < 95 THEN 'Classe B'
            ELSE 'Classe C'
        END AS classe_abc
    FROM curva_abc_categorias
),

faturamento_vendedores AS (
    SELECT 
        t2.seller_id,
        t2.seller_state,
        COUNT(DISTINCT t1.order_id) AS total_pedidos,
        SUM(t1.price) AS faturamento
    FROM tb_order_items AS t1
    JOIN tb_sellers AS t2 ON t1.seller_id = t2.seller_id
    JOIN tb_orders AS t3 ON t1.order_id = t3.order_id
    WHERE t3.order_status = 'delivered'
    GROUP BY t2.seller_id, t2.seller_state
),

curva_abc_vendedores AS (
    SELECT 
        seller_id,
        seller_state,
        total_pedidos,
        faturamento,
        ROUND(faturamento * 100.0 / SUM(faturamento) OVER (), 2) AS pct_individual,
        ROUND(
            SUM(faturamento) OVER (
                ORDER BY faturamento DESC, seller_id
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) * 100.0 / SUM(faturamento) OVER (), 2
        ) AS pct_acumulado
    FROM faturamento_vendedores
),

classificacao_vendedores AS (
    SELECT *,
        CASE 
            WHEN pct_acumulado - pct_individual < 80 THEN 'Classe A'
            WHEN pct_acumulado - pct_individual < 95 THEN 'Classe B'
            ELSE 'Classe C'
        END AS classe_abc
    FROM curva_abc_vendedores
),

resumo_categorias AS (
    SELECT 
        classe_abc,
        COUNT(*) AS categorias,
        ROUND(100.0 * SUM(faturamento) / SUM(SUM(faturamento)) OVER (), 1) AS pct_faturamento
    FROM classificacao_abc
    GROUP BY classe_abc
),

resumo_vendedores AS (
    SELECT 
        classe_abc,
        COUNT(*) AS vendedores,
        ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_vendedores,
        ROUND(100.0 * SUM(faturamento) / SUM(SUM(faturamento)) OVER (), 1) AS pct_faturamento
    FROM classificacao_vendedores
    GROUP BY classe_abc
)

-- ==============================================================================
-- CONSULTAS FINAIS (Selecione a consulta correspondente à análise que deseja realizar)
-- ==============================================================================

-- VISÃO 1: Curva ABC de Categorias (detalhada)
SELECT * FROM classificacao_abc ORDER BY faturamento DESC;

-- VISÃO 2: Resumo por classe (categorias)
-- SELECT * FROM resumo_categorias ORDER BY classe_abc;

-- VISÃO 3: Curva ABC de Vendedores (detalhada)
-- SELECT * FROM classificacao_vendedores ORDER BY faturamento DESC;

-- VISÃO 4: Resumo por classe (vendedores)
-- SELECT * FROM resumo_vendedores ORDER BY classe_abc;

WITH faturamento_por_categoria AS (
    SELECT 
        COALESCE(t2.product_category_name, 'outros') AS categoria,
        COUNT(DISTINCT t1.order_id) AS total_pedidos,
        COUNT(t1.product_id) AS total_itens_vendidos,
        SUM(t1.price) AS faturamento_produtos,
        SUM(t1.price + t1.freight_value) AS receita_total
    FROM tb_order_items AS t1

    JOIN tb_products AS t2 
    ON t1.product_id = t2.product_id

    JOIN tb_orders AS t3 
    ON t1.order_id = t3.order_id

    WHERE t3.order_status = 'delivered'

    GROUP BY COALESCE(t2.product_category_name, 'outros')
),

curva_abc_categorias AS(
    SELECT 
        categoria,
        total_pedidos,
        total_itens_vendidos,
        receita_total,
        ROUND((receita_total * 100.0) / SUM(receita_total) OVER(), 2) AS pct_receita_individual,
        SUM(receita_total) OVER(ORDER BY receita_total DESC) AS receita_acumulada,
        ROUND(
            (SUM(receita_total) OVER(ORDER BY receita_total DESC) * 100.0) / SUM(receita_total) OVER(), 
            2
        ) AS pct_receita_acumulada
    FROM faturamento_por_categoria
),

classificacao_abc AS(
    SELECT 
        categoria,
        total_pedidos,
        total_itens_vendidos,
        receita_total,
        pct_receita_individual,
        pct_receita_acumulada,
        CASE 
            WHEN pct_receita_acumulada <= 80.0 THEN 'Classe A (High Value)'
            WHEN pct_receita_acumulada <= 95.0 THEN 'Classe B (Medium Value)'
            ELSE 'Classe C (Tail / Low Value)'
        END AS classe_abc
    FROM curva_abc_categorias
),

concentracao_vendedores AS (
    SELECT 
        s.seller_id,
        s.seller_state,
        COUNT(DISTINCT i.order_id) AS total_pedidos,
        SUM(i.price) AS faturamento_vendedor,
        ROUND((SUM(i.price) * 100.0) / SUM(SUM(i.price)) OVER(), 2) AS pct_faturamento_global
    FROM olist_order_items_dataset i
    JOIN olist_sellers_dataset s ON i.seller_id = s.seller_id
    JOIN olist_orders_dataset o ON i.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY s.seller_id, s.seller_state
    ORDER BY faturamento_vendedor DESC
)

-- ==============================================================================
-- CONSULTAS FINAIS (Selecione a consulta correspondente à análise que deseja realizar)
-- ==============================================================================

--  VISÃO 1: Curva ABC de Categorias de Produtos
SELECT * FROM classificacao_abc ORDER BY receita_total DESC

--  VISÃO 2: Ranking e Concentração Financeira dos Top Vendedores
-- SELECT * FROM concentracao_vendedores

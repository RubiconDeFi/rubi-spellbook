{{ config(
        alias ='offers',
        post_hook='{{ expose_spells(\'["ethereum", "bnb", "avalanche_c", "gnosis", "optimism", "arbitrum", "fantom", "polygon"]\',
                                "sector",
                                "dex",
                                \'["denver"]\') }}'
        )
}}

{% set dex_offer_models = [
    ref('rubicon_offers')
] %}

SELECT *
    FROM (
        {% for dex_offer_model in dex_offer_models %}
        SELECT
            blockchain,
            project,
            version,
            block_date,
            block_time,
            block_number,
            tx_index,
            evt_index,
            sell_token_symbol,
            buy_token_symbol,
            token_pair,
            sell_amount,
            buy_amount,
            CAST(sell_amount_raw AS DECIMAL(38,0)) AS sell_amount_raw,
            CAST(buy_amount_raw AS DECIMAL(38,0)) AS buy_amount_raw,
            sold_amount,
            bought_amount,
            CAST(sold_amount_raw AS DECIMAL(38,0)) AS sold_amount_raw,
            CAST(bought_amount_raw AS DECIMAL(38,0)) AS bought_amount_raw,
            sell_amount_usd,
            buy_amount_usd,
            sold_amount_usd,
            bought_amount_usd,
            txn_cost_usd,
            project_contract_address,
            tx_hash,
            tx_from,
            tx_to
        FROM {{ dex_offer_model }}
        {% if not loop.last %}
        UNION ALL
        {% endif %}
        {% endfor %}
)
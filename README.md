# Projeto de Análise Exploratória de Dados (SQL)

Este projeto realiza uma investigação profunda em uma base de dados de demissões globais, buscando identificar padrões, tendências temporais e os maiores impactos por empresa e setor.

## 📂 Estrutura de Arquivos

* **`Project 1 - Data Cleaning.sql`**: O projeto. Contém as consultas SQL avançadas para análise exploratória. **Importante:** Este arquivo já utiliza a base de dados em seu estado limpo e tratado.

## 📊 Conclusão da Análise e Habilidades Aplicadas

O projeto demonstra o uso de técnicas analíticas robustas para extração de insights:

1.  **SQL Avançado:** Implementação de CTEs Aninhadas e *Window Functions* (`DENSE_RANK`, `PARTITION BY`) para criação de rankings complexos.
2.  **Análise Temporal:** Cálculo de *Rolling Total* (Soma Acumulada) e manipulação avançada de séries temporais.
3.  **Agregação de Dados:** Consolidação e agrupamento de demissões por empresa (`company`) e estágio da organização (`stage`).
4.  **Data Wrangling:** Refinamento final de valores nulos e extração de períodos específicos (`Ano-Mês`) via função `SUBSTRING`.

---

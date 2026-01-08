-- Projeto: Análise Exploratória de Dados (EDA) - Layoffs Globais
-- Dataset: layoffs_staging2 (dados limpos e tratados).
-- Objetivo: Identificar padrões de demissões, impacto por setor e tendências temporais.

-- Passo a Passo da Análise:
-- 1. Identificação de Outliers: Maiores demissões e falências (100%).
-- 2. Agregações: Totais acumulados por 'company' e 'stage'.
-- 3. Séries Temporais: Análise por ano e extração de meses.
-- 4. Rolling Total: Cálculo acumulativo mês a mês para análise de tendência.
-- 5. Ranking Anual: Top 5 empresas por ano usando Window Functions (DENSE_RANK).

SELECT *
FROM layoffs_staging2;

-- Identificação de Extremos (OUTLIERS)
-- 1. Identifica o teto de demissões (maior corte único) e se houve casos de fechamento total (1 = 100%).
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- 'companies' que demitiram 100% dos funcionários, ordenadas pelo capital captado (investimento).
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- 2. Agregações por Categoria:
-- Ranking das 'companies' pelo volume total bruto de demissões.
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC; 

-- Ranking por setor (identifica quais 'industries' foram mais afetadas).
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Ranking por 'country' (identifica o impacto geográfico global).
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- 3. Análise Temporal:
-- Identifica o intervalo de tempo presente no dataset (data inicial e final).
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- Evolução anual: 
-- Soma total de demissões agrupada por ano.
SELECT YEAR (`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR (`date`)
ORDER BY 1 DESC; -- Starts at the first column (1)

SELECT *
FROM layoffs_staging2;

-- Impacto por maturidade da 'company' (stage), avalia se empresas em estágio inicial ou grandes corporações (Post-IPO) demitiram mais.
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC; 

-- Média do percentual de demissões por empresa (visão de intensidade do corte).
SELECT company, AVG(percentage_laid_off) 
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

-- Evolução mensal: 
-- Extração de Ano-Mês via SUBSTRING para identificar demissões.
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- 4. Cálculo Acumulado (Rolling Total):
-- Utiliza uma CTE para calcular a soma acumulada mês a mês, permitindo ver a progressão da crise.
WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- 5. Ranking Anual das 'companies':
-- O objetivo é criar um "Top 5" de empresas com mais cortes para cada ano específico.

-- Consulta auxiliar: Total de demissões por 'company' (Geral).
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC; 

-- Consulta auxiliar: Total de demissões por 'company' e por 'year'.
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,  YEAR(`date`)
ORDER BY 3 DESC;

-- Aplicação de Window Function (DENSE_RANK) para gerar o ranking anual. 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,  YEAR(`date`)
), 
Company_Year_Rank AS 
(
-- Segunda CTE: Cria o ranking particionando os dados por ano.
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
FROM Company_Year
WHERE years IS NOT NULL
)
-- Filtro final para exibir apenas o Top 5 de cada ano.
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5 
;

-- Conclusão da Análise Exploratória:

-- 1. SQL Avançado: CTEs Aninhadas e Window Functions (DENSE_RANK, PARTITION BY).
-- 2. Análise Temporal: Rolling Total (Soma Acumulada) e manipulação de datas.
-- 3. Agregação de Dados: Consolidação de demissões por 'company' e 'stage'.
-- 4. Data Wrangling: Limpeza de nulos e extração de 'Ano-Mês' via SUBSTRING.





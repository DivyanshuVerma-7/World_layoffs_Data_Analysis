-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_stagging_2;

SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_stagging_2;

SELECT 
    company,
    total_laid_off,
    `date`,
    percentage_laid_off,
    location
FROM
    layoffs_stagging_2
WHERE
    total_laid_off = (SELECT 
            MAX(total_laid_off)
        FROM
            layoffs_stagging_2
        WHERE
            company = 'twitter')
        AND company = 'twitter';
        
SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_stagging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    company,
    total_laid_off,
    `date`,
    percentage_laid_off,
    location
FROM
    layoffs_stagging_2
WHERE
    percentage_laid_off != 1
ORDER BY percentage_laid_off DESC;


SELECT 
    industry, company, total_laid_off
FROM
    layoffs_stagging_2
ORDER BY 1 asc, 3 desc, 2 asc;

SELECT 
    industry, SUM(total_laid_off) industry_total_laid_off
FROM
    layoffs_stagging_2
GROUP BY industry
ORDER BY 2 DESC;

SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_stagging_2
GROUP BY country
ORDER BY 2 DESC;

SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_stagging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT 
    SUBSTRING(`date`, 1, 7) AS 'Month', SUM(total_laid_off)
FROM
    layoffs_stagging_2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1;


WITH Rolling_Total AS
(
	SELECT 
    SUBSTRING(`date`, 1, 7) AS dates, SUM(total_laid_off) AS total_laid_off
FROM
    layoffs_stagging_2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1
)

SELECT dates, total_laid_off, SUM(total_laid_off) OVER(ORDER BY dates) AS rolling_total_layoffs
FROM Rolling_Total;


SELECT 
    company, YEAR(`date`) AS `year`, SUM(total_laid_off)
FROM
    layoffs_stagging_2
GROUP BY company , `year`
ORDER BY 3 DESC;


WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_stagging_2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;



    
-- Exploratory Data Analysis --

SELECT * FROM layoff_staging2;

SELECT COUNT(*)  
FROM layoff_staging2;

SELECT company ,  
SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY total_laid_off DESC;

SELECT industry ,  
SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY industry
ORDER BY total_laid_off DESC;

SELECT country ,  
SUM(total_laid_off) AS total_laid_off 
FROM layoff_staging2
GROUP BY country
ORDER BY total_laid_off DESC;

SELECT YEAR(`date`) AS years , 
SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY years
ORDER BY total_laid_off DESC;


------------------------------------------------------------------------
WITH  total_laid_off_per_month_cte AS
(
	SELECT DATE_FORMAT(`date` , '%Y-%m')  AS `year_month` ,
	SUM(total_laid_off) AS total_laid_off_per_month
	FROM layoff_staging2
	GROUP BY 1 `year_month`
	ORDER BY `year_month`
)
SELECT  `year_month`,
total_laid_off_per_month ,
SUM(total_laid_off_per_month) OVER(ORDER BY `year_month`) AS Rolling_total_of_total_laid_off
FROM total_laid_off_per_month_cte ;

---------------------------------------------------------------------------------------------------------
 
WITH total_laid_off_per_company(company , years , total_laid_off , percentage_laid_off) AS
(
	SELECT company , 
	YEAR(`date`) , 
	SUM(total_laid_off),
    AVG(percentage_laid_off)
	FROM layoff_staging2
	GROUP BY company , years
) ,
company_year_rank AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off  DESC) AS ranking
FROM total_laid_off_per_company
WHERE total_laid_off IS NOT NULL
)
SELECT * 
FROM company_year_rank
WHERE ranking <= 5;
--  -- ----------------------------------------------------------------------------

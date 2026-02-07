-- Data Cleaning --

SELECT * FROM layoffs;

-- 1.Remove Duplicates -- 
-- 2.Standardize The Data --
-- 3. Finding the Null Values Or Blank Values --
-- 4. Remove Any Columns --

CREATE TABLE layoff_staging 
LIKE layoffs;

INSERT layoff_staging
SELECT * FROM layoffs;

SELECT COUNT(*) FROM layoff_staging;

TRUNCATE TABLE layoff_staging;

-- STEP 1: Removing Duplicates -- 
WITH duplicate_cte AS 
(
	SELECT * ,
    ROW_NUMBER() OVER(
    PARTITION BY company , location , total_laid_off, `date` , 
    percentage_laid_off, source , stage , funds_raised, country, date_added
    ) AS row_num
    FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;



CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoff_staging2;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY  company , location , total_laid_off, `date`, 
    percentage_laid_off, industry, source, stage, funds_raised , country , date_added 
	) AS row_num
FROM layoff_staging;

DELETE
FROM layoff_staging2
WHERE row_num > 1;

-- Step 2: Standardiing Data --

SELECT DISTINCT company , TRIM(company)
FROM layoff_staging2;

UPDATE layoff_staging2
SET company = TRIM(company);

SELECT * FROM layoff_staging2;
-----------------------------------------------------
SELECT DISTINCT location
FROM layoff_staging2;

UPDATE layoff_staging2
SET location = REPLACE(location, ', Non-U.S.', '');

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;


UPDATE layoff_staging2
SET industry = 'Transportation'
WHERE industry LIKE 'Tra%';
---------------------------------------------
SELECT DISTINCT country
FROM layoff_staging2
ORDER BY 1;
-----------------------------------------
SELECT `date`,
STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date` , '%m/%d/%Y');

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;
-------------------------------
SELECT `date_added`,
STR_TO_DATE(`date_added` , '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date_added` = STR_TO_DATE(`date_added` , '%m/%d/%Y');

ALTER TABLE layoff_staging2
MODIFY COLUMN `date_added` DATE;

---------------------------------------------------
ALTER TABLE layoff_staging2
DROP COLUMN row_num ;

-- STEP 3: Working on NULL values and Blank values --

SELECT *
FROM layoff_staging2;

SELECT DISTINCT industry
FROM layoff_staging2
ORDER BY 1;

SELECT *
FROM layoff_staging2
WHERE industry = '';

SELECT * 
FROM layoff_staging2
WHERE company LIKE 'Appsmith%';

UPDATE layoff_staging2
SET industry = 'other'
WHERE industry = '';

-------------------------------------------------

SELECT *
FROM layoff_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

--------------------------------------------------------



SELECT *
FROM layoff_staging2 
WHERE total_laid_off  = ''
OR percentage_laid_off = '';

UPDATE layoff_staging2
SET total_laid_off =
        CASE WHEN total_laid_off = '' THEN NULL ELSE total_laid_off END,
    percentage_laid_off =
        CASE WHEN percentage_laid_off = '' THEN NULL ELSE percentage_laid_off END
WHERE total_laid_off = ''
   OR percentage_laid_off = '';

------------------------------------------------------------------------------------
SELECT * 
FROM layoff_staging2
WHERE funds_raised = '';

UPDATE layoff_staging2
SET funds_raised = NULL
WHERE funds_raised = '';
--------------------------------------------------------------------------------------

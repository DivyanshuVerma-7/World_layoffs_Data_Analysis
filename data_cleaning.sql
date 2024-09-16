CREATE TABLE layoffs_staging LIKE layoffs;

INSERT layoffs_staging 
SELECT * FROM layoffs;

SELECT 
    *
FROM
    layoffs_staging;
    
    
-- Removing duplicates


select *, row_number() over(partition by company, location,	industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *, row_number() over(partition by company, location,	industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging
)

select * from duplicate_cte
where row_num > 1;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    company = 'Casper';


CREATE TABLE `layoffs_staging_2` (
    `company` VARCHAR(512) DEFAULT NULL,
    `location` VARCHAR(512) DEFAULT NULL,
    `industry` VARCHAR(512) DEFAULT NULL,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` VARCHAR(512) DEFAULT NULL,
    `date` VARCHAR(512) DEFAULT NULL,
    `stage` VARCHAR(512) DEFAULT NULL,
    `country` VARCHAR(512) DEFAULT NULL,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging_2;

Insert layoffs_staging_2
select *, row_number() over(partition by company, location,	industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) as row_num
from layoffs_staging;

SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    row_num > 1;

DELETE FROM layoffs_staging_2 
WHERE
    row_num > 1;

SELECT 
    *
FROM
    layoffs_staging_2;

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;

-- Standardlizing the data

UPDATE layoffs_staging_2 
SET 
    company = TRIM(company);

SELECT DISTINCT
    industry
FROM
    layoffs_staging_2
ORDER BY industry ASC;

SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    industry LIKE '%Crypto%';

UPDATE layoffs_staging_2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE '%crypto%';

SELECT DISTINCT
    location
FROM
    layoffs_staging_2
ORDER BY 1;


SELECT DISTINCT
    country
FROM
    layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2 
SET 
    country = TRIM(TRAILING '.' FROM country);

SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    layoffs_staging_2;
    
UPDATE layoffs_staging_2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
    
alter table layoffs_staging_2
modify column `date` date;

SELECT 
    `date`
FROM
    layoffs_staging_2;

SELECT 
    *
FROM
    layoffs_staging_2;

SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;


SELECT DISTINCT
    industry
FROM
    layoffs_staging_2;
    
SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    industry IS NULL OR industry = '';

SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    company = 'Airbnb';


UPDATE layoffs_staging_2 
SET 
    industry = NULL
WHERE
    industry = '';


SELECT 
    tb1.company, tb1.industry, tb2.industry
FROM
    layoffs_staging_2 tb1
        JOIN
    layoffs_staging_2 tb2 ON tb1.company = tb2.company
        AND tb1.location = tb2.location
WHERE
    (tb1.industry IS NULL)
        AND (tb2.industry IS NOT NULL);




UPDATE layoffs_staging_2 tb1
        JOIN
    layoffs_staging_2 tb2 ON tb1.company = tb2.company
        AND tb1.location = tb2.location 
SET 
    tb1.industry = tb2.industry
WHERE
    (tb1.industry IS NULL)
        AND (tb2.industry IS NOT NULL);
        
SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    industry IS NULL;


-- Remove unnecessary rows and columns


SELECT 
    *
FROM
    layoffs_staging_2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging_2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

SELECT 
    *
FROM
    layoffs_staging_2





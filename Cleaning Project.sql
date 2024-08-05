SELECT*
FROM layoffs ;

-- 1-) Remove Duplicates 
-- 2-) Standardize Data
-- 3-) Null Or Blank Values
-- 4-) Remove Any Columns


-- Removing Duplicates 

Create Table layoffs_staging 
like layoffs;

SELECT*
FROM layoffs_staging;

Insert layoffs_staging 
Select * 
From layoffs;

Select * ,
Row_number() Over(
Partition by company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
From layoffs_staging;

With duplicate_cte AS
(
Select * ,
Row_number() Over(
Partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
From layoffs_staging
)
Select *
From duplicate_cte
where row_num > 1;

SELECT*
FROM layoffs_staging
Where company = 'Casper';

With duplicate_cte AS
(
Select * ,
Row_number() Over(
Partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
From layoffs_staging
)
Delete
From duplicate_cte
where row_num > 1;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM layoffs_staging2
Where row_num > 1;

Insert Into layoffs_staging2
Select * ,
Row_number() Over(
Partition by company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
From layoffs_staging;


Delete
FROM layoffs_staging2
Where row_num > 1;

SELECT*
FROM layoffs_staging2;

-- Standardizng data

SELECT company ,TRIM(company)
FROM layoffs_staging2;

Update layoffs_staging2
Set company = TRIM(company);

SELECT distinct industry
FROM layoffs_staging2;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

SELECT distinct country , TRIM(trailing '.' From country)
FROM layoffs_staging2
order by 1;

update layoffs_staging2
set country = TRIM(trailing '.' From country)
where country like 'United States%';

Select `date`
From layoffs_staging2;

Update layoffs_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

-- Null And Blank Values 

Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = Null
where industry ='';

Select *
From layoffs_staging2
where industry is null
or industry='';

Select *
From layoffs_staging2
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
    on t1.company = t2.company
	and t1.location=t2.location
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
     on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

-- Remove Any Coulmns or Rows

Select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;
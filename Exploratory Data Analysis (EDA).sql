

select*
from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select*
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions desc;

select company,SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select min(`date`),Max(`date`)
from layoffs_staging2;

select country,SUM(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`),SUM(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select substring(`date`,1,7) AS `month` ,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select substring(`date`,1,7) AS `month` ,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
Select `month`,total_off
,sum(total_off) over(order by `month`) as rolling_total
from rolling_total;

select company,SUM(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company,year(`date`),SUM(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

with Company_Year (company,years,total_laid_off) as
(
select company,year(`date`),SUM(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
) , Company_Year_Rank As
(select* 
, dense_rank() over(partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null)
Select*
From Company_Year_Rank
where Ranking <=5;

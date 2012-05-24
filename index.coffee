first_year = prompt('Enter first year to crawl:')
last_year = prompt('Enter last year to crawl:')

years = [first_year .. last_year]
year_data = (crawl_year(year) for year in years)
json = JSON.stringify(year_data, null, 4)
document.getElementById('result').textContent = json
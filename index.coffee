year = prompt('Enter year of contest to crawl:')
data = crawl_year(year)
json = JSON.stringify(data, null, 4)
document.getElementById('result').textContent = json
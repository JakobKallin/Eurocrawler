contest_id = prompt('Enter ID of contest to crawl:')
json = JSON.stringify({contest_id: contest_id})
document.getElementById('result').textContent = json
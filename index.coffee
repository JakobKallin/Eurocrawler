contest_id = prompt('Enter ID of contest to crawl:')
contest_filename = 'pages/' + contest_id + '.html'
json = crawl_page(contest_filename)
document.getElementById('result').textContent = json
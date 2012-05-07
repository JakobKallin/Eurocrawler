point_cell_path = 'td:not(:first-child):not(:last-child):not(:nth-last-child(2))'

@crawl_year = (year) ->
	final_file = "pages/#{year}_final.html"
	final = crawl_page(final_file)
	
	semi_1_file = "pages/#{year}_semi_1.html"
	semi_1 = crawl_page(semi_1_file)
	
	semi_2_file = "pages/#{year}_semi_2.html"
	semi_2 = crawl_page(semi_2_file)
	
	semi_finals = []
	semi_finals.push(semi_1) if semi_1?
	semi_finals.push(semi_2) if semi_2?
	
	languages = crawl_languages(year)
	
	{
		year: Number(year),
		final: final,
		semi_finals: semi_finals,
		languages: languages
	}

crawl_page = (filename) ->
	try 
		request = new XMLHttpRequest()
		request.open('GET', filename, false)
		request.send()
	catch error
		return null
	
	# The parsing only works in Firefox.
	parser = new DOMParser()
	contest_document = parser.parseFromString(request.responseText, 'text/html')
	scoreboard = contest_document.querySelector('.cb-EventInfo-scoreboard table')
	
	recipients = crawl_recipients(scoreboard)
	donors = crawl_donors(scoreboard)
	points = crawl_points(scoreboard, recipients, donors)
	
	{
		recipients: recipients,
		donors: donors,
		points: points
	}

crawl_donors = (scoreboard) ->
	path = 'thead th:not(:first-child):not(:last-child):not(:nth-last-child(2)) img'
	images = scoreboard.querySelectorAll(path)
	donors = (normalized_name(image.alt) for image in images)

crawl_recipients = (scoreboard) ->
	rows = scoreboard.querySelectorAll('tbody td:first-child span.country')
	recipients = (normalized_name(row.textContent) for row in rows)

crawl_points = (scoreboard, recipients, donors) ->
	points = {
		from: {}
		to: {}
	}
	
	for row, recipient_index in scoreboard.querySelectorAll('tbody tr')
		recipient = recipients[recipient_index]
		points.to[recipient] = {}
		
		for cell, donor_index in row.querySelectorAll(point_cell_path)
			donor = donors[donor_index]
			point = Number(cell.textContent) # Should return zero for empty string.
			points.to[recipient][donor] = point
			points.from[donor] = {} unless points.from[donor]?
			points.from[donor][recipient] = point
	
	points

crawl_languages = (year) ->
	filename = "pages/#{year}_wiki.html"
	request = new XMLHttpRequest()
	request.open('GET', filename, false)
	request.send()
	
	# The parsing only works in Firefox.
	parser = new DOMParser()
	contest_document = parser.parseFromString(request.responseText, 'text/html')
	tables = contest_document.querySelectorAll('table.sortable')
	
	languages = {}
	crawl_language_table(table, languages) for table in tables
	
	languages

crawl_language_table = (table, found_languages) ->
	country_column = null
	language_column = null
	for header, column in table.querySelectorAll('tr:first-child th')
		country_column = column if header.textContent.indexOf('Country') isnt -1
		language_column = column if header.textContent.indexOf('Language') isnt -1
	
	if not country_column? or not language_column?
		return
	
	rows = table.querySelectorAll('tr:not(:first-child)')
	for row in rows
		country = row.querySelector("td:nth-child(#{country_column + 1})").textContent.trim()
		country = normalized_name(country)
		language_text = row.querySelector("td:nth-child(#{language_column + 1})").textContent
		language_text = handle_language_exceptions(language_text)
		# Remove numbers and everything inside brackets, trim, and split on comma and whitespace.
		languages = language_text.replace(/\d|\[[^\]]*\]/g, '').trim().split(/,\s*/)
		found_languages[country] = languages unless found_languages[country]?

normalized_name = (country) ->
	switch country
		when 'Bosnia and Herzegovina' then 'Bosnia & Herzegovina'
		when 'Macedonia' then 'F.Y.R. Macedonia'
		when 'Netherlands' then 'The Netherlands'
		when 'Serbia & Montenegro' then 'Serbia'
		else country

handle_language_exceptions = (language_text) ->
	# France 2007
	language_text.replace(' ("Franglais")', '')
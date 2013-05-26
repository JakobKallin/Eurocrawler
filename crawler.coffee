country_codes = {
	'Albania': 'al',
	'Andorra': 'ad',
	'Armenia': 'am',
	'Austria': 'at',
	'Azerbaijan': 'az',
	'Belarus': 'by',
	'Belgium': 'be',
	'Bosnia and Herzegovina': 'ba',
	'Bosnia & Herzegovina': 'ba',
	'Bulgaria': 'bg',
	'Croatia': 'hr',
	'Cyprus': 'cy',
	'Czech Republic': 'cz',
	'Denmark': 'dk',
	'Estonia': 'ee',
	'F.Y.R. Macedonia': 'mk',
	'Finland': 'fi',
	'France': 'fr',
	'Georgia': 'ge',
	'Germany': 'de',
	'Greece': 'gr',
	'Hungary': 'hu',
	'Iceland': 'is',
	'Ireland': 'ie',
	'Israel': 'il',
	'Italy': 'it',
	'Latvia': 'lv',
	'Lithuania': 'lt',
	'Macedonia': 'mk',
	'Malta': 'mt',
	'Moldova': 'md',
	'Monaco': 'mc',
	'Montenegro': 'me',
	'Netherlands': 'nl',
	'Norway': 'no',
	'Poland': 'pl',
	'Portugal': 'pt',
	'Romania': 'ro',
	'Serbia': 'rs',
	'Serbia and Montenegro': 'rs',
	'Serbia & Montenegro': 'rs',
	'Russia': 'ru',
	'San Marino': 'sm',
	'Slovakia': 'sk',
	'Slovenia': 'si',
	'Spain': 'es',
	'Sweden': 'se',
	'Switzerland': 'ch',
	'The Netherlands': 'nl',
	'Turkey': 'tr',
	'Ukraine': 'ua',
	'United Kingdom': 'gb'
}

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
	countries = {}
	for country_code of languages
		countries[country_code] = {
			song: {
				languages: languages[country_code]
			}
		}
	
	{
		year: Number(year),
		final: final,
		semi_finals: semi_finals,
		countries: countries
	}

crawl_page = (filename) ->
	request = new XMLHttpRequest()
	request.open('GET', filename, false)
	request.send()
	
	return null if request.status != 200
	
	# The parsing only works in Firefox.
	parser = new DOMParser()
	contest_document = parser.parseFromString(request.responseText, 'text/html')
	scoreboard = contest_document.querySelector('.cb-EventInfo-scoreboard table')
	
	recipients = crawl_recipients(scoreboard)
	donors = crawl_donors(scoreboard)
	points = crawl_points(scoreboard, recipients, donors)
	sums = crawl_sums(points, recipients)
	places = crawl_places(scoreboard, recipients)
	
	# Present data in a more object-oriented manner.
	countries = {}
	for code in donors
		countries[code] = {
			points_to: points.from[code],
			competes: code in recipients
		}
	
	for code, index in recipients
		countries[code].points_from = points.to[code]
		countries[code].place = places[code]
		countries[code].sum = sums[code]
		countries[code].running_order = index + 1
	
	{
		countries: countries
	}

crawl_recipients = (scoreboard) ->
	rows = scoreboard.querySelectorAll('tbody td:first-child span.country')
	recipients = (country_codes[row.textContent] for row in rows)

crawl_donors = (scoreboard) ->
	path = 'thead th:not(:first-child):not(:last-child):not(:nth-last-child(2)) img'
	images = scoreboard.querySelectorAll(path)
	donors = (country_codes[image.alt] for image in images)

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

crawl_sums = (points, recipients) ->
	sums = {}
	for recipient in recipients
		recipient_sum = 0
		recipient_sum += point for donor, point of points.to[recipient]
		sums[recipient] = recipient_sum
	
	return sums

crawl_places = (scoreboard, recipients) ->
	places = {}
	
	for row, recipient_index in scoreboard.querySelectorAll('tbody tr')
		recipient = recipients[recipient_index]
		place = Number(row.querySelector('td.rank').textContent)
		places[recipient] = place
	
	return places

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
		country_name = row.querySelector("td:nth-child(#{country_column + 1})").textContent.trim()
		country_code = country_codes[country_name]
		language_text = row.querySelector("td:nth-child(#{language_column + 1})").textContent
		language_text = handle_language_exceptions(language_text)
		# Remove numbers and everything inside brackets, trim, and split on comma and whitespace.
		languages = language_text.replace(/\d|\[[^\]]*\]/g, '').trim().split(/,\s*/)
		found_languages[country_code] = languages unless found_languages[country_code]?

handle_language_exceptions = (language_text) ->
	# France 2007
	language_text.replace(' ("Franglais")', '')
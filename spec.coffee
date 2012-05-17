test_year = 2011
data = crawl_year(test_year)
points = data.final.points
languages = data.languages
donors = ['al', 'am', 'at', 'az', 'by', 'be', 'ba', 'bg', 'hr', 'cy', 'dk', 'ee', 'mk', 'fi', 'fr', 'ge', 'de', 'gr', 'hu', 'is', 'ie', 'il', 'it', 'lv', 'lt', 'mt', 'md', 'no', 'pl', 'pt', 'ro', 'ru', 'sm', 'rs', 'sk', 'si', 'es', 'se', 'ch', 'nl', 'tr', 'ua', 'gb']
recipients = ['at', 'az', 'ba', 'dk', 'ee', 'fi', 'fr', 'ge', 'de', 'gr', 'hu', 'is', 'ie', 'it', 'lt', 'md', 'ro', 'ru', 'rs', 'si', 'es', 'se', 'ch', 'ua', 'gb']

describe 'Crawler', () ->
	it 'Retrieves the first row', () ->
		test_recipient points.to['fi'], {'dk': 5, 'ee': 7, 'de': 2, 'is': 10, 'ie': 3, 'lt': 1, 'no': 12, 'pl': 5, 'se': 7, 'ch': 5}
	
	it 'Retrieves the last row', () ->
		test_recipient points.to['ge'], {'am': 10, 'az': 10, 'by': 12, 'bg': 1, 'ee': 3, 'gr': 8, 'hu': 5, 'il': 2, 'lt': 12, 'md': 7, 'pl': 7, 'ru': 6, 'sm': 7, 'tr': 8, 'ua': 12}
	
	it 'Retrieves row with points from first country', () ->
		test_recipient points.to['es'], {'al': 5, 'ee': 4, 'mk': 4, 'fr': 12, 'pt': 12, 'ro': 5, 'sk': 2, 'si': 2, 'ch': 3, 'gb': 1}
		
	it 'Retrieves row with points from last country', () ->
		test_recipient points.to['dk'], {'by': 1, 'bg': 7, 'cy': 3, 'ee': 10, 'fr': 7, 'de': 6, 'is': 12, 'ie': 12, 'il': 10, 'lv': 6, 'mt': 5, 'no': 7, 'pl': 3, 'sm': 4, 'sk': 6, 'si': 8, 'se': 10, 'nl': 12, 'gb': 5}
	
	it 'Computes country sum', () ->
		sum = 0
		sum += point for country, point of points.to['fi']
		expect(sum).toEqual(57)
	
	it 'Computes total sum', () ->
		sum = 0
		for recipient in recipients
			sum += point for donor, point of points.to[recipient]
		expect(sum).toEqual((1+2+3+4+5+6+7+8+10+12) * donors.length)
	
	it 'Retrieves the first column', () ->
		test_donor points.from['al'], {'ba': 7, 'gr': 10, 'ru': 4, 'fr': 2, 'it': 12, 'gb': 6, 'az': 8, 'es': 5, 'ua': 3, 'rs': 1}
	
	it 'Retrieves the last column', () ->
		test_donor points.from['gb'], {'dk': 5, 'lt': 6, 'ie': 12, 'se': 3, 'it': 7, 'ch': 10, 'md': 8, 'at': 2, 'is': 4, 'es': 1}
		
	it 'Retrieves column with points to first country', () ->
		test_donor points.from['dk'], {'fi': 5, 'ie': 12, 'se': 10, 'ee': 2, 'gb': 3, 'de': 8, 'ro': 4, 'at': 1, 'si': 7, 'is': 6}
		
	it 'Retrieves column with points to last country', () ->
		test_donor points.from['am'], {'se': 4, 'gr': 7, 'ru': 8, 'fr': 5, 'it': 6, 'gb': 2, 'at': 3, 'ua': 12, 'rs': 1, 'ge': 10}
	
	it 'Retrieves single language', () ->
		expect(languages['pl']).toEqual(['Polish'])
	
	it 'Retrieves multiple languages', () ->
		expect(languages['no']).toEqual(['English', 'Swahili'])
	
	it 'Retrieves languages with footnotes', () ->
		expect(languages['lt']).toEqual(['English'])
	
	it 'Retrieves languages with country names different from Eurovision.tv', () ->
		expect(languages['ba']).toEqual(['English'])
		expect(languages['mk']).toEqual(['Macedonian', 'English'])
	
	it 'Retrieves languages for all countries', () ->
		expect(languages[country]).toBeDefined() for country in donors
	
	it 'Retrieves semi-finals', () ->
		expect(data.semi_finals.length).toEqual(2)

test_recipient = (actual_points, expected_points) ->
	test_country actual_points, expected_points, donors
test_donor = (actual_points, expected_points) ->
	test_country actual_points, expected_points, recipients

test_country = (actual_points, expected_points, countries) ->
	for country in countries
		expected_point = if expected_points[country]? then expected_points[country] else 0
		actual_point = actual_points[country]
		expect(actual_point).toEqual(expected_point)
test_year = 2011
data = crawl_year(test_year)
final_countries = data.final.countries
countries = data.countries
donors = ['al', 'am', 'at', 'az', 'by', 'be', 'ba', 'bg', 'hr', 'cy', 'dk', 'ee', 'mk', 'fi', 'fr', 'ge', 'de', 'gr', 'hu', 'is', 'ie', 'il', 'it', 'lv', 'lt', 'mt', 'md', 'no', 'pl', 'pt', 'ro', 'ru', 'sm', 'rs', 'sk', 'si', 'es', 'se', 'ch', 'nl', 'tr', 'ua', 'gb']
recipients = ['at', 'az', 'ba', 'dk', 'ee', 'fi', 'fr', 'ge', 'de', 'gr', 'hu', 'is', 'ie', 'it', 'lt', 'md', 'ro', 'ru', 'rs', 'si', 'es', 'se', 'ch', 'ua', 'gb']

describe 'Crawler', () ->
	it 'Retrieves the first row', () ->
		test_recipient final_countries.fi.points_from, {'dk': 5, 'ee': 7, 'de': 2, 'is': 10, 'ie': 3, 'lt': 1, 'no': 12, 'pl': 5, 'se': 7, 'ch': 5}
	
	it 'Retrieves the last row', () ->
		test_recipient final_countries.ge.points_from, {'am': 10, 'az': 10, 'by': 12, 'bg': 1, 'ee': 3, 'gr': 8, 'hu': 5, 'il': 2, 'lt': 12, 'md': 7, 'pl': 7, 'ru': 6, 'sm': 7, 'tr': 8, 'ua': 12}
	
	it 'Retrieves row with points from first country', () ->
		test_recipient final_countries.es.points_from, {'al': 5, 'ee': 4, 'mk': 4, 'fr': 12, 'pt': 12, 'ro': 5, 'sk': 2, 'si': 2, 'ch': 3, 'gb': 1}
		
	it 'Retrieves row with points from last country', () ->
		test_recipient final_countries.dk.points_from, {'by': 1, 'bg': 7, 'cy': 3, 'ee': 10, 'fr': 7, 'de': 6, 'is': 12, 'ie': 12, 'il': 10, 'lv': 6, 'mt': 5, 'no': 7, 'pl': 3, 'sm': 4, 'sk': 6, 'si': 8, 'se': 10, 'nl': 12, 'gb': 5}
	
	it 'Computes country sum', () ->
		expect(final_countries.fi.sum).toEqual(57)
	
	it 'Computes total sum', () ->
		sum = 0
		sum += country.sum for code, country of final_countries when country.competes
		expect(sum).toEqual((1+2+3+4+5+6+7+8+10+12) * donors.length)
	
	it 'Retrieves the first column', () ->
		test_donor final_countries.al.points_to, {'ba': 7, 'gr': 10, 'ru': 4, 'fr': 2, 'it': 12, 'gb': 6, 'az': 8, 'es': 5, 'ua': 3, 'rs': 1}
	
	it 'Retrieves the last column', () ->
		test_donor final_countries.gb.points_to, {'dk': 5, 'lt': 6, 'ie': 12, 'se': 3, 'it': 7, 'ch': 10, 'md': 8, 'at': 2, 'is': 4, 'es': 1}
		
	it 'Retrieves column with points to first country', () ->
		test_donor final_countries.dk.points_to, {'fi': 5, 'ie': 12, 'se': 10, 'ee': 2, 'gb': 3, 'de': 8, 'ro': 4, 'at': 1, 'si': 7, 'is': 6}
		
	it 'Retrieves column with points to last country', () ->
		test_donor final_countries.am.points_to, {'se': 4, 'gr': 7, 'ru': 8, 'fr': 5, 'it': 6, 'gb': 2, 'at': 3, 'ua': 12, 'rs': 1, 'ge': 10}
	
	it 'Retrieves single language', () ->
		expect(countries.pl.song.languages).toEqual(['Polish'])
	
	it 'Retrieves multiple languages', () ->
		expect(countries.no.song.languages).toEqual(['English', 'Swahili'])
	
	it 'Retrieves languages with footnotes', () ->
		expect(countries.lt.song.languages).toEqual(['English'])
	
	it 'Retrieves languages with country names different from Eurovision.tv', () ->
		expect(countries.ba.song.languages).toEqual(['English'])
		expect(countries.mk.song.languages).toEqual(['Macedonian', 'English'])
	
	it 'Retrieves languages for all countries', () ->
		expect(country.song.languages).toBeDefined() for code, country of countries
	
	it 'Retrieves semi-finals', () ->
		expect(data.semi_finals.length).toEqual(2)
	
	it 'Retrieves correct places', () ->
		expect(final_countries.az.place).toEqual(1)
		expect(final_countries.it.place).toEqual(2)
		expect(final_countries.se.place).toEqual(3)
		expect(final_countries.ua.place).toEqual(4)
		expect(final_countries.dk.place).toEqual(5)
		expect(final_countries.ba.place).toEqual(6)
		expect(final_countries.gr.place).toEqual(7)
		expect(final_countries.ie.place).toEqual(8)
		expect(final_countries.ge.place).toEqual(9)
		expect(final_countries.de.place).toEqual(10)
		expect(final_countries.gb.place).toEqual(11)
		expect(final_countries.md.place).toEqual(12)
		expect(final_countries.si.place).toEqual(13)
		expect(final_countries.rs.place).toEqual(14)
		expect(final_countries.fr.place).toEqual(15)
		expect(final_countries.ru.place).toEqual(16)
		expect(final_countries.ro.place).toEqual(17)
		expect(final_countries.at.place).toEqual(18)
		expect(final_countries.lt.place).toEqual(19)
		expect(final_countries.is.place).toEqual(20)
		expect(final_countries.fi.place).toEqual(21)
		expect(final_countries.hu.place).toEqual(22)
		expect(final_countries.es.place).toEqual(23)
		expect(final_countries.ee.place).toEqual(24)
		expect(final_countries.ch.place).toEqual(25)
	
	it 'Retrieves correct competitor statuses', () ->
		for country in donors
			if country in recipients
				expect(final_countries[country].competes).toEqual(true)
			else
				expect(final_countries[country].competes).toEqual(false)
	
	it 'Retrieves correct running orders', () ->
		expect(final_countries.fi.running_order).toEqual(1)
		expect(final_countries.ba.running_order).toEqual(2)
		expect(final_countries.dk.running_order).toEqual(3)
		expect(final_countries.lt.running_order).toEqual(4)
		expect(final_countries.hu.running_order).toEqual(5)
		expect(final_countries.ie.running_order).toEqual(6)
		expect(final_countries.se.running_order).toEqual(7)
		expect(final_countries.ee.running_order).toEqual(8)
		expect(final_countries.gr.running_order).toEqual(9)
		expect(final_countries.ru.running_order).toEqual(10)
		expect(final_countries.fr.running_order).toEqual(11)
		expect(final_countries.it.running_order).toEqual(12)
		expect(final_countries.ch.running_order).toEqual(13)
		expect(final_countries.gb.running_order).toEqual(14)
		expect(final_countries.md.running_order).toEqual(15)
		expect(final_countries.de.running_order).toEqual(16)
		expect(final_countries.ro.running_order).toEqual(17)
		expect(final_countries.at.running_order).toEqual(18)
		expect(final_countries.az.running_order).toEqual(19)
		expect(final_countries.si.running_order).toEqual(20)
		expect(final_countries.is.running_order).toEqual(21)
		expect(final_countries.es.running_order).toEqual(22)
		expect(final_countries.ua.running_order).toEqual(23)
		expect(final_countries.rs.running_order).toEqual(24)
		expect(final_countries.ge.running_order).toEqual(25)

test_recipient = (actual_points, expected_points) ->
	test_country actual_points, expected_points, donors
test_donor = (actual_points, expected_points) ->
	test_country actual_points, expected_points, recipients

test_country = (actual_points, expected_points, countries) ->
	for country in countries
		expected_point = if expected_points[country]? then expected_points[country] else 0
		actual_point = actual_points[country]
		expect(actual_point).toEqual(expected_point)
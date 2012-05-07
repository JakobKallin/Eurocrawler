test_year = 2011
data = crawl_year(test_year)
points = data.points
languages = data.languages
donors = ['Albania', 'Armenia', 'Austria', 'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia & Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus', 'Denmark', 'Estonia', 'F.Y.R. Macedonia', 'Finland', 'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Israel', 'Italy', 'Latvia', 'Lithuania', 'Malta', 'Moldova', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia', 'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'The Netherlands', 'Turkey', 'Ukraine', 'United Kingdom']
recipients = ['Austria', 'Azerbaijan', 'Bosnia & Herzegovina', 'Denmark', 'Estonia', 'Finland', 'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Lithuania', 'Moldova', 'Romania', 'Russia', 'Serbia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'Ukraine', 'United Kingdom']

describe 'Crawler', () ->
	it 'Retrieves the first row', () ->
		test_recipient points.to['Finland'], {'Denmark': 5, 'Estonia': 7, 'Germany': 2, 'Iceland': 10, 'Ireland': 3, 'Lithuania': 1, 'Norway': 12, 'Poland': 5, 'Sweden': 7, 'Switzerland': 5}
	
	it 'Retrieves the last row', () ->
		test_recipient points.to['Georgia'], {'Armenia': 10, 'Azerbaijan': 10, 'Belarus': 12, 'Bulgaria': 1, 'Estonia': 3, 'Greece': 8, 'Hungary': 5, 'Israel': 2, 'Lithuania': 12, 'Moldova': 7, 'Poland': 7, 'Russia': 6, 'San Marino': 7, 'Turkey': 8, 'Ukraine': 12}
	
	it 'Retrieves row with points from first country', () ->
		test_recipient points.to['Spain'], {'Albania': 5, 'Estonia': 4, 'F.Y.R. Macedonia': 4, 'France': 12, 'Portugal': 12, 'Romania': 5, 'Slovakia': 2, 'Slovenia': 2, 'Switzerland': 3, 'United Kingdom': 1}
		
	it 'Retrieves row with points from last country', () ->
		test_recipient points.to['Denmark'], {'Belarus': 1, 'Bulgaria': 7, 'Cyprus': 3, 'Estonia': 10, 'France': 7, 'Germany': 6, 'Iceland': 12, 'Ireland': 12, 'Israel': 10, 'Latvia': 6, 'Malta': 5, 'Norway': 7, 'Poland': 3, 'San Marino': 4, 'Slovakia': 6, 'Slovenia': 8, 'Sweden': 10, 'The Netherlands': 12, 'United Kingdom': 5}
	
	it 'Computes country sum', () ->
		sum = 0
		sum += point for country, point of points.to['Finland']
		expect(sum).toEqual(57)
	
	it 'Computes total sum', () ->
		sum = 0
		for recipient in recipients
			sum += point for donor, point of points.to[recipient]
		expect(sum).toEqual((1+2+3+4+5+6+7+8+10+12) * donors.length)
	
	it 'Retrieves the first column', () ->
		test_donor points.from['Albania'], {'Bosnia & Herzegovina': 7, 'Greece': 10, 'Russia': 4, 'France': 2, 'Italy': 12, 'United Kingdom': 6, 'Azerbaijan': 8, 'Spain': 5, 'Ukraine': 3, 'Serbia': 1}
	
	it 'Retrieves the last column', () ->
		test_donor points.from['United Kingdom'], {'Denmark': 5, 'Lithuania': 6, 'Ireland': 12, 'Sweden': 3, 'Italy': 7, 'Switzerland': 10, 'Moldova': 8, 'Austria': 2, 'Iceland': 4, 'Spain': 1}
		
	it 'Retrieves column with points to first country', () ->
		test_donor points.from['Denmark'], {'Finland': 5, 'Ireland': 12, 'Sweden': 10, 'Estonia': 2, 'United Kingdom': 3, 'Germany': 8, 'Romania': 4, 'Austria': 1, 'Slovenia': 7, 'Iceland': 6}
		
	it 'Retrieves column with points to last country', () ->
		test_donor points.from['Armenia'], {'Sweden': 4, 'Greece': 7, 'Russia': 8, 'France': 5, 'Italy': 6, 'United Kingdom': 2, 'Austria': 3, 'Ukraine': 12, 'Serbia': 1, 'Georgia': 10}
	
	it 'Retrieves single language', () ->
		expect(languages['Poland']).toEqual(['Polish'])
	
	it 'Retrieves multiple languages', () ->
		expect(languages['Norway']).toEqual(['English', 'Swahili'])
	
	it 'Retrieves languages with footnotes', () ->
		expect(languages['Lithuania']).toEqual(['English'])
	
	it 'Retrieves languages with country names different from Eurovision.tv', () ->
		expect(languages['Bosnia & Herzegovina']).toEqual(['English'])
		expect(languages['F.Y.R. Macedonia']).toEqual(['Macedonian', 'English'])

test_recipient = (actual_points, expected_points) ->
	test_country actual_points, expected_points, donors
test_donor = (actual_points, expected_points) ->
	test_country actual_points, expected_points, recipients

test_country = (actual_points, expected_points, countries) ->
	for country in countries
		expected_point = if expected_points[country]? then expected_points[country] else 0
		actual_point = actual_points[country]
		expect(actual_point).toEqual(expected_point)
test_year = 2011
data = crawl_year(test_year)
points = data.points
countries = ['Albania', 'Armenia', 'Austria', 'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia & Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus', 'Denmark', 'Estonia', 'F.Y.R. Macedonia', 'Finland', 'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Israel', 'Italy', 'Latvia', 'Lithuania', 'Malta', 'Moldova', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia', 'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland', 'The Netherlands', 'Turkey', 'Ukraine', 'United Kingdom']

describe 'Crawler', () ->
	it 'Retrieves the first row', () ->
		test_country points['Finland'], {'Denmark': 5, 'Estonia': 7, 'Germany': 2, 'Iceland': 10, 'Ireland': 3, 'Lithuania': 1, 'Norway': 12, 'Poland': 5, 'Sweden': 7, 'Switzerland': 5}
	
	it 'Retrieves the last row', () ->
		test_country points['Georgia'], {'Armenia': 10, 'Azerbaijan': 10, 'Belarus': 12, 'Bulgaria': 1, 'Estonia': 3, 'Greece': 8, 'Hungary': 5, 'Israel': 2, 'Lithuania': 12, 'Moldova': 7, 'Poland': 7, 'Russia': 6, 'San Marino': 7, 'Turkey': 8, 'Ukraine': 12}
	
	it 'Retrieves row with points from first country', () ->
		test_country points['Spain'], {'Albania': 5, 'Estonia': 4, 'F.Y.R. Macedonia': 4, 'France': 12, 'Portugal': 12, 'Romania': 5, 'Slovakia': 2, 'Slovenia': 2, 'Switzerland': 3, 'United Kingdom': 1}
		
	it 'Retrieves row with points from last country', () ->
		test_country points['Denmark'], {'Belarus': 1, 'Bulgaria': 7, 'Cyprus': 3, 'Estonia': 10, 'France': 7, 'Germany': 6, 'Iceland': 12, 'Ireland': 12, 'Israel': 10, 'Latvia': 6, 'Malta': 5, 'Norway': 7, 'Poland': 3, 'San Marino': 4, 'Slovakia': 6, 'Slovenia': 8, 'Sweden': 10, 'The Netherlands': 12, 'United Kingdom': 5}
	
	it 'Computes country sum', () ->
		sum = 0
		sum += point for country, point of points['Finland']
		expect(sum).toEqual(57)
	
	it 'Computes total sum', () ->
		sum = 0
		for recipient in countries
			sum += point for donor, point of points[recipient]
		expect(sum).toEqual((1+2+3+4+5+6+7+8+10+12) * countries.length)

test_country = (actual_points, expected_points) ->
	for country in countries
		expected_point = if expected_points[country]? then expected_points[country] else 0
		actual_point = actual_points[country]
		expect(actual_point).toEqual(expected_point)
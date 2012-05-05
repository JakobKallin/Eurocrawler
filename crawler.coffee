paths = {
	scoreboard: '.cb-EventInfo-scoreboard table',
	donors: 'thead th:not(:first-child):not(:last-child):not(:nth-last-child(2))',
	donor_name: 'img',
	recipients: 'tbody tr',
	recipient_name: 'span.country',
	points: 'td:not(:first-child):not(:last-child):not(:nth-last-child(2))'
}

@crawl_page = (filename) ->
	request = new XMLHttpRequest()
	request.open('GET', filename, false)
	request.send()

	# The parsing only works in Firefox.
	parser = new DOMParser()
	contest_document = parser.parseFromString(request.responseText, 'text/html')
	scoreboard = contest_document.querySelector(paths.scoreboard)

	points = {}
	donors = (row.querySelector(paths.donor_name).alt for row in scoreboard.querySelectorAll(paths.donors))
	recipient_rows = scoreboard.querySelectorAll(paths.recipients)
	for recipient_row in recipient_rows
		recipient_name = recipient_row.querySelector(paths.recipient_name).textContent
		points[recipient_name] = {}
		point_cells = recipient_row.querySelectorAll(paths.points)
		for point_cell, donor_index in point_cells
			donor_name = donors[donor_index]
			points[recipient_name][donor_name] = Number(point_cell.textContent) # Should return zero for empty string.

	json = JSON.stringify(points, null, 4)
	json
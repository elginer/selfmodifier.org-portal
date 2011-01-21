/*
 * Author: John Morrice
 * Copyright John Morrice 2010
 *
 * Released under the GNU General Public License Version 3
 *
 */

// Take a URL, convert it into a pair of username and password
function repository(url)
{
	// A successful match will return the whole url, and then two groups
	user_project = url.match(/^.*?([^\/]+)\/([^\/]+)$/);
	if (user_project)
	{
		// Get rid of the whole
		user_project.shift();
		return user_project;
	}
}

// Use the contents of the URL field to update the user and repository
// fields.
function url_altered()
{
	var url = $("#url").val(),
	    user_project = repository(url),
	    user = $("#user"),
	    project = $("#project");

	if (user_project)
	{
		user.val(user_project[0]);
		project.val(user_project[1]);
	}
}

// Create a form to hold a URL.
// The URL can be used to fill in the user and repository form. 
function create_url_form()
{
	var url = "<tr><td>URL (e.g. http://github.com/user/repository)</td> <td><input class='wide' type='text' id='url'></td></tr>";

	$("#instruction_box").append("When you enter a URL, the user and repository will be automatically discovered.  However, if there is a problem, you may enter them manually.");
	$("#first_static_row").before(url);


	setInterval(url_altered, 100);
}

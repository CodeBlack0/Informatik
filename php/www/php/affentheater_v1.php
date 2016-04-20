<?php
	require_once( dirname(__FILE__) . '/db.php');
	DB::$connFile = '/home/timf/www/php/dbsettings.php';
	
	
	
	$action = $_REQUEST['action'];
	switch($action) {
		case "dispUserInputForm":
			prtheader("Display User Input Form");
			dispUserForm();
			break;
		case "saveUserInputForm":
			saveUserForm();
			//redirect('dispUserChangeForm');
			break;
		default:
			redirect('dispUserInputForm');
			break;
	};
	
	function redirect($new_action) {
		echo "<html><head><meta http-equiv='refresh' content='0; url=http://timf.informatik-sgh.de/php/affentheater_v1.php?action=$new_action'/></head></html>";
	}
	function prtheader($title) {
		echo 	"<!DOCTYPE html>
<html lang='en'>
    <head>
        <title>DatBook</title>
        <meta charset='UTF-8'>
        <link rel='stylesheet' type='text/css' href='../datbook/style.css'>
        <!--[if lt IE 9]>
            <script>
                document.createElement('article');
                document.createElement('aside');
                document.createElement('footer');
                document.createElement('header');
                document.createElement('main');
                document.createElement('nav');
                document.createElement('section');
            </script>
            <![endif]-->
    </head>
    <body>
        <div class='floater_top'>
            <header class='banner'>
                <h1>DatBook</h1>
            </header>
            <nav>
                <ul>
                    <li><a href='http://timf.informatik-sgh.de' class='back'>[back]</a></li>
				</ul>
			</nav>
			<main>
				";
	}
	function dispUserForm() {
		echo "
			<section>
				<p>User Input Form</p>
				<article>
					<form action='affentheater_v1.php' method='get'><p>
						<input type='hidden' name='action' value='saveUserInputForm'>
<pre>Name: 		<input type='text' name='name'>
Birthday: 	<input type='date' name='bday'>
Haircolor: 	<select name='hcolor' size='1'>
				<option>blond</option>
				<option>dark blond</option>
				<option>red</option>
				<option>auburn</option>
				<option>brown</option>
				<option>dark brown</option>
				<option>black</option>
				<option>rainbow</option>
			</select>
Eyecolor:		<select name='ecolor' size='1'>
				<option>blue</option>
				<option>teal</option>
				<option>green</option>
				<option>gray</option>
				<option>brown</option>
				<option>black</option>
			</select>
Body:		<select name='body' size='1'>
				<option>athletic</option>
				<option>skinny</option>
				<option>slim</option>
				<option>average</option>
				<option>muscular</option>
				<option>belly</option>
				<option>stocky</option>
			</select>
City:		<input type='text' name='city'>
Hobbies:		<input type='text' name='hobbies'>
<input type='submit'></pre>
					</p></form>
				</action>
			</section>
		<main>
</html>";
	}
	function saveUserForm() {
		try {
			$db = DB::singleton();

			$name = (isset($_REQUEST['name']) && !empty($_REQUEST['name'])) ? $_REQUEST['name'] : 'unknown';
			$sex = (isset($_REQUEST['sex']) && !empty($_REQUEST['sex'])) ? $_REQUEST['sex'] : "mf";
			$bday = (isset($_REQUEST['bday']) && !empty($_REQUEST['bday'])) ? $_REQUEST['bday'] : "0001-01-01";
			$hcolor = (isset($_REQUEST['hcolor']) && !empty($_REQUEST['hcolor'])) ? $_REQUEST['hcolor'] : "blond";
			$ecolor = (isset($_REQUEST['ecolor']) && !empty($_REQUEST['ecolor'])) ? $_REQUEST['ecolor'] : "blue";
			$body = (isset($_REQUEST['body']) && !empty($_REQUEST['body'])) ? $_REQUEST['body'] : "athletic";
			$city = (isset($_REQUEST['city']) && !empty($_REQUEST['city'])) ? $_REQUEST['city'] : "unknown";
			$hobbies = (isset($_REQUEST['hobbies']) && !empty($_REQUEST['hobbies'])) ? $_REQUEST['hobbies'] : "unknown";
			
			$query = "INSERT INTO dbuser (name,sex,bday,hcolor,ecolor,body,city,hobbies)" .
					 "VALUES ('$name','$sex','$bday','$hcolor','$ecolor','$body','$city','$hobbies')";
			echo "$query";
			$db->doQuery($query);
		} catch(Exception $e) {
			echo 'error \n';
		}
	}
?>
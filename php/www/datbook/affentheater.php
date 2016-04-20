<?php
	require_once( dirname(__FILE__) . '/db.php');
	DB::$connFile = '/home/timf/www/php/dbsettings.php';

	main($_REQUEST['action']);


//----[ MAIN FUNCTION ]------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	//main function take care of asigning each action something to do
	function main($action) {
		switch($action){
			default: 
				delete_id_cookie(); //deletes cookie
				redirect('login');	//redirects user to login page
				break;
			case 'login':
				dispLoginForm(); 	//displays login input form
				break;
			case 'login_eval':
				eval_login();		//evaluates login credentials of their validity
				break;
			case 'logout':
				logout();			//takes nessecary measures to logout
				break;
			case 'dispUserInputForm':
				dispUserInputForm();
				break;
			case 'saveUserInputForm':
				saveUserInputForm();
				break;
			case 'dispUserChangeForm':
				dispUserChangeForm();
				break;
			case 'saveUserChangeForm':
				saveUserChangeForm();
				break;
			case 'dispPartnerInputForm':
				dispPartnerInputForm();
				break;
			case 'savePartnerInputForm':
				savePartnerInputForm();
				break;
			case 'dispPartnerChangeForm':
				dispPartnerChangeForm();
				break;
			case 'savePartnerChangeForm':
				savePartnerChangeForm();
				break;
			case 'dispCredInputForm':
				dispCredInputForm();
				break;
			case 'saveCredInputForm':
				saveCredInputForm();
				break;
			case 'dispCredChangeForm':
				dispCredChangeForm();
				break;
			case 'saveCredChangeForm':
				saveCredChangeForm();
				break;
		}
	}

//----[ WORKER FUNCTIONS ]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function login(){

	}

	function eval_login(){

	}

	function logout(){

	}

	function dispUserInputForm(){

	}

	function saveUserInputForm(){

	}

	function dispUserChangeForm(){

	}

	function saveUserChangeForm(){

	}

	function dispPartnerInputForm(){

	}

	function savePartnerInputForm(){

	}

	function dispPartnerChangeForm(){

	}

	function savePartnerChangeForm(){

	}

	function dispCredInputForm(){

	}

	function saveCredInputForm(){

	}

	function dispCredChangeForm(){

	}

	function saveCredChangeForm(){

	}

//----[ TOOL FUNCTIONS ]----------------------------------------------------------------------------------------------------------------------------------------
	function redirect($new_action){
		header("Location: http://timf.informatik-sgh.de/datbook/affentheater.php?action=$new_action");
	}
	function dispHeader($title){
		echo "<!DOCTYPE html>
		<html lang='en'>
	    	<head>
	        	<title>$title</title>
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
					<main>";
	}
?>

<?php
	require_once( dirname(__FILE__) . '/db.php');
	DB::$connFile = '/home/timf/www/php/dbsettings.php';
	
	//
	$action = $_REQUEST['action'];
	switch($action) {
		case "dispUserInputForm":
			dispUserInputForm();
			break;

		case "saveUserInputForm":
			$tmp = saveUserInputForm();
			redirect("dispPartnerInputForm&id=$tmp");
			break;

		case "dispUserChangeForm":
			dispUserChangeForm();
			break;

		case "saveUserChangeForm":
			$tmp = saveUserChangeForm();
			redirect("dispUserChangeForm&id=$tmp");
			break;

		case "dispPartnerInputForm":
			dispPartnerInputForm();
			break;

		case "savePartnerInputForm":
			$tmp = savePartnerInputForm();
			$loc = (is_error_code($tmp)) ? "dispPartnerInputForm&id=$tmp" : "dispPartnerChangeForm&id=$tmp";
			redirect($loc);
			break;

		case "dispPartnerChangeForm":
			dispPartnerChangeForm();
			break;

		case "savePartnerChangeForm":
			savePartnerChangeForm();
			redirect("dispPartnerChangeForm");
			break;

		case "login":
			login();
			break;

		case "login_eval":
			login_eval();
			break;

		case "logout":
			logout();
			redirect("login");
			break;

		default:
			prtheader("Redirecting..."); 
			redirect('login'); 
			break;
	};
	
	//'Tool'-functions  -------------------------------------------------------------------------------------------------------------------------------------------------
	function id_cookie() {
		if(isset($_COOKIE['user_id']))  {
			$id = $_COOKIE['user_id'];
		} else if (isset($_REQUEST['id'])) {
			$id = $_REQUEST['id'];
			setcookie('user_id',$id);

		}
		return $id;
	}
	function redirect($new_action) {
		header("Location: http://timf.informatik-sgh.de/php/affentheater.php?action=$new_action");
	}
	function set_selected($a, $b) {
		if (is_array($b)) return (in_array($a, $b)) ? "<option selected>$a</option>" : "<option>$a</option>";
		else return ($a == $b) ? "<option selected>$a</option>" : "<option>$a</option>";
	}
	function GenderArray($m,$mf,$f) {
		if(isset($m) && isset($mf) && isset($f)) {return "m, mf, f";}
		if(!isset($m) && !isset($mf) && !isset($f)) {return "m, mf, f";}
		if(!isset($m) && isset($mf) && isset($f)) {return "mf, f";}
		if(isset($m) && isset($mf) && !isset($f)) {return "m, mf";}
		if(!isset($m) && !isset($mf) && isset($f)) {return "f";}
		if(!isset($m) && isset($mf) && !isset($f)) {return "mf";}
		if(!isset($m) && !isset($mf) && isset($f)) {return "m";}
	}
	function ArrayBuilder($array) {
		if (is_array($array)) {
			return implode(', ', $array); 
		}
	}
	function DBtoPHPArray($array) {
		$array = str_replace('"', '', $array); 
		$array = explode(",", $array);
		return $array;
	}
	function check_save_error($id) {
		$errortext = ($id == "e_1") ? "failed to save data: invalid id" : '';
		return $errortext;
	}
	function is_error_code($id){
		return (strpos($id, 'e_') !== false) ? true : false;
	}
	function logout_button(){
		return "<form action='affentheater.php' method='get'><input type='hidden' name='action' value='logout'><input type='submit' value='logout'></from>";
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

	//'Worker'-functions  -------------------------------------------------------------------------------------------------------------------------------------------------
	function dispUserInputForm() {
		prtheader("User Input Form");
		echo "
			<section>
				<p>User Input Form</p>
				<article>
					<form action='affentheater.php' method='get'><p>
						<input type='hidden' name='action' value='saveUserInputForm'>
<pre>Name: 		<input type='text' name='name'>
Gender:		<input type='radio' name='sex' value='m'>m <input type='radio' name='sex' value='mf'>mf <input type='radio' name='sex' value='f'>f
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
	</body>
</html>";
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function saveUserInputForm() {
		$db = DB::singleton();
		try {
			//fetch user data from url
			$name = (isset($_REQUEST['name']) && !empty($_REQUEST['name'])) ? $_REQUEST['name'] : 'unknown';
			$sex = (isset($_REQUEST['sex']) && !empty($_REQUEST['sex'])) ? $_REQUEST['sex'] : "mf";
			$bday = (isset($_REQUEST['bday']) && !empty($_REQUEST['bday'])) ? $_REQUEST['bday'] : "0001-01-01";
			$hcolor = (isset($_REQUEST['hcolor']) && !empty($_REQUEST['hcolor'])) ? $_REQUEST['hcolor'] : "blond";
			$ecolor = (isset($_REQUEST['ecolor']) && !empty($_REQUEST['ecolor'])) ? $_REQUEST['ecolor'] : "blue";
			$body = (isset($_REQUEST['body']) && !empty($_REQUEST['body'])) ? $_REQUEST['body'] : "athletic";
			$city = (isset($_REQUEST['city']) && !empty($_REQUEST['city'])) ? $_REQUEST['city'] : "unknown";
			$hobbies = (isset($_REQUEST['hobbies']) && !empty($_REQUEST['hobbies'])) ? $_REQUEST['hobbies'] : "unknown";

			//fetching latest id from db (due to certian issues...)
			$querya = "SELECT id FROM dbuser ORDER BY id DESC";
			$res = $db->doQuery($querya);
			$row = pg_fetch_array($res);
			$id = $row['id'] + 1;

			//constructing an running query to input data into the database
			$queryb = "INSERT INTO dbuser (id,name,sex,bday,hcolor,ecolor,body,city,hobbies) " .
					 "VALUES ('$id','$name','$sex','$bday','$hcolor','$ecolor','$body','$city','$hobbies')";
			$db->doQuery($queryb);

			return $id;
		} catch (Exception $e) {
			echo "$e <br>\n";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function dispUserChangeForm() {
		$db = DB::singleton();
		$id = id_cookie();
		if(isset($id) && !empty($id)) {
			$query = "SELECT * FROM dbuser WHERE id = $id";
			$res = $db->doQuery($query);
			$row = pg_fetch_array($res);
				$name = $row['name'];
				$sex = $row['sex'];
				$bday = $row['bday'];
				$hcolor = $row['hcolor'];
				$ecolor = $row['ecolor'];
				$body = $row['body'];
				$city = $row['city'];
				$hobbies = $row['hobbies'];

			if($sex == "m") {
				$gender_line = "Gender:		<input type='radio' name='sex' value='m' checked=CHECKED>m <input type='radio' name='sex' value='mf'>mf <input type='radio' name='sex' value='f'>f";
			} else if($sex == "f") {
				$gender_line = "Gender:		<input type='radio' name='sex' value='m'>m <input type='radio' name='sex' value='mf'>mf <input type='radio' name='sex' value='f' checked=CHECKED>f";
			} else {
				$gender_line = "Gender:		<input type='radio' name='sex' value='m'>m <input type='radio' name='sex' value='mf' checked=CHECKED>mf <input type='radio' name='sex' value='f'>f";
			}

			//output
			prtheader("User Change Form");
			echo "
			<section>
				<p>User Change Form</p>
				<article>
					<form action='affentheater.php' method='get'><p>
						<input type='hidden' name='action' value='saveUserChangeForm'>
						<input type='hidden' name='id' value='$id'>
<pre>Name: 		<input type='text' name='name' value='$name'>
$gender_line
Birthday: 	<input type='date' name='bday' value='$bday'>
Haircolor: 	<select name='hcolor' size='1'>
				" . set_selected('blond',$hcolor) ."
				" . set_selected('dark blond',$hcolor) ."
				" . set_selected('red',$hcolor) . "
				" . set_selected('auburn',$hcolor) . "
				" . set_selected('brown',$hcolor) . "
				" . set_selected('dark brown',$hcolor) . "
				" . set_selected('black',$hcolor) . "
				" . set_selected('rainbow',$hcolor) . "
			</select>
Eyecolor:		<select name='ecolor' size='1'>
				" . set_selected('blue',$ecolor) ."
				" . set_selected('teal',$ecolor) ."
				" . set_selected('green',$ecolor) ."
				" . set_selected('gray',$ecolor) ."
				" . set_selected('brown',$ecolor) ."
				" . set_selected('black',$ecolor) ."
			</select>
Body:		<select name='body' size='1'>
				" . set_selected('athletic',$body) ."
				" . set_selected('skinny',$body) ."
				" . set_selected('slim',$body) ."
				" . set_selected('average',$body) ."
				" . set_selected('muscular',$body) ."
				" . set_selected('belly',$body) ."
				" . set_selected('stocky',$body) ."
			</select>
City:		<input type='text' name='city' value='$city'>
Hobbies:		<input type='text' name='hobbies' value='$hobbies'>
<input type='submit'></pre>
					</p></form>" . logout_button() . "
				</action>
			</section>
		<main>
	</body>
</html>";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function saveUserChangeForm() {
		$db = DB::singleton();
		try {
			//fetch user data from url
			$id = id_cookie();
			if(isset($id)){
				$name = (isset($_REQUEST['name']) && !empty($_REQUEST['name'])) ? $_REQUEST['name'] : 'unknown';
				$sex = (isset($_REQUEST['sex']) && !empty($_REQUEST['sex'])) ? $_REQUEST['sex'] : "mf";
				$bday = (isset($_REQUEST['bday']) && !empty($_REQUEST['bday'])) ? $_REQUEST['bday'] : "0001-01-01";
				$hcolor = (isset($_REQUEST['hcolor']) && !empty($_REQUEST['hcolor'])) ? $_REQUEST['hcolor'] : "blond";
				$ecolor = (isset($_REQUEST['ecolor']) && !empty($_REQUEST['ecolor'])) ? $_REQUEST['ecolor'] : "blue";
				$body = (isset($_REQUEST['body']) && !empty($_REQUEST['body'])) ? $_REQUEST['body'] : "athletic";
				$city = (isset($_REQUEST['city']) && !empty($_REQUEST['city'])) ? $_REQUEST['city'] : "unknown";
				$hobbies = (isset($_REQUEST['hobbies']) && !empty($_REQUEST['hobbies'])) ? $_REQUEST['hobbies'] : "unknown";

				//constructing an running query to input data into the database
				$queryb = "UPDATE dbuser SET name = '$name', sex = '$sex', bday = '$bday', hcolor = '$hcolor', ecolor = '$ecolor', body = '$body', city = '$city', hobbies = '$hobbies' WHERE id = $id";
				$db->doQuery($queryb);

				return $id;				
			} else {
				return $id;
			}
		} catch (Exception $e) {
			echo "$e <br>\n";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function dispPartnerInputForm(){
		$id = id_cookie();
		if(isset($id) && !empty($id)) {
			prtheader("Partner Input Form");
			echo "
			<section>
				<p>Partner Input Form</p>
				<article>" . check_save_error($id) . "
					<form action='affentheater.php' method='get'><p>
						<input type='hidden' name='action' value='savePartnerInputForm'>
						<input type='hidden' name='id' value='$id'>
<pre>Gender:		<input type='radio' name='psex_m' value='m'>m <input type='radio' name='psex_mf' value='mf'>mf <input type='radio' name='psex_f' value='f'>f
Age range: 	<input type='number' name='page_min' min='1' step='1'> -> <input type='number' name='page_max' min='1' step='1'>
Size range:	<input type='number' name='psize_min' min='1' step='1'> -> <input type='number' name='psize_max' min='1' step='1'>
Haircolor: 	<select name='phcolor[]' size='3' multiple>
				<option>blond</option>
				<option>dark blond</option>
				<option>red</option>
				<option>auburn</option>
				<option>brown</option>
				<option>dark brown</option>
				<option>black</option>
				<option>rainbow</option>
			</select>
Eyecolor:		<select name='pecolor[]' size='3' multiple>
				<option>blue</option>
				<option>teal</option>
				<option>green</option>
				<option>gray</option>
				<option>brown</option>
				<option>black</option>
			</select>
Body:		<select name='pbody[]' size='3' multiple>
				<option>athletic</option>
				<option>skinny</option>
				<option>slim</option>
				<option>average</option>
				<option>muscular</option>
				<option>belly</option>
				<option>stocky</option>
			</select>
Distance (in km):	<input type='number' name='distance' min='1' step='1'>
<input type='submit'></pre>
					</p></form>
				</action>
			</section>
		<main>
	</body>
</html>";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function savePartnerInputForm(){
		$db = DB::singleton();
		try {			
			$id = id_cookie();
			if(isset($id) && !empty($id)) {
				$psex_f = (isset($_REQUEST['psex_f']) && !empty($_REQUEST['psex_f'])) ? $_REQUEST['psex_f'] : "";
				$psex_mf = (isset($_REQUEST['psex_mf']) && !empty($_REQUEST['psex_mf'])) ? $_REQUEST['psex_mf'] : "";
				$psex_m = (isset($_REQUEST['psex_m']) && !empty($_REQUEST['psex_m'])) ? $_REQUEST['psex_m'] : "";
				$psex = "{ " . GenderArray($psex_m,$psex_mf,$psex_f) . " }";
				$page_min = (isset($_REQUEST['page_min']) && !empty($_REQUEST['page_min'])) ? $_REQUEST['page_min'] : "0";
				$page_max = (isset($_REQUEST['page_max']) && !empty($_REQUEST['page_max'])) ? $_REQUEST['page_max'] : "100";
				$psize_min = (isset($_REQUEST['psize_min']) && !empty($_REQUEST['psize_min'])) ? $_REQUEST['psize_min'] : "0";
				$psize_max = (isset($_REQUEST['psize_max']) && !empty($_REQUEST['psize_max'])) ? $_REQUEST['psize_max'] : "200";
				$phcolor = "{ " . ((isset($_REQUEST['phcolor']) && !empty($_REQUEST['phcolor'])) ? ArrayBuilder($_REQUEST['phcolor']) : "blond") . " }";
				$pecolor = "{ " . ((isset($_REQUEST['pecolor']) && !empty($_REQUEST['pecolor'])) ? ArrayBuilder($_REQUEST['pecolor']) : "blue") . " }";
				$pbody = "{ " . ((isset($_REQUEST['pbody']) && !empty($_REQUEST['pbody'])) ? ArrayBuilder($_REQUEST['pbody']) : "athletic") . " }";
				$distance = (isset($_REQUEST['distance']) && !empty($_REQUEST['distance'])) ? $_REQUEST['distance'] : "unknown";

				$query = "INSERT INTO partner (searcher,psex,page_min,page_max,psize_min,psize_max,phcolor,pecolor,pbody,distance) " .
						 "VALUES ('$id','$psex','$page_min','$page_max','$psize_min','$psize_max','$phcolor','$pecolor','$pbody','$distance')";
				$db->doQuery($query);
			} else { $id = "e_1"; }

			return $id;
		} catch (Exception $e) {
			echo "$e <br>\n";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function dispPartnerChangeForm(){
		$db = DB::singleton();
		$id = id_cookie();
		if(isset($id) && !empty($id)) {
			$query = "SELECT * FROM partner WHERE searcher = $id";
			$res = $db->doQuery($query);
			$row = pg_fetch_array($res);
				$psex = $row['psex'];
				$page_min = $row['page_min'];
				$page_max = $row['page_max'];
				$psize_min = $row['psize_min'];
				$psize_max = $row['psize_max'];
				$phcolors = trim($row['phcolor'],'{}');
				$phcolor = DBtoPHPArray($phcolors);
				$pecolors = trim($row['pecolor'],'{}');
				$pecolor = DBtoPHPArray($pecolors);
				$pbodys = trim($row['pbody'],'{}');
				$pbody = DBtoPHPArray($pbodys);
				$distance = $row['distance'];


			if($psex == "m") {
				$gender_line = "Gender:		<input type='radio' name='psex_m' value='m' checked=CHECKED>m <input type='radio' name='psex_mf' value='mf'>mf <input type='radio' name='psex_f' value='f'>f";
			} else if($psex == "f") {
				$gender_line = "Gender:		<input type='radio' name='psex_m' value='m'>m <input type='radio' name='psex_mf' value='mf'>mf <input type='radio' name='psex_f' value='f' checked=CHECKED>f";
			} else {
				$gender_line = "Gender:		<input type='radio' name='psex_m' value='m'>m <input type='radio' name='psex_mf' value='mf' checked=CHECKED>mf <input type='radio' name='psex_f' value='f'>f";
			}

			prtheader("Partner Change Form");
			echo "
			<section>
				<p>Partner Change Form</p>
				<article>
					<form action='affentheater.php' method='get'><p>
						<input type='hidden' name='action' value='savePartnerChangeForm'>
						<input type='hidden' name='id' value='$id'>
<pre>" . $gender_line . "
Age range: 	<input type='number' name='page_min' min='1' step='1' value='$page_min'> -> <input type='number' name='page_max' min='1' step='1' value='$page_max'>
Size range:	<input type='number' name='psize_min' min='1' step='1' value='$psize_min'> -> <input type='number' name='psize_max' min='1' step='1' value='$psize_max'>
Haircolor: 	<select name='phcolor[]' size='3' multiple>
				" . set_selected('blond',$phcolor) ."
				" . set_selected('dark blond',$phcolor) ."
				" . set_selected('red',$phcolor) . "
				" . set_selected('auburn',$phcolor) . "
				" . set_selected('brown',$phcolor) . "
				" . set_selected('dark brown',$phcolor) . "
				" . set_selected('black',$phcolor) . "
				" . set_selected('rainbow',$phcolor) . "
			</select>
Eyecolor:		<select name='pecolor[]' size='3' multiple>
				" . set_selected('blue',$pecolor) ."
				" . set_selected('teal',$pecolor) ."
				" . set_selected('green',$pecolor) ."
				" . set_selected('gray',$pecolor) ."
				" . set_selected('brown',$pecolor) ."
				" . set_selected('black',$pecolor) ."
			</select>
Body:		<select name='pbody[]' size='3' multiple>
				" . set_selected('athletic',$pbody) ."
				" . set_selected('skinny',$pbody) ."
				" . set_selected('slim',$pbody) ."
				" . set_selected('average',$pbody) ."
				" . set_selected('muscular',$pbody) ."
				" . set_selected('belly',$pbody) ."
				" . set_selected('stocky',$pbody) ."
			</select>
Distance (in km):		<input type='number' name='distance' min='1' step='1' value='$distance'>
<input type='submit'></pre>
					</p></form>" . logout_button() . "
				</action>
			</section>
		<main>
	</body>
</html>";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function savePartnerChangeForm(){
		$db = DB::singleton();
		try {	
			$id = id_cookie();		
			if(isset($id) && !empty($id)) {
				$psex_f = (isset($_REQUEST['psex_f']) && !empty($_REQUEST['psex_f'])) ? $_REQUEST['psex_f'] : "";
				$psex_mf = (isset($_REQUEST['psex_mf']) && !empty($_REQUEST['psex_mf'])) ? $_REQUEST['psex_mf'] : "";
				$psex_m = (isset($_REQUEST['psex_m']) && !empty($_REQUEST['psex_m'])) ? $_REQUEST['psex_m'] : "";
				$psex = "{ " . GenderArray($psex_m,$psex_mf,$psex_f) . " }";
				$page_min = (isset($_REQUEST['page_min']) && !empty($_REQUEST['page_min'])) ? $_REQUEST['page_min'] : "0";
				$page_max = (isset($_REQUEST['page_max']) && !empty($_REQUEST['page_max'])) ? $_REQUEST['page_max'] : "100";
				$psize_min = (isset($_REQUEST['psize_min']) && !empty($_REQUEST['psize_min'])) ? $_REQUEST['psize_min'] : "0";
				$psize_max = (isset($_REQUEST['psize_max']) && !empty($_REQUEST['psize_max'])) ? $_REQUEST['psize_max'] : "200";
				$phcolor = "{ " . ((isset($_REQUEST['phcolor']) && !empty($_REQUEST['phcolor'])) ? ArrayBuilder($_REQUEST['phcolor']) : "blond") . " }";
				$pecolor = "{ " . ((isset($_REQUEST['pecolor']) && !empty($_REQUEST['pecolor'])) ? ArrayBuilder($_REQUEST['pecolor']) : "blue") . " }";
				$pbody = "{ " . ((isset($_REQUEST['pbody']) && !empty($_REQUEST['pbody'])) ? ArrayBuilder($_REQUEST['pbody']) : "athletic") . " }";
				$distance = (isset($_REQUEST['distance']) && !empty($_REQUEST['distance'])) ? $_REQUEST['distance'] : "unknown";

				$query = "UPDATE partner SET psex = '$psex', page_min = '$page_min', page_max = '$page_max', psize_min = '$psize_min', psize_max = '$psize_max', phcolor = '$phcolor', pecolor = '$pecolor', pbody = '$pbody', distance = '$distance' WHERE searcher = $id ";
				$db->doQuery($query);
			} else { $id = "e_1"; }

			return $id;
		} catch (Exception $e) {
			echo "$e <br>\n";
		}
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function login() {
		prtheader('Login - DatBook');
		echo "
			<section>
				<p>User Input Form</p>
				<article>
					<form action='affentheater.php' method='get'><p>
						<input type='hidden' name='action' value='login_eval'>
ID: 		<input type='text' name='id'>
Page:		<select name='direct' size='1'>
				<option>dispUserInputForm</option>
				<option>dispUserChangeForm</option>
				<option>dispPartnerInputForm</option>
				<option>dispPartnerChangeForm</option>
			</select>
<input type='submit'>
					</from>
				</article>
			</section>
		<main>
	</body>
</html>	";
	}
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function login_eval() {
		if(isset($_COOKIE['user_id'])) logout();
		if (isset($_REQUEST['id']) && !empty($_REQUEST['id'])) {
			$id = $_REQUEST['id'];
			setcookie('user_id', $_REQUEST['id']);
			if($_REQUEST['direct'] == "dispUserChangeForm" || $_REQUEST['direct'] == "dispPartnerChangeForm") redirect($_REQUEST['direct']);
		} else if ($_REQUEST['direct'] == "dispUserInputForm" || $_REQUEST['direct'] == "dispPartnerInputForm") redirect($_REQUEST['direct']); 
	}	
//--------------------------------------------------------------------------------------------------------------------------------------------------
	function logout() {
		setcookie('user_id', '', time() - 3600);
	}
?>
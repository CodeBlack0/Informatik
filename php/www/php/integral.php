<html>
	<head>
		<title>Tim's page</title>
		<meta charset="UTF-8">		
		<link rel="stylesheet" type="text/css" href="../style.css">
	</head>
	<body>
		<div class="floater_top">
			<header class="banner">
				<h1>PHP DB Demo</h1>
			</header>
			<nav>
				<ul>
					<li><a href="http://timf.informatik-sgh.de">back</a></li><li>
					<a href="http://musil.informatik-sgh.de">Informatik</a></li><li>
					<a href="#top">Top</a></li>
				</ul>
			</nav>
		</div>
		<main>
			<a Name="top" class="top_mark"></a>
			<section>
				<article>
					<p> <h3>solid function: f(x)= sin(x) * x^4 +cos(x)*x^3</h3> <br></p>
					<form action="integral.php" mwthod="GET">
						<p>Stepwidth<br><input name="STEPWIDTH" type="text" size="30" value=<?php if(!isset($_GET['STEPWIDTH'])){echo 0.1;} else {echo $_GET['STEPWIDTH'];}?>></p>
						<p>Lowerlimit<br><input name="LOWERLIMIT" type="text" size="30" value=<?php if(!isset($_GET['LOWERLIMIT'])){echo 0;} else {echo $_GET['LOWERLIMIT'];}?>></p>
						<p>Upperlimit<br><input name="UPPERLIMIT" type="text" size="30" value=<?php if(!isset($_GET['UPPERLIMIT'])){echo 1;} else {echo $_GET['UPPERLIMIT'];}?>></p>
						<p><br><input type="submit"></p>
					</form>
				</article>
				<article>
					<?php
						require_once( dirname(__FILE__) . '/math.php');
						if(!isset($_GET['STEPWIDTH'])){$STEPWIDTH = 0.1;} else { $STEPWIDTH = $_GET['STEPWIDTH'];}
						if(!isset($_GET['LOWERLIMIT'])){$LOWERLIMIT = 0;} else { $LOWERLIMIT = $_GET['LOWERLIMIT'];}
						if(!isset($_GET['UPPERLIMIT'])){$UPPERLIMIT = 1;} else { $UPPERLIMIT = $_GET['UPPERLIMIT'];}
						$f = new addfunc(new multfunc(new sinfunc(1,0,0,0), new tesfunc(1,0,0,0,0)), new multfunc(new cosfunc(1,0,0,0), new cubfunc(1,0,0,0)));
						$res = calc::integral($STEPWIDTH,$LOWERLIMIT,$UPPERLIMIT,$f);					
						echo ("<input value='" . $res . "' type='text' size='30' name='integral'>");
					?>
				</article>
			</section>
		</main>
	</body>
</html>
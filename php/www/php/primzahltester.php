<?php
	function primtest(){
		$primetest = $_REQUEST['primzahl'];
		if ($primetest == 1 || $primetest == 0) { return false; }
        $maxtest = sqrt($primetest);

        for ($i = 2; $i <= $maxtest; ++$i) {
                if ($primetest % $i == 0) {
                        return false;
                }
        }
        return true;
	}

	if (primtest()) {
		echo "ist prim";
	} else {
		echo "ist nicht prim";
	}	
?>
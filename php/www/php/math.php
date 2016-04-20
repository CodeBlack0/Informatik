<?php
	/* SQUARE FUNCTION CLASS*/
	class sqrfunc {
		public $a = 1;
		public $b = 1;
		public $c = 0;

		public function __construct($A, $B, $C) {
			$this->a = $A;
			if ($this->a == 0) {$this->a = 1;}
			$this->b = $B;
			$this->c = $C;
		}

		public function f($x) {
			return $this->a * pow($x, 2) + $this->b * $x + $this->c;
		}
	}
	/* CUBIC FUNCTION CLASS*/
	class cubfunc {
		public $a = 1;
		public $b = 1;
		public $c = 1;
		public $d = 0;

		public function __construct($A, $B, $C, $D) {
			$this->a = $A;
			if ($this->a == 0) {$this->a = 1;}
			$this->b = $B;
			$this->c = $C;
			$this->d = $D;
		}

		public function f($x) {
			return $this->a * pow($x, 3) + $this->b * pow($x, 2) + $this->c * $x + $this->d;
		}
	}
	/* TESERACT FUNCTION CLASS*/
	class tesfunc {
		public $a = 1;
		public $b = 1;
		public $c = 1;
		public $d = 1;
		public $e = 0;

		public function __construct($A, $B, $C, $D, $E) {
			$this->a = $A;
			if ($this->a == 0) {$this->a = 1;}
			$this->b = $B;
			$this->c = $C;
			$this->d = $D;
			$this->e = $E;
		}

		public function f($x) {
			return $this->a * pow($x, 4) + $this->b * pow($x, 3) + $this->c * pow($x, 2) + $this->d * $x + $this->e;
		}
	}
	/* SINUS FUNCTION CLASS*/
	class sinfunc {
		public $a = 1;
		public $b = 1;
		public $c = 0;
		public $d = 0;

		public function __construct($A, $B, $C, $D) {
			$this->a = $A;
			if ($this->a == 0) {$this->a = 1;}
			$this->b = $B;
			if ($this->b == 0) {$this->b = 1;}
			$this->c = $C;
			$this->d = $D;
		}

		public function f($x) {
			return $this->a * sin($this->b * $x + $this->c) + $this->d;
		}
	}
	/* COSNIUS FUNCTION CLASS*/
	class cosfunc {
		public $a = 1;
		public $b = 1;
		public $c = 0;
		public $d = 0;

		public function __construct($A, $B, $C, $D) {
			$this->a = $A;
			if ($this->a == 0) {$this->a = 1;}
			$this->b = $B;
			if ($this->b == 0) {$this->b = 1;}
			$this->c = $C;
			$this->d = $D;
		}

		public function f($x) {
			return $this->a * cos($this->b * $x + $this->c) + $this->d;
		}
	}
	/* ADD FUNCTION CLASS*/
	class addfunc {
		public $a;
		public $b;

		public function __construct($A, $B) {
			$this->a = $A;
			$this->b = $B;
		}

		public function f($x) {
			return $this->a->f($x) + $this->b->f($x);
		}
	}
	/* SUBTRACT FUNCTION CLASS */
	class subfunc {
		public $a;
		public $b;

		public function __construct($A, $B) {
			$this->a = $A;
			$this->b = $B;
		}

		public function f($x) {
			return $this->a->f($x) - $this->b->f($x);
		}
	}
	/* MULTIPLY FUNCTION CLASS*/
	class multfunc {
		public $a;
		public $b;

		public function __construct($A, $B) {
			$this->a = $A;
			$this->b = $B;
		}

		public function f($x) {
			return $this->a->f($x) * $this->b->f($x);
		}
	}
	/* DIVIDE FUNCTION CLASS */
	class divfunc {
		public $a;
		public $b;

		public function __construct($A, $B) {
			$this->a = $A;
			$this->b = $B;
		}

		public function f($x) {
			return $this->a->f($x) + $this->b->f($x);
		}
	}
	/* CALCULATOR CLASS */
	class calc {
		function integral($stepWidth, $lowerLimit, $upperLimit, $f) {
			$int = 0;

			for ($i = $lowerLimit; $i <= $upperLimit; $i += $stepWidth) {
				$int += $f->f($i) * $stepWidth;
			}

			return $int;
		}		
	}
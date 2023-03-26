<?php

if (!isset($argv)) exit;

include ("/usr/local/vesta/func/main.php");
include ("/usr/local/vesta/func/string.php");

$counter=count($argv);
if ($counter<1) myvesta_throw_error(2, 'Function is missing');

$func="myvesta_".$argv[1];
if (!function_exists($func)) myvesta_throw_error(2, 'Function does not exists');

$params=array();

for ($i=2; $i<$counter; $i++) {
	$argv[$i]=myvesta_fix_backslashes($argv[$i]);
	$params[]=$argv[$i];
}
// echo $func."\n"; print_r($params);
$r=call_user_func_array($func, $params);

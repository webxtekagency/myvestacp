<?php

if (!isset($argv)) exit(5);

include ("/usr/local/vesta/func/main.php");
include ("/usr/local/vesta/func/string.php");

$counter=count($argv);
if ($counter<2) myvesta_throw_error(2, 'Function is missing');

$func=$argv[1];
if (!function_exists($func)) {
    $func="myvesta_".$argv[1];    
    if (!function_exists($func)) myvesta_throw_error(2, 'Function does not exists');
}

$params=array();

for ($i=2; $i<$counter; $i++) {
    $argv[$i]=myvesta_fix_backslashes($argv[$i]);
    $params[]=$argv[$i];
}

$r=call_user_func_array($func, $params);
if (is_bool($r)) {
    if ($r) {
        exit(0);
    } else {
        exit(MYVESTA_ERROR_GENERAL);
    }
} else {
    echo $r;
    exit(0);
}
